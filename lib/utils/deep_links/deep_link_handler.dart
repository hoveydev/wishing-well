import 'dart:async';
import 'dart:developer';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';

typedef NavigateFn =
    void Function(String routeName, Map<String, dynamic>? queryParameters);

class DeepLinkHandler {
  DeepLinkHandler(this.navigate, {required this.source});
  final NavigateFn navigate;
  final DeepLinkSource source;
  StreamSubscription? _sub;

  void init() {
    _handleInitialUri();
    _sub = source.stream().listen((uri) {
      if (uri != null) _navigateFromUri(uri);
    });
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await source.initial();
      if (uri != null) _navigateFromUri(uri);
      // coverage:ignore-start
    } catch (e, stackTrace) {
      // Error case not covered in tests
      log('Error handling initial URI: $e', stackTrace: stackTrace);
    }
    // coverage:ignore-end
  }

  void _navigateFromUri(Uri uri) {
    if (uri.pathSegments.isEmpty) return;
    if (uri.pathSegments.first != 'auth') return;

    final subPath = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;

    switch (subPath) {
      case 'account-confirm':
        if (uri.queryParameters['type'] == 'signup') {
          navigate(Routes.accountConfirm.name, null);
        } else {
          log(
            'unrecognized type parameter (or it may not exist) '
            '- routed to unknown route',
          );
          navigate('unknown', null);
        }
        break;
      case 'password-reset':
        navigate(Routes.resetPassword.name, {
          'email': uri.queryParameters['email'],
          'token': uri.queryParameters['code'],
        });
        break;
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
