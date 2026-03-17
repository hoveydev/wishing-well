import 'package:go_router/go_router.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/routing/transitions.dart';
import 'package:wishing_well/features/auth/login/login_screen.dart';
import 'package:wishing_well/features/auth/login/login_view_model.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_view_model.dart';
import 'package:wishing_well/features/auth/create_account/create_account_screen.dart';
import 'package:wishing_well/features/auth/create_account/create_account_view_model.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';

GoRouter authDemoRouter(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.login.path,
  routes: [
    GoRoute(
      path: Routes.login.path,
      name: Routes.login.name,
      pageBuilder: (context, state) {
        final showSuccess = state.uri.queryParameters['demoSuccess'] == 'true';
        return CustomTransitionPage(
          child: LoginScreen(
            viewModel: LoginViewModel(authRepository: authRepository),
            showDemoSuccess: showSuccess,
          ),
          transitionsBuilder: noTransition,
        );
      },
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
    // Home route - redirects to login with success message
    GoRoute(
      path: Routes.home.path,
      name: Routes.home.name,
      redirect: (context, state) => '${Routes.login.path}?demoSuccess=true',
    ),
  ],
);
