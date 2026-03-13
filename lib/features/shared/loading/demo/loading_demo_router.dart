import 'package:go_router/go_router.dart';
import 'package:wishing_well/features/shared/loading/demo/loading_demo_screen.dart';
import 'package:wishing_well/routing/transitions.dart';

class LoadingDemoRouteConfig {
  static const String path = '/loading-demo';
}

GoRouter loadingDemoRouter() => GoRouter(
  initialLocation: LoadingDemoRouteConfig.path,
  routes: [
    GoRoute(
      path: LoadingDemoRouteConfig.path,
      name: 'loadingDemo',
      pageBuilder: (context, state) => const CustomTransitionPage(
        child: LoadingDemoScreen(),
        transitionsBuilder: slideUpWithParallaxTransition,
      ),
    ),
  ],
);
