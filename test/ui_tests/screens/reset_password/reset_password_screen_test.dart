import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/reset_password/reset_password_screen.dart';
import 'package:wishing_well/screens/reset_password/reset_password_viewmodel.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

dynamic startAppWithResetPasswordScreen(
  WidgetTester tester, {
  String? token,
  AuthRepository? mockAuthRepository,
}) async {
  final controller = LoadingController();
  final ChangeNotifierProvider app =
      ChangeNotifierProvider<LoadingController>.value(
        value: controller,
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
            viewmodel: ResetPasswordViewmodel(
              authRepository: mockAuthRepository ?? MockAuthRepository(),
              email: '',
              token: token ?? '',
            ),
          ),
        ),
      );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}

void main() {
  group('Forgot Password Screen Tests', () {
    testWidgets('renders screen with all elements', (
      WidgetTester tester,
    ) async {
      await startAppWithResetPasswordScreen(tester);
      expect(find.text('Reset Password'), findsNWidgets(2));
      expect(
        find.text('Enter and confirm your new password below'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
      expect(
        find.widgetWithText(TextField, 'Confirm Password'),
        findsOneWidget,
      );
      final resetButtonWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppButton && widget.label == 'Reset Password',
      );
      expect(resetButtonWidgetFinder, findsOneWidget);
      final closeIconWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is Icon && widget.icon == Icons.close,
      );
      expect(closeIconWidgetFinder, findsOneWidget);
    });

    testWidgets('password text field updates', (WidgetTester tester) async {
      await startAppWithResetPasswordScreen(tester);
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Password',
      );
      await tester.enterText(passwordWidgetFinder, 'password');
      await tester.pumpAndSettle();
      final textFieldFinder = find.descendant(
        of: passwordWidgetFinder,
        matching: find.byType(EditableText),
      );
      final textField = tester.widget<EditableText>(textFieldFinder);
      expect(textField.controller.text, 'password');
    });

    testWidgets('confirm password text field updates', (
      WidgetTester tester,
    ) async {
      await startAppWithResetPasswordScreen(tester);
      final confirmPasswordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Confirm Password',
      );
      await tester.enterText(confirmPasswordWidgetFinder, 'password');
      await tester.pumpAndSettle();
      final textFieldFinder = find.descendant(
        of: confirmPasswordWidgetFinder,
        matching: find.byType(EditableText),
      );
      final textField = tester.widget<EditableText>(textFieldFinder);
      expect(textField.controller.text, 'password');
    });

    group('Reset Password Error Scenarios', () {
      testWidgets('no password only error', (WidgetTester tester) async {
        await startAppWithResetPasswordScreen(tester);
        final resetPasswordButtonWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );
        await tester.ensureVisible(resetPasswordButtonWidgetFinder);
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('Password does not meet above requirements'),
          findsOneWidget,
        );
      });

      testWidgets('invalid password length error', (WidgetTester tester) async {
        await startAppWithResetPasswordScreen(tester);
        final passwordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        await tester.enterText(passwordWidgetFinder, 'password');
        final resetPasswordButtonWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );
        await tester.ensureVisible(resetPasswordButtonWidgetFinder);
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('Password does not meet above requirements'),
          findsOneWidget,
        );
      });

      testWidgets('no uppercase in password error', (
        WidgetTester tester,
      ) async {
        await startAppWithResetPasswordScreen(tester);
        final passwordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        await tester.enterText(passwordWidgetFinder, 'password123456');
        final resetPasswordButtonWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );
        await tester.ensureVisible(resetPasswordButtonWidgetFinder);
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('Password does not meet above requirements'),
          findsOneWidget,
        );
      });

      testWidgets('no lowercase in password error', (
        WidgetTester tester,
      ) async {
        await startAppWithResetPasswordScreen(tester);
        final passwordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        await tester.enterText(passwordWidgetFinder, 'PASSWORD123456');
        final resetPasswordButtonWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );
        await tester.ensureVisible(resetPasswordButtonWidgetFinder);
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('Password does not meet above requirements'),
          findsOneWidget,
        );
      });

      testWidgets('no digits in password error', (WidgetTester tester) async {
        await startAppWithResetPasswordScreen(tester);
        final passwordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        await tester.enterText(passwordWidgetFinder, 'passwordPASSWORD');
        final resetPasswordButtonWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );
        await tester.ensureVisible(resetPasswordButtonWidgetFinder);
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('Password does not meet above requirements'),
          findsOneWidget,
        );
      });

      testWidgets('no special character in password error', (
        WidgetTester tester,
      ) async {
        await startAppWithResetPasswordScreen(tester);
        final passwordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        await tester.enterText(passwordWidgetFinder, 'password123456PASSWORD');
        final resetPasswordButtonWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );
        await tester.ensureVisible(resetPasswordButtonWidgetFinder);
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('Password does not meet above requirements'),
          findsOneWidget,
        );
      });

      testWidgets('passwords don\'t match error', (WidgetTester tester) async {
        await startAppWithResetPasswordScreen(tester);
        final passwordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        await tester.enterText(passwordWidgetFinder, 'password123456W()');
        final confirmPasswordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        await tester.enterText(
          confirmPasswordWidgetFinder,
          'password123456P@#',
        );
        final resetPasswordButtonWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );
        await tester.ensureVisible(resetPasswordButtonWidgetFinder);
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('Password does not meet above requirements'),
          findsOneWidget,
        );
      });

      testWidgets('supabase error', (WidgetTester tester) async {
        await startAppWithResetPasswordScreen(
          tester,
          token: 'supabase-error-token',
          mockAuthRepository: MockAuthRepository(
            resetUserPasswordResult: Result.error(
              AuthApiException('supabase error'),
            ),
          ),
        );
        final passwordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        await tester.enterText(passwordWidgetFinder, 'Password123456W()');
        final confirmPasswordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Confirm Password',
        );
        await tester.enterText(
          confirmPasswordWidgetFinder,
          'Password123456W()',
        );
        final resetPasswordButtonWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );
        await tester.ensureVisible(resetPasswordButtonWidgetFinder);
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(find.text('supabase error'), findsOneWidget);
      });

      testWidgets('unknown error', (WidgetTester tester) async {
        await startAppWithResetPasswordScreen(
          tester,
          token: 'unknown-error-token',
          mockAuthRepository: MockAuthRepository(
            resetUserPasswordResult: Result.error(Exception('unknown error')),
          ),
        );
        final passwordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        await tester.enterText(passwordWidgetFinder, 'Password123456W()');
        final confirmPasswordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Confirm Password',
        );
        await tester.enterText(
          confirmPasswordWidgetFinder,
          'Password123456W()',
        );
        final resetPasswordButtonWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );
        await tester.ensureVisible(resetPasswordButtonWidgetFinder);
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('An unknown error occured. Please try again'),
          findsOneWidget,
        );
      });
    });
  });
}
