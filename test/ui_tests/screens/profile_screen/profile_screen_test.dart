import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/app_alert/app_alert.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/profile_screen/profile_screen.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

dynamic startAppWithProfileScreen(
  WidgetTester tester, {
  Result<void>? logoutResult,
}) async {
  final controller = LoadingController();
  final repo = MockAuthRepository(logoutResult: logoutResult);

  final app = MultiProvider(
    providers: [
      ChangeNotifierProvider<LoadingController>.value(value: controller),
      ListenableProvider<AuthRepository>.value(value: repo),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ProfileScreen(),
    ),
  );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}

void main() {
  group('Profile Screen Tests', () {
    testWidgets('Renders Screen with All Elements', (
      WidgetTester tester,
    ) async {
      await startAppWithProfileScreen(tester);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('Tapping close button executes action', (
      WidgetTester tester,
    ) async {
      await startAppWithProfileScreen(tester);

      final closeButton = find.byIcon(Icons.close);
      expect(closeButton, findsOneWidget);

      await tester.tap(closeButton);
      await tester.pump();

      expect(tester.takeException(), isA<FlutterError>());
    });

    testWidgets('Shows error dialog on logout error', (
      WidgetTester tester,
    ) async {
      await startAppWithProfileScreen(
        tester,
        logoutResult: Result.error(Exception('test error')),
      );

      await tester.tap(find.text('Logout'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Oh no!'), findsOneWidget);
      expect(find.byType(AppAlert), findsOneWidget);
      expect(
        find.text('An unknown error occured. Please try again'),
        findsOneWidget,
      );

      await tester.tap(find.text('Ok'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Oh no!'), findsNothing);
      expect(find.byType(AppAlert), findsNothing);
    });
  });
}
