import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/app_alert/app_alert.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/screens/profile_screen/profile_screen.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

// Helper functions for GoRouter routes
Widget _profileScreenBuilder(BuildContext context, GoRouterState state) =>
    const ProfileScreen();

Widget _loginScreenBuilder(BuildContext context, GoRouterState state) =>
    const Scaffold(body: Text('Login Screen'));

void main() {
  group('ProfileScreen', () {
    late LoadingController loadingController;

    setUp(() {
      loadingController = LoadingController();
    });

    tearDown(() {
      loadingController.dispose();
    });

    Widget createProfileScreenTestWidget({Result<void>? logoutResult}) {
      final repo = MockAuthRepository(logoutResult: logoutResult);

      return MultiProvider(
        providers: [
          ChangeNotifierProvider<LoadingController>.value(
            value: loadingController,
          ),
          ListenableProvider<AuthRepository>.value(value: repo),
        ],
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: _profileScreenBuilder),
              GoRoute(
                path: '/login',
                name: Routes.login.name,
                builder: _loginScreenBuilder,
              ),
            ],
          ),
        ),
      );
    }

    group(TestGroups.rendering, () {
      testWidgets('renders ProfileScreen with close button and logout button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createProfileScreenTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        // Verify close button is present
        expect(find.byIcon(Icons.close), findsOneWidget);

        // Verify logout button text
        TestHelpers.expectTextOnce('Logout');
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('close button attempts navigation back', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createProfileScreenTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final closeButton = find.byIcon(Icons.close);
        expect(closeButton, findsOneWidget);

        // Close button attempts navigation back (will fail in test context)
        await TestHelpers.tapAndSettle(tester, closeButton);

        // Since there's no previous route, expect a GoError
        expect(tester.takeException(), isA<GoError>());
      });

      testWidgets('logout button tap navigates to login on success', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createProfileScreenTestWidget(logoutResult: const Result.ok(null)),
        );
        await TestHelpers.pumpAndSettle(tester);

        final logoutButton = find.text('Logout');
        expect(logoutButton, findsOneWidget);

        await TestHelpers.tapAndSettle(tester, logoutButton);

        // Verify navigation to login screen was successful
        TestHelpers.expectTextOnce('Login Screen');
        expect(tester.takeException(), isNull);
      });
    });

    group(TestGroups.errorHandling, () {
      testWidgets('shows error dialog on logout failure', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createProfileScreenTestWidget(
            logoutResult: Result.error(Exception('test error')),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('Logout'));

        // Verify error dialog appears
        TestHelpers.expectTextOnce('Oh no!');
        TestHelpers.expectWidgetOnce(AppAlert);
        TestHelpers.expectTextOnce(
          'An unknown error occured. Please try again',
        );

        // Dismiss error dialog
        await TestHelpers.tapAndSettle(tester, find.text('Ok'));

        // Verify error dialog is dismissed
        expect(find.text('Oh no!'), findsNothing);
        expect(find.byType(AppAlert), findsNothing);
      });

      testWidgets('error dialog can be dismissed multiple times', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createProfileScreenTestWidget(
            logoutResult: Result.error(Exception('persistent error')),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // First logout attempt
        await TestHelpers.tapAndSettle(tester, find.text('Logout'));
        await TestHelpers.tapAndSettle(tester, find.text('Ok'));

        // Second logout attempt should also show error
        await TestHelpers.tapAndSettle(tester, find.text('Logout'));

        TestHelpers.expectTextOnce('Oh no!');
        TestHelpers.expectWidgetOnce(AppAlert);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('screen maintains proper structure and layout', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createProfileScreenTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        // Verify screen structure
        expect(find.byType(ProfileScreen), findsOneWidget);

        // Verify components are properly positioned
        final closeButton = find.byIcon(Icons.close);
        final logoutButton = find.text('Logout');

        expect(closeButton, findsOneWidget);
        expect(logoutButton, findsOneWidget);

        // Verify both buttons are rendered and accessible
        expect(tester.widget(closeButton), isA<Widget>());
        expect(tester.widget(logoutButton), isA<Widget>());
      });
    });
  });
}
