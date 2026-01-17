import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/profile_screen/profile_screen.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

dynamic startAppWithProfileScreen(
  WidgetTester tester, {
  AuthRepository? authRepository,
}) async {
  final controller = LoadingController();
  final repo = authRepository ?? MockAuthRepository();

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

class _TestAuthRepository extends AuthRepository {
  _TestAuthRepository({required this.logoutResult});

  final Result<void> logoutResult;

  @override
  bool get isAuthenticated => logoutResult is Ok;

  @override
  String? get userFirstName => null;

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async => const Result.ok(null);

  @override
  Future<Result<void>> logout() async => logoutResult;

  @override
  Future<Result<void>> createAccount({
    required String email,
    required String password,
  }) async => const Result.ok(null);

  @override
  Future<Result<void>> sendPasswordResetRequest({
    required String email,
  }) async => const Result.ok(null);

  @override
  Future<Result<void>> resetUserPassword({
    required String email,
    required String newPassword,
    required String token,
  }) async => const Result.ok(null);
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
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LoadingController>.value(
              value: LoadingController(),
            ),
            ListenableProvider<AuthRepository>.value(
              value: _TestAuthRepository(logoutResult: const Result.ok(null)),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: ProfileScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final closeButton = find.byIcon(Icons.close);
      expect(closeButton, findsOneWidget);

      await tester.tap(closeButton);
      await tester.pump();

      expect(tester.takeException(), isA<FlutterError>());
    });

    testWidgets('Tapping logout button triggers logout action', (
      WidgetTester tester,
    ) async {
      await startAppWithProfileScreen(tester);
      expect(find.text('Logout'), findsOneWidget);
      await tester.tap(find.text('Logout'));
      await tester.pump();
    });

    testWidgets('Shows error dialog on logout error', (
      WidgetTester tester,
    ) async {
      final repo = _TestAuthRepository(
        logoutResult: Result.error(Exception('test error')),
      );

      final controller = LoadingController();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LoadingController>.value(value: controller),
            ListenableProvider<AuthRepository>.value(value: repo),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Logout'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Oh no!'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('Can dismiss error dialog', (WidgetTester tester) async {
      final repo = _TestAuthRepository(
        logoutResult: Result.error(Exception('test error')),
      );

      final controller = LoadingController();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LoadingController>.value(value: controller),
            ListenableProvider<AuthRepository>.value(value: repo),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Logout'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Oh no!'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Oh no!'), findsNothing);
    });
  });
}
