import 'package:go_router/go_router.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/routing/transitions.dart';
import 'package:wishing_well/features/home/home_screen.dart';
import 'package:wishing_well/features/home/home_view_model.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';

GoRouter homeDemoRouter(
  AuthRepository authRepository,
  WisherRepository wisherRepository,
  ImageRepository imageRepository,
) => GoRouter(
  initialLocation: Routes.home.path,
  routes: [
    GoRoute(
      path: Routes.home.path,
      name: Routes.home.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: HomeScreen(
          viewModel: HomeViewModel(
            authRepository: authRepository,
            wisherRepository: wisherRepository,
            imageRepository: imageRepository,
          ),
        ),
        transitionsBuilder: noTransition,
      ),
    ),
  ],
);
