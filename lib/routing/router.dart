import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/routing/routes.dart';
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

GoRouter router() => GoRouter(
  initialLocation: '/login', // should change to home once auth is set up
  routes: [
    GoRoute(
      path: Routes.login.path,
      name: Routes.login.name,
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
      path: Routes.forgotPassword.path,
      name: Routes.forgotPassword.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: ForgotPasswordScreen(
          viewModel: ForgotPasswordViewModel(authRepository: context.read()),
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
          path: Routes.forgotPasswordConfirm.path,
          name: Routes.forgotPasswordConfirm.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const ForgotPasswordConfirmationScreen(),
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
        GoRoute(
          path: Routes.resetPassword.path,
          name: Routes.resetPassword.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: ResetPasswordScreen(
              viewmodel: ResetPasswordViewmodel(authRepository: context.read()),
            ),
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
          routes: [
            GoRoute(
              path: Routes.resetPasswordConfirmation.path,
              name: Routes.resetPasswordConfirmation.name,
              pageBuilder: (context, state) => CustomTransitionPage(
                child: const Screen(),
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
      ],
    ),
    GoRoute(
      path: Routes.createAccount.path,
      name: Routes.createAccount.name,
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
          path: Routes.createAccountConfirm.path,
          name: Routes.createAccountConfirm.name,
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
        GoRoute(
          path: Routes.accountConfirm.path,
          name: Routes.accountConfirm.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const AccountConfirmationScreen(),
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
      path: Routes.home.path,
      name: Routes.home.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const Screen(children: [Text('Home')]),
        transitionsBuilder: (_, _, _, child) => child,
      ),
    ),
  ],
);
