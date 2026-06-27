import 'dart:async';
import 'package:wishing_well/app_event.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';
import 'package:wishing_well/utils/app_logger.dart';

typedef NavigateFn =
    void Function(String routeName, Map<String, dynamic>? queryParameters);

typedef ErrorFn = void Function(DeepLinkErrorType type);

enum DeepLinkType {
  /// The link is not recognized as a valid deep link.
  unknown(''),

  /// The link is a password-reset link.
  passwordReset('auth/password-reset'),

  /// The link is an account confirmation link.
  accountConfirm('auth/account-confirm');

  const DeepLinkType(this.name);
  final String name;

  static DeepLinkType fromUrl(Uri? uri) {
    if (uri == null || uri.pathSegments.isEmpty) return DeepLinkType.unknown;

    final lookupPath = uri.pathSegments.join('/');

    return DeepLinkType.values.firstWhere(
      (route) => route.name == lookupPath,
      orElse: () => DeepLinkType.unknown,
    );
  }
}

enum DeepLinkErrorType {
  /// The link was a password-reset link that has expired or is invalid.
  passwordReset,

  /// The link contained an error but could not be classified.
  unknown,

  /// The link was invalid or could not be processed.
  invalid,
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

      default:
        _controller.add(ShowDeepLinkError(DeepLinkErrorType.invalid));
    }
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
