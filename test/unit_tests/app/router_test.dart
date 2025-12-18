import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/router.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/screens/create_account_confirmation/create_account_confirmation_screen.dart';
import 'package:wishing_well/screens/login/login_screen.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/screens/create_account/create_account_screen.dart';
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

      goRouter.goNamed(Routes.forgotPassword);
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets('navigates to sign up', (tester) async {
      final goRouter = router();

      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();

      goRouter.goNamed(Routes.createAccount);
      await tester.pumpAndSettle();

      expect(find.byType(CreateAccountScreen), findsOneWidget);
    });

    testWidgets('navigates to sign up confirm', (tester) async {
      final goRouter = router();

      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();

      goRouter.goNamed(Routes.createAccount);
      await tester.pumpAndSettle();

      expect(find.byType(CreateAccountScreen), findsOneWidget);

      goRouter.goNamed(Routes.createAccountConfirm);
      await tester.pumpAndSettle();

      expect(find.byType(CreateAccountConfirmationScreen), findsOneWidget);
    });

    testWidgets('navigates to home', (tester) async {
      final goRouter = router();

      await tester.pumpWidget(startAppWithRouter(goRouter));
      await tester.pumpAndSettle();

      goRouter.goNamed(Routes.home);
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });
  });
}
