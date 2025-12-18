import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/screens/create_account/create_account_screen.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';
import 'package:wishing_well/screens/create_account_confirmation/create_account_confirmation_screen.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_viewmodel.dart';
import 'package:wishing_well/screens/login/login_screen.dart';
import 'package:wishing_well/screens/login/login_viewmodel.dart';

GoRouter router() => GoRouter(
  initialLocation: '/login', // should change to home once auth is set up
  routes: [
    GoRoute(
      path: '/login',
      name: Routes.login,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: LoginScreen(
          viewModel: LoginViewModel(authRepository: context.read()),
        ),
        transitionsBuilder: (_, _, secondaryAnimation, child) {
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
      path: '/forgot-password',
      name: Routes.forgotPassword,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: ForgotPasswordScreen(viewModel: ForgotPasswordViewModel()),
        transitionsBuilder: (_, animation, _, child) {
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
    GoRoute(
      path: '/create-account',
      name: Routes.createAccount,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: CreateAccountScreen(
          viewModel: CreateAccountViewmodel(authRepository: context.read()),
        ),
        transitionsBuilder: (_, animation, _, child) {
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
      routes: [
        GoRoute(
          path: 'confirm',
          name: Routes.createAccountConfirm,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const CreateAccountConfirmationScreen(),
            transitionDuration: Duration.zero,
            transitionsBuilder: (_, animation, _, child) {
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
    ),
    GoRoute(
      path: '/home',
      name: Routes.home,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const Screen(children: [Text('Home')]),
        transitionsBuilder: (_, _, _, child) => child,
      ),
    ),
  ],
);
