import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/screens/login/login_screen.dart';
import 'package:wishing_well/screens/login/login_view_model.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

dynamic startAppWithLoginScreen(
  WidgetTester tester, {
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
          home: LoginScreen(
            viewModel: LoginViewModel(
              authRepository: mockAuthRepository ?? MockAuthRepository(),
            ),
          ),
        ),
      );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}

void main() {
  group('Login Screen Tests', () {
    testWidgets('Renders Screen With All Elements', (
      WidgetTester tester,
    ) async {
      await startAppWithLoginScreen(tester);
      expect(
        find.image(const AssetImage('assets/images/logo.png')),
        findsOneWidget,
      );
      expect(find.text('WishingWell'), findsOneWidget);
      expect(
        find.text('Your personal well for thoughtful giving'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Create an Account'), findsOneWidget);
    });

    testWidgets('Email Text Field Updates', (WidgetTester tester) async {
      await startAppWithLoginScreen(tester);
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
      await startAppWithLoginScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.password,
      );
      await tester.enterText(emailWidgetFinder, 'password');
      await tester.pumpAndSettle();
      final textFieldFinder = find.descendant(
        of: emailWidgetFinder,
        matching: find.byType(EditableText),
      );
      final textField = tester.widget<EditableText>(textFieldFinder);
      expect(textField.controller.text, 'password');
    });
  });

  group('Login Error Scenarios', () {
    testWidgets('No Email No Password Login Error', (
      WidgetTester tester,
    ) async {
      await startAppWithLoginScreen(tester);
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('Email and password cannot be empty'), findsOneWidget);
    });

    testWidgets('No Email Only Login Error', (WidgetTester tester) async {
      await startAppWithLoginScreen(tester);
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.password,
      );
      await tester.enterText(passwordWidgetFinder, 'password');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('Email cannot be empty'), findsOneWidget);
    });

    testWidgets('No Password Only Login Error', (WidgetTester tester) async {
      await startAppWithLoginScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'email@email.com');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('Password cannot be empty'), findsOneWidget);
    });

    testWidgets('Invalid Email Login Error', (WidgetTester tester) async {
      await startAppWithLoginScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'bad-email');
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.password,
      );
      await tester.enterText(passwordWidgetFinder, 'password');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('Invalid email format'), findsOneWidget);
    });

    testWidgets('supabase error', (WidgetTester tester) async {
      await startAppWithLoginScreen(
        tester,
        mockAuthRepository: MockAuthRepository(
          loginResult: Result.error(AuthApiException('supabase error')),
        ),
      );
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'supabase.error@email.com');
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.password,
      );
      await tester.enterText(passwordWidgetFinder, 'password');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('supabase error'), findsOneWidget);
    });

    testWidgets('unknown error', (WidgetTester tester) async {
      await startAppWithLoginScreen(
        tester,
        mockAuthRepository: MockAuthRepository(
          loginResult: Result.error(Exception('unknown error')),
        ),
      );
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'unknown.error@email.com');
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.password,
      );
      await tester.enterText(passwordWidgetFinder, 'password');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(
        find.text('An unknown error occured. Please try again'),
        findsOneWidget,
      );
    });
  });
}
