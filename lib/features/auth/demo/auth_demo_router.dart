import 'package:go_router/go_router.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/routing/transitions.dart';
import 'package:wishing_well/features/auth/demo/demo_success_screen.dart';
import 'package:wishing_well/features/auth/login/login_screen.dart';
import 'package:wishing_well/features/auth/login/login_view_model.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_view_model.dart';
import 'package:wishing_well/features/auth/create_account/create_account_screen.dart';
import 'package:wishing_well/features/auth/create_account/create_account_view_model.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';

GoRouter authDemoRouter(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.login.path,
  // Redirect any navigation to home route to demo success screen
  redirect: (context, state) {
    if (state.matchedLocation == Routes.home.path) {
      return '/demo-success';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: Routes.login.path,
      name: Routes.login.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: LoginScreen(
          viewModel: LoginViewModel(authRepository: authRepository),
        ),
        transitionsBuilder: noTransition,
      ),
    ),
    GoRoute(
      path: Routes.forgotPassword.path,
      name: Routes.forgotPassword.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: ForgotPasswordScreen(
          viewModel: ForgotPasswordViewModel(authRepository: authRepository),
        ),
        transitionsBuilder: slideUpTransition,
      ),
    ),
    GoRoute(
      path: Routes.resetPassword.path,
      name: Routes.resetPassword.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: LoginScreen(
          viewModel: LoginViewModel(authRepository: authRepository),
        ),
        transitionsBuilder: slideUpTransition,
      ),
    ),
    GoRoute(
      path: Routes.createAccount.path,
      name: Routes.createAccount.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: CreateAccountScreen(
          viewModel: CreateAccountViewModel(authRepository: authRepository),
        ),
        transitionsBuilder: slideUpTransition,
      ),
    ),
    // Demo success screen - shown after successful login simulation
    GoRoute(
      path: '/demo-success',
      name: 'demoSuccess',
      pageBuilder: (context, state) => const CustomTransitionPage(
        child: DemoSuccessScreen(),
        transitionsBuilder: slideUpTransition,
      ),
    ),
  ],
);
