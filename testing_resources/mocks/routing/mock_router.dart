import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/screens/account_confirmation/account_confirmation_screen.dart';
import 'package:wishing_well/screens/create_account/create_account_screen.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';
import 'package:wishing_well/screens/create_account_confirmation/create_account_confirmation_screen.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_viewmodel.dart';
import 'package:wishing_well/screens/forgot_password_confirmation/forgot_password_confirmation_screen.dart';
import 'package:wishing_well/screens/login/login_screen.dart';
import 'package:wishing_well/screens/login/login_viewmodel.dart';
import 'package:wishing_well/screens/reset_password/reset_password_screen.dart';
import 'package:wishing_well/screens/reset_password/reset_password_viewmodel.dart';
import 'package:wishing_well/screens/reset_password_confirmation/reset_password_confirmation_screen.dart';

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
          builder: (context, state) => const ForgotPasswordConfirmationScreen(),
        ),
        GoRoute(
          path: 'reset',
          name: 'reset-password',
          builder: (context, state) => ResetPasswordScreen(
            viewmodel: ResetPasswordViewmodel(
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
                  const ResetPasswordConfirmationScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/create-account',
      name: 'create-account',
      builder: (context, state) => CreateAccountScreen(
        viewModel: CreateAccountViewmodel(authRepository: MockAuthRepository()),
      ),
      routes: [
        GoRoute(
          path: 'confirm',
          name: 'create-account-confirm',
          builder: (context, state) => const CreateAccountConfirmationScreen(),
        ),
        GoRoute(
          path: 'account-confirm',
          name: 'account-confirm',
          builder: (context, state) => const AccountConfirmationScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const Screen(),
    ),
  ],
);
