import 'package:go_router/go_router.dart';
import 'package:wishing_well/features/auth/create_account/create_account_screen.dart';
import 'package:wishing_well/features/auth/create_account/create_account_view_model.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_view_model.dart';
import 'package:wishing_well/features/home/home_screen.dart';
import 'package:wishing_well/features/home/home_view_model.dart';
import 'package:wishing_well/features/auth/login/login_screen.dart';
import 'package:wishing_well/features/auth/login/login_view_model.dart';
import 'package:wishing_well/features/auth/reset_password/reset_password_screen.dart';
import 'package:wishing_well/features/auth/reset_password/reset_password_view_model.dart';

import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

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
          path: 'reset',
          name: 'reset-password',
          builder: (context, state) => ResetPasswordScreen(
            viewModel: ResetPasswordViewModel(
              authRepository: MockAuthRepository(),
              email: 'reset.password@email.com',
            ),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/create-account',
      name: 'create-account',
      builder: (context, state) => CreateAccountScreen(
        viewModel: CreateAccountViewModel(authRepository: MockAuthRepository()),
      ),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => HomeScreen(
        viewModel: HomeViewModel(
          authRepository: MockAuthRepository(),
          wisherRepository: MockWisherRepository(),
          imageRepository: MockImageRepository(),
        ),
      ),
    ),
  ],
);
