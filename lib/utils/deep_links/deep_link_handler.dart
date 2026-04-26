import 'dart:async';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';

typedef NavigateFn =
    void Function(String routeName, Map<String, dynamic>? queryParameters);

typedef ErrorFn = void Function(String message);

class DeepLinkHandler {
  DeepLinkHandler(
    this.navigate, {
    required this.source,
    this.passwordRecovery,
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
      if (uri != null) {
        _navigateFromUri(uri);
      }
    } catch (e) {
      AppLogger.error(
        'Error handling initial URI: $e',
        context: 'DeepLinkHandler._handleInitialUri',
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

    switch (subPath) {
      case 'account-confirm':
        if (uri.queryParameters['type'] == 'signup') {
          navigate(Routes.login.name, {'accountConfirmed': 'true'});
        } else {
          _navigateToDeepLinkError(subPath, uri.queryParameters);
        }
        break;
    }
  }

  /// Shows a deep link error using StatusOverlay.
  void _navigateToDeepLinkError(
    String? subPath,
    Map<String, String> queryParameters,
  ) {
    const errorMessage =
        'This link has expired or is no longer valid. Please return to the '
        'login screen and resubmit for a new link.';
    onError?.call(errorMessage);
  }

  void dispose() {
    _sub?.cancel();
    _recoverySub?.cancel();
  }
}
