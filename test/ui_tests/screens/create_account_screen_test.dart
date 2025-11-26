import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/create_account/create_account_screen.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';

dynamic startAppWithForgotPasswordScreen(WidgetTester tester) async {
  final MaterialApp app = MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: CreateAccountScreen(viewModel: CreateAccountViewmodel()),
  );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}

void main() {
  group('Create Account Screen Tests', () {
    testWidgets('Renders Screen With All Elements', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
      expect(find.text('Create an Account'), findsOneWidget);
      expect(find.text('Please enter your credentials below'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
      expect(
        find.widgetWithText(TextField, 'Confirm Password'),
        findsOneWidget,
      );
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('Email Text Field Updates', (WidgetTester tester) async {
      await startAppWithForgotPasswordScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'test.email@email.com');
      await tester.pumpAndSettle();
      final textFieldFinder = find.descendant(
        of: emailWidgetFinder,
        matching: find.byType(EditableText),
      );
      final textField = tester.widget<EditableText>(textFieldFinder);
      expect(textField.controller.text, 'test.email@email.com');
    });

    testWidgets('Password Text Field Updates', (WidgetTester tester) async {
      await startAppWithForgotPasswordScreen(tester);
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

    testWidgets('Confirm Password Text Field Updates', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
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

    testWidgets('Create Account Success', (WidgetTester tester) async {
      await startAppWithForgotPasswordScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'email@email.com');
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
      await tester.tap(find.text('Create Account'));
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
      expect(find.text('Passwords must matc'), findsNothing);
    });
  });

  group('Create Account Error Scenarios', () {
    testWidgets('No Email No Password Create Account Error', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(find.text('Email and password cannot be empty'), findsOneWidget);
    });

    testWidgets('No Email Only Create Account Error', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Password',
      );
      await tester.enterText(passwordWidgetFinder, 'password');
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(find.text('Email cannot be empty'), findsOneWidget);
    });

    testWidgets('No Password Only Create Account Error', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'email@email.com');
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(find.text('Password cannot be empty'), findsOneWidget);
    });

    testWidgets('Invalid Email Create Account Error', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'bad-email');
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Password',
      );
      await tester.enterText(passwordWidgetFinder, 'password');
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(find.text('Invalid email format'), findsOneWidget);
    });

    testWidgets('Invalid Password Length Create Account Error', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'email@email.com');
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Password',
      );
      await tester.enterText(passwordWidgetFinder, 'password');
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password must be at least 12 characters long'),
        findsOneWidget,
      );
    });

    testWidgets('No Uppercase in Password Create Account Error', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'email@email.com');
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Password',
      );
      await tester.enterText(passwordWidgetFinder, 'password123456');
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password must contain at least 1 uppercase letter'),
        findsOneWidget,
      );
    });

    testWidgets('No Lowercase in Password Create Account Error', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'email@email.com');
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Password',
      );
      await tester.enterText(passwordWidgetFinder, 'PASSWORD123456');
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password must contain at least 1 lowercase letter'),
        findsOneWidget,
      );
    });

    testWidgets('No Digits in Password Create Account Error', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'email@email.com');
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Password',
      );
      await tester.enterText(passwordWidgetFinder, 'passwordPASSWORD');
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password must contain at least 1 digit'),
        findsOneWidget,
      );
    });

    testWidgets('No Special Character in Password Create Account Error', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'email@email.com');
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Password',
      );
      await tester.enterText(passwordWidgetFinder, 'password123456PASSWORD');
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password must contain at least 1 special character'),
        findsOneWidget,
      );
    });

    testWidgets('Passwords Don\'t Match Create Account Error', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'email@email.com');
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
      await tester.enterText(confirmPasswordWidgetFinder, 'password123456P@#');
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(find.text('Passwords must match'), findsOneWidget);
    });
  });
}
