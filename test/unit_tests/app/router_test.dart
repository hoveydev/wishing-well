import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/auth/login/login_screen.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/features/auth/create_account/create_account_screen.dart';
import 'package:wishing_well/features/auth/reset_password/reset_password_screen.dart';
import 'package:wishing_well/features/home/home_screen.dart';
import 'package:wishing_well/features/profile/profile_screen.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_screen.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/edit_wisher_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_screen.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/router.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

Widget _buildApp() => MultiProvider(
  providers: [
    ChangeNotifierProvider<AuthRepository>(create: (_) => MockAuthRepository()),
    ChangeNotifierProvider<WisherRepository>(
      create: (_) => MockWisherRepository(),
    ),
    ChangeNotifierProvider<ImageRepository>(
      create: (_) => MockImageRepository(),
    ),
    ChangeNotifierProvider<LoadingController>(
      create: (_) => LoadingController(),
    ),
  ],
  child: MaterialApp.router(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    routerConfig: router(),
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
      test('router() returns a non-null GoRouter', () {
        final goRouter = router();
        expect(goRouter, isNotNull);
      });

      test('router has routes registered', () {
        final goRouter = router();
        expect(goRouter.configuration.routes, isNotEmpty);
      });
    });

    group(TestGroups.behavior, () {
      test('all routes have names registered', () {
        final goRouter = router();
        final routeConfig = goRouter.routerDelegate.currentConfiguration;
        expect(routeConfig, isNotNull);
      });

      test('router can navigate to editWisher route', () {
        final goRouter = router();
        expect(
          () => goRouter.go(Routes.editWisher.buildPath(id: 'test-id')),
          returnsNormally,
        );
      });

      test('router can navigate to wisherDetails route', () {
        final goRouter = router();
        expect(
          () => goRouter.go(Routes.wisherDetails.buildPath(id: 'test-id')),
          returnsNormally,
        );
      });
    });

    group('Route Navigation', () {
      testWidgets('renders login screen at initial location', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(_buildApp());
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(LoginScreen), findsOneWidget);
      });

      testWidgets('navigates to forgot password route', (
        WidgetTester tester,
      ) async {
        final goRouter = router();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthRepository>(
                create: (_) => MockAuthRepository(),
              ),
              ChangeNotifierProvider<WisherRepository>(
                create: (_) => MockWisherRepository(),
              ),
              ChangeNotifierProvider<ImageRepository>(
                create: (_) => MockImageRepository(),
              ),
              ChangeNotifierProvider<LoadingController>(
                create: (_) => LoadingController(),
              ),
            ],
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routerConfig: goRouter,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        goRouter.goNamed(Routes.forgotPassword.name);
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      });

      testWidgets('navigates to create account route', (
        WidgetTester tester,
      ) async {
        final goRouter = router();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthRepository>(
                create: (_) => MockAuthRepository(),
              ),
              ChangeNotifierProvider<WisherRepository>(
                create: (_) => MockWisherRepository(),
              ),
              ChangeNotifierProvider<ImageRepository>(
                create: (_) => MockImageRepository(),
              ),
              ChangeNotifierProvider<LoadingController>(
                create: (_) => LoadingController(),
              ),
            ],
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routerConfig: goRouter,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        goRouter.goNamed(Routes.createAccount.name);
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(CreateAccountScreen), findsOneWidget);
      });

      testWidgets('navigates to home route', (WidgetTester tester) async {
        final goRouter = router();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthRepository>(
                create: (_) => MockAuthRepository(),
              ),
              ChangeNotifierProvider<WisherRepository>(
                create: (_) => MockWisherRepository(),
              ),
              ChangeNotifierProvider<ImageRepository>(
                create: (_) => MockImageRepository(),
              ),
              ChangeNotifierProvider<LoadingController>(
                create: (_) => LoadingController(),
              ),
            ],
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routerConfig: goRouter,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        goRouter.goNamed(Routes.home.name);
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('navigates to reset password route', (
        WidgetTester tester,
      ) async {
        final goRouter = router();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthRepository>(
                create: (_) => MockAuthRepository(),
              ),
              ChangeNotifierProvider<WisherRepository>(
                create: (_) => MockWisherRepository(),
              ),
              ChangeNotifierProvider<ImageRepository>(
                create: (_) => MockImageRepository(),
              ),
              ChangeNotifierProvider<LoadingController>(
                create: (_) => LoadingController(),
              ),
            ],
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routerConfig: goRouter,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        goRouter.goNamed(
          Routes.resetPassword.name,
          queryParameters: {'email': 'test@example.com', 'token': 'abc123'},
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(ResetPasswordScreen), findsOneWidget);
      });

      testWidgets('navigates to profile route', (WidgetTester tester) async {
        final goRouter = router();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthRepository>(
                create: (_) => MockAuthRepository(),
              ),
              ChangeNotifierProvider<WisherRepository>(
                create: (_) => MockWisherRepository(),
              ),
              ChangeNotifierProvider<ImageRepository>(
                create: (_) => MockImageRepository(),
              ),
              ChangeNotifierProvider<LoadingController>(
                create: (_) => LoadingController(),
              ),
            ],
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routerConfig: goRouter,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        goRouter.goNamed(Routes.profile.name);
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(ProfileScreen), findsOneWidget);
      });

      testWidgets('navigates to wisher details route', (
        WidgetTester tester,
      ) async {
        final goRouter = router();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthRepository>(
                create: (_) => MockAuthRepository(),
              ),
              ChangeNotifierProvider<WisherRepository>(
                create: (_) => MockWisherRepository(),
              ),
              ChangeNotifierProvider<ImageRepository>(
                create: (_) => MockImageRepository(),
              ),
              ChangeNotifierProvider<LoadingController>(
                create: (_) => LoadingController(),
              ),
            ],
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routerConfig: goRouter,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        goRouter.goNamed(
          Routes.wisherDetails.name,
          pathParameters: {'id': '1'},
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(WisherDetailsScreen), findsOneWidget);
      });

      testWidgets('navigates to edit wisher route', (
        WidgetTester tester,
      ) async {
        final goRouter = router();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthRepository>(
                create: (_) => MockAuthRepository(),
              ),
              ChangeNotifierProvider<WisherRepository>(
                create: (_) => MockWisherRepository(),
              ),
              ChangeNotifierProvider<ImageRepository>(
                create: (_) => MockImageRepository(),
              ),
              ChangeNotifierProvider<LoadingController>(
                create: (_) => LoadingController(),
              ),
            ],
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routerConfig: goRouter,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        goRouter.goNamed(Routes.editWisher.name, pathParameters: {'id': '1'});
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(EditWisherScreen), findsOneWidget);
      });

      testWidgets('navigates to add wisher route', (WidgetTester tester) async {
        final goRouter = router();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthRepository>(
                create: (_) => MockAuthRepository(),
              ),
              ChangeNotifierProvider<WisherRepository>(
                create: (_) => MockWisherRepository(),
              ),
              ChangeNotifierProvider<ImageRepository>(
                create: (_) => MockImageRepository(),
              ),
              ChangeNotifierProvider<LoadingController>(
                create: (_) => LoadingController(),
              ),
            ],
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routerConfig: goRouter,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        goRouter.goNamed(Routes.addWisher.name);
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AddWisherLandingScreen), findsOneWidget);
      });

      testWidgets('navigates to add wisher details route', (
        WidgetTester tester,
      ) async {
        final goRouter = router();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthRepository>(
                create: (_) => MockAuthRepository(),
              ),
              ChangeNotifierProvider<WisherRepository>(
                create: (_) => MockWisherRepository(),
              ),
              ChangeNotifierProvider<ImageRepository>(
                create: (_) => MockImageRepository(),
              ),
              ChangeNotifierProvider<LoadingController>(
                create: (_) => LoadingController(),
              ),
            ],
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routerConfig: goRouter,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        goRouter.goNamed(Routes.addWisherDetails.name);
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AddWisherDetailsScreen), findsOneWidget);
      });
    });
  });
}
