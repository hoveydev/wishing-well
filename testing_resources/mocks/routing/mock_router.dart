import 'package:go_router/go_router.dart';
import 'package:wishing_well/screens/confirmation/confirmation_screen.dart';
import 'package:wishing_well/screens/create_account/create_account_screen.dart';
import 'package:wishing_well/screens/create_account/create_account_view_model.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_view_model.dart';
import 'package:wishing_well/screens/home/home_screen.dart';
import 'package:wishing_well/screens/home/home_view_model.dart';
import 'package:wishing_well/screens/login/login_screen.dart';
import 'package:wishing_well/screens/login/login_view_model.dart';
import 'package:wishing_well/screens/reset_password/reset_password_screen.dart';
import 'package:wishing_well/screens/reset_password/reset_password_view_model.dart';

import '../repositories/mock_auth_repository.dart';

GoRouter createMockRouter() => GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(
        viewModel: LoginViewModel(authRepository: MockAuthRepository()),
      ),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => ForgotPasswordScreen(
        viewModel: ForgotPasswordViewModel(
          authRepository: MockAuthRepository(),
        ),
      ),
      routes: [
        GoRoute(
          path: 'confirm',
          name: 'forgot-password-confirm',
          builder: (context, state) =>
              const ConfirmationScreen.forgotPassword(),
        ),
        GoRoute(
          path: 'reset',
          name: 'reset-password',
          builder: (context, state) => ResetPasswordScreen(
            viewModel: ResetPasswordViewModel(
              authRepository: MockAuthRepository(),
              email: 'reset.password@email.com',
              token: 'valid-token',
            ),
          ),
          routes: [
            GoRoute(
              path: 'confirm',
              name: 'reset-password-confirmation',
              builder: (context, state) =>
                  const ConfirmationScreen.resetPassword(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/create-account',
      name: 'create-account',
      builder: (context, state) => CreateAccountScreen(
        viewModel: CreateAccountViewModel(authRepository: MockAuthRepository()),
      ),
      routes: [
        GoRoute(
          path: 'confirm',
          name: 'create-account-confirm',
          builder: (context, state) => const ConfirmationScreen.createAccount(),
        ),
        GoRoute(
          path: 'account-confirm',
          name: 'account-confirm',
          builder: (context, state) => const ConfirmationScreen.account(),
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => HomeScreen(
        viewModel: HomeViewModel(authRepository: MockAuthRepository()),
      ),
    ),
  ],
);
