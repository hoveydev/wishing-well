import 'package:go_router/go_router.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/routing/transitions.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';

GoRouter addWisherDemoRouter(WisherRepository wisherRepository) => GoRouter(
  initialLocation: Routes.addWisher.path,
  routes: [
    GoRoute(
      path: Routes.addWisher.path,
      name: Routes.addWisher.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: AddWisherLandingScreen(viewModel: AddWisherLandingViewModel()),
        transitionsBuilder: slideUpWithParallaxTransition,
      ),
      routes: [
        GoRoute(
          path: Routes.addWisherDetails.path,
          name: Routes.addWisherDetails.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: AddWisherDetailsScreen(
              viewModel: AddWisherDetailsViewModel(
                wisherRepository: wisherRepository,
                userId: 'demo-user',
              ),
            ),
            transitionsBuilder: slideInRightTransition,
          ),
        ),
      ],
    ),
  ],
);
