import 'package:go_router/go_router.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/all_wishers/all_wishers_screen.dart';
import 'package:wishing_well/features/all_wishers/all_wishers_view_model.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/routing/transitions.dart';

GoRouter allWishersDemoRouter(WisherRepository wisherRepository) => GoRouter(
  initialLocation: Routes.allWishers.path,
  routes: [
    GoRoute(
      path: Routes.allWishers.path,
      name: Routes.allWishers.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: AllWishersScreen(
          viewModel: AllWishersViewModel(wisherRepository: wisherRepository),
        ),
        transitionsBuilder: noTransition,
      ),
    ),
  ],
);
