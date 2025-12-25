import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_viewmodel.dart';

import '../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

dynamic startAppWithForgotPasswordScreen(WidgetTester tester) async {
  final controller = LoadingController();
  final ChangeNotifierProvider app =
      ChangeNotifierProvider<LoadingController>.value(
        value: controller,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: ForgotPasswordScreen(
            viewModel: ForgotPasswordViewModel(
              authRepository: MockAuthRepository(),
            ),
          ),
        ),
      );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}

void main() {
  group('Forgot Password Screen Tests', () {
    testWidgets('Renders Screen with All Elements', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordScreen(tester);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      expect(find.text('Forgot Password'), findsOneWidget);
      expect(
        find.text(
          'Enter your email address below to receive a password reset link',
        ),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
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

    testWidgets('Submit Success', (WidgetTester tester) async {
      await startAppWithForgotPasswordScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'email@email.com');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(find.text('Email cannot be empty'), findsNothing);
      expect(find.text('Invalid email format'), findsNothing);
    });

    testWidgets('No Email Only Login Error', (WidgetTester tester) async {
      await startAppWithForgotPasswordScreen(tester);
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(find.text('Email cannot be empty'), findsOneWidget);
    });

    testWidgets('Invalid Email Login Error', (WidgetTester tester) async {
      await startAppWithForgotPasswordScreen(tester);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'bad-email');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(find.text('Invalid email format'), findsOneWidget);
    });
  });
}
