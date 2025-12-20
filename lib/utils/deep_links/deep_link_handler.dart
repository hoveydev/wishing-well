import 'dart:async';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';

typedef NavigateFn = void Function(String routeName);

class DeepLinkHandler {
  final NavigateFn navigate;
  final DeepLinkSource source;
  StreamSubscription? _sub;

  DeepLinkHandler(this.navigate, {required this.source});

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
    } catch (_) {}
  }

  void _navigateFromUri(Uri uri) {
    if (uri.pathSegments.isEmpty) return;
    if (uri.pathSegments.first != 'auth') return;

    final subPath = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;

    switch (subPath) {
      case 'confirm':
        navigate(
          uri.queryParameters['type'] == 'signup'
              ? Routes.createAccountConfirm
              : Routes.forgotPasswordConfirm,
        );
        break;
      case 'reset':
        navigate(Routes.forgotPassword);
        break;
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
