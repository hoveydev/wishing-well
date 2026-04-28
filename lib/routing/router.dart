import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/routing/transitions.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_batch_importer.dart';
import 'package:wishing_well/features/all_wishers/all_wishers_screen.dart';
import 'package:wishing_well/features/all_wishers/all_wishers_view_model.dart';
import 'package:wishing_well/features/auth/create_account/create_account_screen.dart';
import 'package:wishing_well/features/auth/create_account/create_account_view_model.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_view_model.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/edit_wisher_screen.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/edit_wisher_view_model.dart';
import 'package:wishing_well/features/home/home_screen.dart';
import 'package:wishing_well/features/home/home_view_model.dart';
import 'package:wishing_well/features/profile/profile_screen.dart';
import 'package:wishing_well/features/profile/profile_view_model.dart';
import 'package:wishing_well/features/auth/login/login_screen.dart';
import 'package:wishing_well/features/auth/login/login_view_model.dart';
import 'package:wishing_well/features/auth/reset_password/reset_password_screen.dart';
import 'package:wishing_well/features/auth/reset_password/reset_password_view_model.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_screen.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_view_model.dart';
import 'package:wishing_well/utils/app_config.dart';

GoRouter router({required AuthRepository authRepository}) => GoRouter(
  initialLocation: '/login',
  refreshListenable: authRepository,
  onException: (context, state, router) {
    router.go(authRepository.isAuthenticated ? '/home' : '/login');
  },
  redirect: (context, state) {
    final isAuthenticated = authRepository.isAuthenticated;
    final loc = state.matchedLocation;

    final isGoingToLogin = loc == '/login';
    final isGoingToCreateAccount = loc == '/create-account';
    final isGoingToForgotPassword = loc == '/forgot-password';
    final isGoingToResetPassword = loc.startsWith(
      '/forgot-password/reset-password',
    );

    // Auth-only screens (skip if already authenticated)
    final isRedirectableAuthScreen =
        isGoingToLogin || isGoingToCreateAccount || isGoingToForgotPassword;

    // Public screens accessible by all (no auth required, no redirect)
    final isPublicScreen = isRedirectableAuthScreen || isGoingToResetPassword;

    if (isAuthenticated && isRedirectableAuthScreen) {
      return '/home';
    }
    if (!isAuthenticated && !isPublicScreen) {
      return '/login';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: Routes.login.path,
      name: Routes.login.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: LoginScreen(
          viewModel: LoginViewModel(authRepository: context.read()),
        ),
        transitionsBuilder: slideDownTransition,
      ),
    ),
    GoRoute(
      path: Routes.forgotPassword.path,
      name: Routes.forgotPassword.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: ForgotPasswordScreen(
          viewModel: ForgotPasswordViewModel(authRepository: context.read()),
        ),
        transitionsBuilder: slideUpTransition,
      ),
      routes: [
        GoRoute(
          path: Routes.resetPassword.path,
          name: Routes.resetPassword.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: ResetPasswordScreen(
              viewModel: ResetPasswordViewModel(
                authRepository: context.read(),
                email: state.uri.queryParameters['email'] ?? '',
              ),
            ),
            transitionDuration: Duration.zero,
            transitionsBuilder: slideUpTransition,
          ),
        ),
      ],
    ),
    GoRoute(
      path: Routes.createAccount.path,
      name: Routes.createAccount.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: CreateAccountScreen(
          viewModel: CreateAccountViewModel(authRepository: context.read()),
        ),
        transitionsBuilder: slideUpTransition,
      ),
    ),
    GoRoute(
      path: Routes.home.path,
      name: Routes.home.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: HomeScreen(
          viewModel: HomeViewModel(
            authRepository: context.read(),
            wisherRepository: context.read(),
            imageRepository: context.read(),
          ),
        ),
        transitionsBuilder: noTransition,
      ),
    ),
    GoRoute(
      path: Routes.allWishers.path,
      name: Routes.allWishers.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: AllWishersScreen(
          viewModel: AllWishersViewModel(wisherRepository: context.read()),
        ),
        transitionsBuilder: slideUpWithParallaxTransition,
      ),
    ),
    GoRoute(
      path: Routes.profile.path,
      name: Routes.profile.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: ProfileScreen(
          viewModel: ProfileViewModel(authRepository: context.read()),
        ),
        transitionsBuilder: slideUpTransition,
      ),
    ),
    GoRoute(
      path: Routes.wisherDetails.path,
      name: Routes.wisherDetails.name,
      pageBuilder: (context, state) {
        final wisherId =
            state.pathParameters['id'] ??
            (throw ArgumentError(
              'Missing wisher ID in route parameters for '
              '${Routes.wisherDetails.path}',
            ));
        final wisherRepository = context.read<WisherRepository>();
        final isFromAllWishers =
            state.uri.queryParameters['from'] == 'all-wishers';

        return CustomTransitionPage(
          child: WisherDetailsScreen(
            viewModel: WisherDetailsViewModel(
              wisherRepository: wisherRepository,
              wisherId: wisherId,
              isFromAllWishers: isFromAllWishers,
            ),
          ),
          transitionsBuilder: isFromAllWishers
              ? slideInRightTransition
              : slideUpWithParallaxTransition,
        );
      },
      routes: [
        GoRoute(
          path: Routes.editWisher.path,
          name: Routes.editWisher.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: EditWisherScreen(
              viewModel: EditWisherViewModel(
                wisherRepository: context.read(),
                imageRepository: context.read(),
                wisherId:
                    state.pathParameters['id'] ??
                    (throw ArgumentError(
                      'Missing wisher ID in route parameters for '
                      '${Routes.editWisher.path}',
                    )),
              ),
            ),
            transitionsBuilder: slideInRightTransition,
          ),
        ),
      ],
    ),
    GoRoute(
      path: Routes.addWisher.path,
      name: Routes.addWisher.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: AddWisherLandingScreen(
          viewModel: AddWisherLandingViewModel(
            contactAccess: context.read(),
            contactBatchImporter: AddWisherContactBatchImporter(
              authRepository: context.read(),
              wisherRepository: context.read(),
              imageRepository: context.read(),
              profilePicturesBucketName: AppConfig.profilePicturesBucket,
            ),
          ),
        ),
        transitionsBuilder: slideUpWithParallaxTransition,
      ),
      routes: [
        GoRoute(
          path: Routes.addWisherDetails.path,
          name: Routes.addWisherDetails.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: AddWisherDetailsScreen(
              viewModel: AddWisherDetailsViewModel(
                wisherRepository: context.read(),
                authRepository: context.read(),
                imageRepository: context.read(),
              ),
            ),
            transitionsBuilder: slideInRightTransition,
          ),
        ),
      ],
    ),
  ],
);
