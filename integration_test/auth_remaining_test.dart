import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/features/auth/create_account/create_account_screen.dart';
import 'package:wishing_well/features/auth/create_account/create_account_view_model.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_view_model.dart';
import 'package:wishing_well/features/auth/reset_password/reset_password_screen.dart';
import 'package:wishing_well/features/auth/reset_password/reset_password_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';
import 'package:wishing_well/utils/result.dart';
import 'helpers/integration_test_groups.dart';
import 'mocks/integration_mock_auth_repository.dart';
import 'providers/integration_test_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(IntegrationTestGroups.authentication, () {
    testWidgets('create account screen renders with form fields', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock();
      final loadingController = StatusOverlayController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<StatusOverlayController>.value(
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

      // Assert - verify form fields are present
      expect(
        find.byType(TextFormField),
        findsNWidgets(3),
      ); // email, password, confirm
    });

    testWidgets('create account with success result calls repository', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationMockAuthRepository(
        createAccountResult: const Result.ok(null),
      );
      final loadingController = StatusOverlayController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<StatusOverlayController>.value(
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

      // Fill form
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'newuser@example.com');
      await tester.pumpAndSettle();
      await tester.enterText(textFields.at(1), 'password123');
      await tester.pumpAndSettle();
      await tester.enterText(textFields.at(2), 'password123');
      await tester.pumpAndSettle();

      // Tap create
      final l10n = AppLocalizations.of(
        tester.element(find.byType(MaterialApp)),
      )!;
      await tester.tap(find.text(l10n.authCreateAccountButton));
      await tester.pumpAndSettle();

      // Verify
      expect(authMock.createAccountCallCount, 1);
    });

    testWidgets('forgot password screen renders with email field', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock();
      final loadingController = StatusOverlayController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<StatusOverlayController>.value(
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
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('reset password screen renders with form fields', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock();
      final loadingController = StatusOverlayController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<StatusOverlayController>.value(
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
            home: ResetPasswordScreen(
              viewModel: ResetPasswordViewModel(
                authRepository: authMock,
                email: 'test@example.com',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - verify form fields are present (password, confirm password)
      expect(find.byType(TextFormField), findsNWidgets(2));
    });
  });
}
