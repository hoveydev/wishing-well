import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/reset_password/reset_password_screen.dart';
import 'package:wishing_well/screens/reset_password/reset_password_viewmodel.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

import '../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

dynamic startAppWithResetPasswordScreen(WidgetTester tester) async {
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
              authRepository: MockAuthRepository(),
              email: '',
              token: '',
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

    testWidgets('reset password validation success', (
      WidgetTester tester,
    ) async {
      await startAppWithResetPasswordScreen(tester);
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Password',
      );
      final confirmPasswordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Confirm Password',
      );
      await tester.enterText(passwordWidgetFinder, 'passwordPASSWORD123@#');
      await tester.enterText(
        confirmPasswordWidgetFinder,
        'passwordPASSWORD123@#',
      );
      final resetPasswordButtonWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppButton && widget.label == 'Reset Password',
      );
      await tester.tap(resetPasswordButtonWidgetFinder);
      await tester.pumpAndSettle();
      expect(find.text('Email and password cannot be empty'), findsNothing);
      expect(find.text('Email cannot be empty'), findsNothing);
      expect(find.text('Password cannot be empty'), findsNothing);
      expect(find.text('Invalid email format'), findsNothing);
      expect(
        find.text('Password must be at least 12 characters long'),
        findsNothing,
      );
      expect(
        find.text('Password must contain at least 1 uppercase letter'),
        findsNothing,
      );
      expect(
        find.text('Password must contain at least 1 lowercase letter'),
        findsNothing,
      );
      expect(find.text('Password must contain at least 1 digit'), findsNothing);
      expect(
        find.text('Password must contain at least 1 special character'),
        findsNothing,
      );
      expect(find.text('Passwords must match'), findsNothing);
    });

    group('Reset Password Error Scenarios', () {
      testWidgets('no password only error', (WidgetTester tester) async {
        await startAppWithResetPasswordScreen(tester);
        final resetPasswordButtonWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(find.text('Password cannot be empty'), findsOneWidget);
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
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('Password must be at least 12 characters long'),
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
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('Password must contain at least 1 uppercase letter'),
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
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('Password must contain at least 1 lowercase letter'),
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
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('Password must contain at least 1 digit'),
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
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(
          find.text('Password must contain at least 1 special character'),
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
        await tester.tap(resetPasswordButtonWidgetFinder);
        await tester.pumpAndSettle();
        expect(find.text('Passwords must match'), findsOneWidget);
      });
    });
  });
}
