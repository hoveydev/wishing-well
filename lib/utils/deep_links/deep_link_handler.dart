import 'dart:async';
import 'package:wishing_well/app_event.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';
import 'package:wishing_well/utils/app_logger.dart';

typedef NavigateFn =
    void Function(String routeName, Map<String, dynamic>? queryParameters);

typedef ErrorFn = void Function(DeepLinkErrorType type);

enum DeepLinkType {
  /// No link detected.
  none(null),

  /// The link is not recognized as a valid deep link.
  unknown(null),

  /// The link is a password-reset link.
  passwordReset('auth/password-reset'),

  /// The link is an account confirmation link.
  accountConfirm('auth/account-confirm'),

  /// The link contains an error.
  error(null);

  const DeepLinkType(this.name);
  final String? name;

  static DeepLinkType fromUrl(Uri? uri) {
    if (uri == null || uri.pathSegments.isEmpty) return DeepLinkType.none;

    if (uri.queryParameters.containsKey('error')) {
      return DeepLinkType.error;
    }

    final lookupPath = uri.pathSegments.join('/');

    return DeepLinkType.values.firstWhere(
      (route) => route.name == lookupPath,
      orElse: () => DeepLinkType.unknown,
    );
  }
}

enum DeepLinkErrorType {
  /// Deep link is unknown or unrecognized.
  unknown(null),

  /// Unrecognized error type.
  generic('generic'),

  /// The user does not have permission to access the link
  /// or the link is expired.
  accessDenied('access_denied');

  // each has 'error' 'error_code' and 'error_description' query parameters

  const DeepLinkErrorType(this.type);
  final String? type;

  static DeepLinkErrorType fromErrorType(String? errorType) =>
      DeepLinkErrorType.values.firstWhere(
        (error) => error.type == errorType,
        orElse: () => DeepLinkErrorType.generic,
      );
}

abstract class DeepLinkHandler {
  Stream<AppEvent> get events;
  Future<void> init();
  Future<void> dispose();
}

class DeepLinkHandlerImpl implements DeepLinkHandler {
  DeepLinkHandlerImpl({required DeepLinkSource source}) : _source = source;
  final DeepLinkSource _source;
  final StreamController<AppEvent> _controller =
      StreamController<AppEvent>.broadcast();

  StreamSubscription? _subscription;

  Future<void> _handleUri(Uri? uri) async {
    final type = DeepLinkType.fromUrl(uri);
    AppLogger.debug(
      'Deep link detected: type=$type, uri=$uri',
      context: 'DeepLinkHandler',
    );

    switch (type) {
      case DeepLinkType.accountConfirm:
        _controller.add(ShowAccountConfirmation());
        break;

      case DeepLinkType.passwordReset:
        _controller.add(NavigateToResetPassword());
        break;

      case DeepLinkType.error:
        _handleErrorLink(uri!);
        break;

      case DeepLinkType.unknown:
        _controller.add(ShowDeepLinkError(DeepLinkErrorType.unknown));
        break;

      case DeepLinkType.none:
        return;
    }
  }

  void _handleErrorLink(Uri uri) {
    final errorType = uri.queryParameters['error'];
    _controller.add(
      ShowDeepLinkError(DeepLinkErrorType.fromErrorType(errorType)),
    );
  }

  @override
  Stream<AppEvent> get events => _controller.stream;

  @override
  Future<void> init() async {
    final initialUri = await _source.initial();

    await _handleUri(initialUri);

    _subscription = _source.stream().listen((uri) async {
      await _handleUri(uri);
    });
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }
}
