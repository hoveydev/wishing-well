import 'package:go_router/go_router.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/routing/transitions.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_screen.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_view_model.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';

GoRouter wisherDetailsDemoRouter(
  AuthRepository authRepository,
  WisherRepository wisherRepository,
  ImageRepository imageRepository,
) => GoRouter(
  initialLocation: Routes.wisherDetails.path.replaceAll(':id', '1'),
  routes: [
    GoRoute(
      path: Routes.wisherDetails.path,
      name: Routes.wisherDetails.name,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return CustomTransitionPage(
          child: WisherDetailsScreen(
            viewModel: WisherDetailsViewModel(
              wisherRepository: wisherRepository,
              wisherId: id,
            ),
          ),
          transitionsBuilder: slideInRightTransition,
        );
      },
    ),
  ],
);
