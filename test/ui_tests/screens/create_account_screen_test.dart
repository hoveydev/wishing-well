import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/screens/create_account/create_account_screen.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';

import '../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

dynamic startAppWithCreateAccountScreen(WidgetTester tester) async {
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
          home: CreateAccountScreen(
            viewModel: CreateAccountViewmodel(
              authRepository: MockAuthRepository(),
            ),
          ),
        ),
      );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}

void main() {
  group('create account screen tests', () {
    testWidgets('Renders Screen With All Elements', (
      WidgetTester tester,
    ) async {
      await startAppWithCreateAccountScreen(tester);
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

    testWidgets('email text field updates', (WidgetTester tester) async {
      await startAppWithCreateAccountScreen(tester);
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

    testWidgets('password text field updates', (WidgetTester tester) async {
      await startAppWithCreateAccountScreen(tester);
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
      await startAppWithCreateAccountScreen(tester);
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

    testWidgets('create account validation success', (
      WidgetTester tester,
    ) async {
      await startAppWithCreateAccountScreen(tester);
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
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(find.text('Email cannot be empty'), findsNothing);
      expect(find.text('Password cannot be empty'), findsNothing);
      expect(find.text('Invalid email format'), findsNothing);
      expect(
        find.text('Password does not meet above requirements'),
        findsNothing,
      );
    });
  });

  group('create account error scenarios', () {
    testWidgets('no email no password create account error', (
      WidgetTester tester,
    ) async {
      await startAppWithCreateAccountScreen(tester);
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(find.text('Email cannot be empty'), findsOneWidget);
    });

    testWidgets('no email only create account error', (
      WidgetTester tester,
    ) async {
      await startAppWithCreateAccountScreen(tester);
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Password',
      );
      await tester.enterText(passwordWidgetFinder, 'password');
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(find.text('Email cannot be empty'), findsOneWidget);
    });

    testWidgets('no password only create account error', (
      WidgetTester tester,
    ) async {
      await startAppWithCreateAccountScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'email@email.com');
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password does not meet above requirements'),
        findsOneWidget,
      );
    });

    testWidgets('invalid email create account error', (
      WidgetTester tester,
    ) async {
      await startAppWithCreateAccountScreen(tester);
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
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(find.text('Invalid email format'), findsOneWidget);
    });

    testWidgets('invalid password length create account error', (
      WidgetTester tester,
    ) async {
      await startAppWithCreateAccountScreen(tester);
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
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password does not meet above requirements'),
        findsOneWidget,
      );
    });

    testWidgets('no uppercase in password create account error', (
      WidgetTester tester,
    ) async {
      await startAppWithCreateAccountScreen(tester);
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
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password does not meet above requirements'),
        findsOneWidget,
      );
    });

    testWidgets('no lowercase in password create account error', (
      WidgetTester tester,
    ) async {
      await startAppWithCreateAccountScreen(tester);
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
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password does not meet above requirements'),
        findsOneWidget,
      );
    });

    testWidgets('no digits in password create account error', (
      WidgetTester tester,
    ) async {
      await startAppWithCreateAccountScreen(tester);
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
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password does not meet above requirements'),
        findsOneWidget,
      );
    });

    testWidgets('no special character in password create account error', (
      WidgetTester tester,
    ) async {
      await startAppWithCreateAccountScreen(tester);
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
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password does not meet above requirements'),
        findsOneWidget,
      );
    });

    testWidgets('passwords don\'t match create account error', (
      WidgetTester tester,
    ) async {
      await startAppWithCreateAccountScreen(tester);
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
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password does not meet above requirements'),
        findsOneWidget,
      );
    });
  });
}
