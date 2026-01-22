import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/router.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/screens/confirmation/confirmation_screen.dart';
import 'package:wishing_well/screens/create_account/create_account_screen.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/screens/home/home_screen.dart';
import 'package:wishing_well/screens/login/login_screen.dart';
import 'package:wishing_well/screens/profile_screen/profile_screen.dart';
import 'package:wishing_well/screens/reset_password/reset_password_screen.dart';
import 'package:wishing_well/theme/app_theme.dart';

import '../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

Widget startAppWithRouter(GoRouter router) => MultiProvider(
  providers: [
    ChangeNotifierProvider<AuthRepository>(create: (_) => MockAuthRepository()),
  ],
  child: MaterialApp.router(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    routerConfig: router,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
  ),
);

void main() {
  group('App Router', () {
    testWidgets('starts on login route', (tester) async {
      final goRouter = router();
      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('navigates to forgot password', (tester) async {
      final goRouter = router();
      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();
      goRouter.goNamed(Routes.forgotPassword.name);
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets('navigates to forgot password confirm', (tester) async {
      final goRouter = router();
      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();
      goRouter.goNamed(Routes.forgotPassword.name);
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      goRouter.goNamed(Routes.forgotPasswordConfirm.name);
      await tester.pumpAndSettle();
      expect(find.byType(ConfirmationScreen), findsOneWidget);
    });

    testWidgets('navigates to sign up', (tester) async {
      final goRouter = router();
      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();
      goRouter.goNamed(Routes.createAccount.name);
      await tester.pumpAndSettle();
      expect(find.byType(CreateAccountScreen), findsOneWidget);
    });

    testWidgets('navigates to sign up confirm', (tester) async {
      final goRouter = router();
      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();
      goRouter.goNamed(Routes.createAccount.name);
      await tester.pumpAndSettle();
      expect(find.byType(CreateAccountScreen), findsOneWidget);
      goRouter.goNamed(Routes.createAccountConfirm.name);
      await tester.pumpAndSettle();
      expect(find.byType(ConfirmationScreen), findsOneWidget);
    });

    testWidgets('navigates to home', (tester) async {
      final goRouter = router();
      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();
      goRouter.goNamed(Routes.home.name);
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('navigates to account confirmation', (tester) async {
      final goRouter = router();
      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();
      goRouter.goNamed(Routes.accountConfirm.name);
      await tester.pumpAndSettle();
      expect(find.byType(ConfirmationScreen), findsOneWidget);
    });

    testWidgets('navigates to reset password', (tester) async {
      final goRouter = router();
      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();
      goRouter.goNamed(Routes.resetPassword.name);
      await tester.pumpAndSettle();
      expect(find.byType(ResetPasswordScreen), findsOneWidget);
    });

    testWidgets('navigates to reset password confirmation', (tester) async {
      final goRouter = router();
      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();
      goRouter.goNamed(Routes.resetPasswordConfirmation.name);
      await tester.pumpAndSettle();
      expect(find.byType(ConfirmationScreen), findsOneWidget);
    });

    testWidgets('navigates to profile', (tester) async {
      final goRouter = router();
      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();
      goRouter.goNamed(Routes.profile.name);
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
    });
  });
}
