import 'dart:async';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';

typedef NavigateFn =
    void Function(String routeName, Map<String, dynamic>? queryParameters);

class DeepLinkHandler {
  DeepLinkHandler(this.navigate, {required this.source, this.passwordRecovery});
  final NavigateFn navigate;
  final DeepLinkSource source;

  /// Emits the user's email when a password recovery auth event is received.
  ///
  /// Password reset navigation is handled via Supabase's auth state change
  /// rather than URI parsing to avoid a race condition where GoRouter
  /// processes the initial deep link URL and redirects back to login after
  /// our URI-based navigation fires.
  final Stream<String?>? passwordRecovery;

  StreamSubscription? _sub;
  StreamSubscription? _recoverySub;

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
      if (uri != null) _navigateFromUri(uri);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error handling initial URI',
        context: 'DeepLinkHandler',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _navigateFromUri(Uri uri) {
    if (uri.pathSegments.isEmpty) return;
    if (uri.pathSegments.first != 'auth') return;

    final subPath = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;

    switch (subPath) {
      case 'account-confirm':
        if (uri.queryParameters['type'] == 'signup') {
          navigate(Routes.login.name, {'accountConfirmed': 'true'});
        } else {
          AppLogger.warning(
            'Unrecognized type parameter (or it may not exist) - '
            'not navigating',
            context: 'DeepLinkHandler._navigateFromUri',
          );
        }
        break;
    }
  }

  void dispose() {
    _sub?.cancel();
    _recoverySub?.cancel();
  }
}
