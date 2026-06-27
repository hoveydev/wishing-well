import 'dart:async';
import 'package:wishing_well/app_event.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';
import 'package:wishing_well/utils/app_logger.dart';

typedef NavigateFn =
    void Function(String routeName, Map<String, dynamic>? queryParameters);

typedef ErrorFn = void Function(DeepLinkErrorType type);

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

  Future<void> _handleUri(Uri uri) async {
    final type = uri.queryParameters['type'];
    AppLogger.debug(
      'Deep link detected: type=$type, uri=$uri',
      context: 'DeepLinkHandler',
    );

    switch (type) {
      case 'account_confirm':
        _controller.add(ShowAccountConfirmation());
        break;

      // I don't think this will work because the password reset link is handled
      // by the Supabase SDK, but leaving it here for now in case we
      // need to handle it ourselves in the future.
      case 'password_reset':
        _controller.add(NavigateToResetPassword());
        break;

      // default:
      //   _controller.add(ShowDeepLinkError(DeepLinkErrorType.invalid));

      default:
        return;
    }
  }

  @override
  Stream<AppEvent> get events => _controller.stream;

  @override
  Future<void> init() async {
    final initialUri = await _source.initial();

    if (initialUri != null) {
      await _handleUri(initialUri);
    }

    _subscription = _source.stream().listen((uri) async {
      if (uri != null) {
        await _handleUri(uri);
      }
    });
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }
}
