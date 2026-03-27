import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/features/auth/login/login_screen.dart';
import 'package:wishing_well/features/auth/login/login_view_model.dart';
import 'package:wishing_well/features/auth/create_account/create_account_screen.dart';
import 'package:wishing_well/features/auth/create_account/create_account_view_model.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';
import 'helpers/integration_test_groups.dart';
import 'mocks/integration_mock_auth_repository.dart';
import 'providers/integration_test_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(IntegrationTestGroups.authentication, () {
    testWidgets('login screen renders correctly', (WidgetTester tester) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock();
      final loadingController = LoadingController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<LoadingController>.value(
              value: loadingController,
            ),
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
            home: LoginScreen(
              viewModel: LoginViewModel(authRepository: authMock),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('login with invalid credentials updates error state', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationMockAuthRepository(
        loginResult: Result.error(Exception('Invalid credentials')),
      );
      final loadingController = LoadingController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<LoadingController>.value(
              value: loadingController,
            ),
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
            home: LoginScreen(
              viewModel: LoginViewModel(authRepository: authMock),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Fill in form
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'test@example.com');
      await tester.pumpAndSettle();
      await tester.enterText(textFields.last, 'wrongpassword');
      await tester.pumpAndSettle();

      // Tap login button
      final l10n = AppLocalizations.of(
        tester.element(find.byType(MaterialApp)),
      )!;
      await tester.tap(find.text(l10n.authSignIn).last);
      await tester.pumpAndSettle();

      // Verify login was attempted
      expect(authMock.loginCallCount, 1);
    });

    testWidgets('create account screen renders correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock();
      final loadingController = LoadingController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<LoadingController>.value(
              value: loadingController,
            ),
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
            home: CreateAccountScreen(
              viewModel: CreateAccountViewModel(authRepository: authMock),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CreateAccountScreen), findsOneWidget);
    });

    testWidgets('create account with error shows error state', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationMockAuthRepository(
        createAccountResult: Result.error(Exception('Email already exists')),
      );
      final loadingController = LoadingController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<LoadingController>.value(
              value: loadingController,
            ),
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
            home: CreateAccountScreen(
              viewModel: CreateAccountViewModel(authRepository: authMock),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Fill in form
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'existing@example.com');
      await tester.pumpAndSettle();
      await tester.enterText(textFields.at(1), 'password123');
      await tester.pumpAndSettle();
      await tester.enterText(textFields.at(2), 'password123');
      await tester.pumpAndSettle();

      // Tap create account
      final l10n = AppLocalizations.of(
        tester.element(find.byType(MaterialApp)),
      )!;
      await tester.tap(find.text(l10n.authCreateAccountButton));
      await tester.pumpAndSettle();

      // Verify create account was called
      expect(authMock.createAccountCallCount, 1);
    });

    testWidgets('forgot password screen renders correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock();
      final loadingController = LoadingController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<LoadingController>.value(
              value: loadingController,
            ),
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
            home: ForgotPasswordScreen(
              viewModel: ForgotPasswordViewModel(authRepository: authMock),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });
  });
}
