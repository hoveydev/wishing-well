import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/routing/transitions.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';
import 'package:wishing_well/features/auth/create_account/create_account_screen.dart';
import 'package:wishing_well/features/auth/create_account/create_account_view_model.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_view_model.dart';
import 'package:wishing_well/features/home/home_screen.dart';
import 'package:wishing_well/features/home/home_view_model.dart';
import 'package:wishing_well/features/profile/profile_screen.dart';
import 'package:wishing_well/features/auth/login/login_screen.dart';
import 'package:wishing_well/features/auth/login/login_view_model.dart';
import 'package:wishing_well/features/auth/reset_password/reset_password_screen.dart';
import 'package:wishing_well/features/auth/reset_password/reset_password_view_model.dart';

GoRouter router() => GoRouter(
  initialLocation: '/login',
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
                token: state.uri.queryParameters['token'] ?? '',
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
          ),
        ),
        transitionsBuilder: noTransition,
      ),
    ),
    GoRoute(
      path: Routes.profile.path,
      name: Routes.profile.name,
      pageBuilder: (context, state) => const CustomTransitionPage(
        child: ProfileScreen(),
        transitionsBuilder: slideUpTransition,
      ),
    ),
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
                wisherRepository: context.read(),
                authRepository: context.read(),
              ),
            ),
            transitionsBuilder: slideInRightTransition,
          ),
        ),
      ],
    ),
  ],
);
