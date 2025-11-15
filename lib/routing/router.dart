import 'package:go_router/go_router.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_viewmodel.dart';
import 'package:wishing_well/screens/login/login_screen.dart';
import 'package:wishing_well/screens/login/login_viewmodel.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.login, // should change to home once auth is set up
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        final viewModel = LoginViewModel();
        return LoginScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.forgotPassword,
      builder: (context, state) {
        final viewModel = ForgotPasswordViewmodel();
        return ForgotPasswordScreen(viewModel: viewModel);
      },
    )
  ]
);