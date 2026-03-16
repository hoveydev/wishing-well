import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/router.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_screen.dart';
import 'package:wishing_well/features/auth/create_account/create_account_screen.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/features/home/home_screen.dart';
import 'package:wishing_well/features/auth/login/login_screen.dart';
import 'package:wishing_well/features/profile/profile_screen.dart';
import 'package:wishing_well/features/auth/reset_password/reset_password_screen.dart';
import 'package:wishing_well/theme/app_theme.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

Widget startAppWithRouter(GoRouter router) => MultiProvider(
  providers: [
    ChangeNotifierProvider<AuthRepository>(create: (_) => MockAuthRepository()),
    ChangeNotifierProvider<WisherRepository>(
      create: (_) => MockWisherRepository(),
    ),
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
  group('Router', () {
    group(TestGroups.initialState, () {
      testWidgets('starts on login route', (WidgetTester tester) async {
        final goRouter = router();
        await tester.pumpWidget(startAppWithRouter(goRouter));
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(LoginScreen), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('navigates to forgot password', (WidgetTester tester) async {
        final goRouter = router();
        await tester.pumpWidget(startAppWithRouter(goRouter));
        await TestHelpers.pumpAndSettle(tester);
        goRouter.goNamed(Routes.forgotPassword.name);
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      });

      testWidgets('navigates to sign up', (WidgetTester tester) async {
        final goRouter = router();
        await tester.pumpWidget(startAppWithRouter(goRouter));
        await TestHelpers.pumpAndSettle(tester);
        goRouter.goNamed(Routes.createAccount.name);
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(CreateAccountScreen), findsOneWidget);
      });

      testWidgets('navigates to home', (WidgetTester tester) async {
        final goRouter = router();
        await tester.pumpWidget(startAppWithRouter(goRouter));
        await TestHelpers.pumpAndSettle(tester);
        goRouter.goNamed(Routes.home.name);
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('navigates to reset password', (WidgetTester tester) async {
        final goRouter = router();
        await tester.pumpWidget(startAppWithRouter(goRouter));
        await TestHelpers.pumpAndSettle(tester);
        goRouter.goNamed(
          Routes.resetPassword.name,
          queryParameters: {'email': 'test@example.com', 'token': 'abc123'},
        );
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(ResetPasswordScreen), findsOneWidget);
      });

      testWidgets('navigates to profile', (WidgetTester tester) async {
        final goRouter = router();
        await tester.pumpWidget(startAppWithRouter(goRouter));
        await TestHelpers.pumpAndSettle(tester);
        goRouter.goNamed(Routes.profile.name);
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(ProfileScreen), findsOneWidget);
      });

      testWidgets('navigates to add wisher', (WidgetTester tester) async {
        final goRouter = router();
        await tester.pumpWidget(startAppWithRouter(goRouter));
        await TestHelpers.pumpAndSettle(tester);
        goRouter.goNamed(Routes.addWisher.name);
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(AddWisherLandingScreen), findsOneWidget);
      });

      testWidgets('navigates to add wisher details', (
        WidgetTester tester,
      ) async {
        final goRouter = router();
        await tester.pumpWidget(startAppWithRouter(goRouter));
        await TestHelpers.pumpAndSettle(tester);
        goRouter.goNamed(Routes.addWisherDetails.name);
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(AddWisherDetailsScreen), findsOneWidget);
      });
    });
  });
}
