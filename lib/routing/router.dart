import 'package:flutter/material.dart';
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
      pageBuilder: (context, state) => CustomTransitionPage(
        child: LoginScreen(viewModel: LoginViewModel()),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset.zero;
          const end = Offset(0.0, -0.15);
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: secondaryAnimation.drive(tween),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: Routes.forgotPassword,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: ForgotPasswordScreen(viewModel: ForgotPasswordViewModel()),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    ),
  ],
);
