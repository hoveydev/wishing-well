import 'dart:async';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';

typedef NavigateFn =
    void Function(String routeName, Map<String, dynamic>? queryParameters);

typedef ErrorFn = void Function(DeepLinkErrorType type);

/// Typed error category emitted by [DeepLinkHandler] when a deep link fails.
///
/// The UI layer is responsible for mapping these values to user-visible,
/// localized strings.
enum DeepLinkErrorType {
  /// The link was a password-reset link that has expired or is invalid.
  passwordReset,

  /// The link was an account-confirmation link that has expired or is invalid.
  accountConfirm,

  /// The link contained an error but could not be classified.
  unknown,
}

class DeepLinkHandler {
  DeepLinkHandler(
    this.navigate, {
    required this.source,
    this.passwordRecovery,
    this.accountConfirmationController,
    this.onError,
  });
  final NavigateFn navigate;
  final DeepLinkSource source;
  ErrorFn? onError;

  /// Emits the user's email when a password recovery auth event is received.
  ///
  /// Password reset navigation is handled via Supabase's auth state change
  /// rather than URI parsing to avoid a race condition where GoRouter
  /// processes the initial deep link URL and redirects back to login after
  /// our URI-based navigation fires.
  final Stream<String?>? passwordRecovery;

  /// Controller for account confirmation events. Allows the handler to emit
  /// when account confirmation URIs are detected (both initial and ongoing).
  final StreamController<String>? accountConfirmationController;

  StreamSubscription? _sub;
  StreamSubscription? _recoverySub;

  /// Sets the error handler callback for deep link errors.
  ///
  /// This must be called before [init()] to ensure errors are properly handled
  /// when deep links are processed.
  void setErrorHandler(ErrorFn handler) {
    onError = handler;
  }

  void init() {
    _handleInitialUri();
    _sub = source.stream().listen((uri) {
      if (uri != null) _navigateFromUri(uri);
    });
    _recoverySub = passwordRecovery?.listen((email) {
      navigate(Routes.resetPassword.name, {'email': email});
    });
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await source.initial();
      AppLogger.debug(
        'Initial URI: $uri',
        context: 'DeepLinkHandler._handleInitialUri',
      );
      if (uri != null) {
        _navigateFromUri(uri);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error handling initial URI',
        context: 'DeepLinkHandler._handleInitialUri',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _navigateFromUri(Uri uri) {
    // First, check for error query params (these can come on any path)
    if (uri.queryParameters.containsKey('error')) {
      // Extract the path segment to determine error type (if it's an auth path)
      final subPath = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
      _navigateToDeepLinkError(subPath, uri.queryParameters);
      return;
    }

    if (uri.pathSegments.isEmpty) return;
    if (uri.pathSegments.first != 'auth') return;

    final subPath = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;

    // Account confirmation with type=signup is handled via the controller.
    // Other account-confirm URLs (without type or with different type) are
    // treated as errors.
    switch (subPath) {
      case 'account-confirm':
        AppLogger.debug(
          'Account confirm URI detected, type=${uri.queryParameters['type']}',
          context: 'DeepLinkHandler._navigateFromUri',
        );
        accountConfirmationController?.add('');
        break;
    }
  }

  /// Derives a typed [DeepLinkErrorType] from [subPath] and invokes [onError].
  void _navigateToDeepLinkError(
    String? subPath,
    Map<String, String> queryParameters,
  ) {
    final errorType = switch (subPath) {
      'password-reset' => DeepLinkErrorType.passwordReset,
      'account-confirm' => DeepLinkErrorType.accountConfirm,
      _ => DeepLinkErrorType.unknown,
    };
    onError?.call(errorType);
  }

  void dispose() {
    _sub?.cancel();
    _recoverySub?.cancel();
  }
}
