import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/screens/auth/reset_password/reset_password_screen.dart';
import 'package:wishing_well/screens/auth/reset_password/reset_password_view_model.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

// Helper functions for GoRouter routes
Widget _resetPasswordConfirmationScreenBuilder(
  BuildContext context,
  GoRouterState state,
) => const Scaffold(body: Text('Reset Password Confirmation Screen'));

Widget _resetPasswordScreenBuilder(BuildContext context, GoRouterState state) =>
    ResetPasswordScreen(
      viewModel: ResetPasswordViewModel(
        authRepository: MockAuthRepository(),
        email: '',
        token: '',
      ),
    );

void main() {
  group('ResetPasswordScreen', () {
    late LoadingController loadingController;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      loadingController = LoadingController();
      mockAuthRepository = MockAuthRepository();
    });

    tearDown(() {
      loadingController.dispose();
    });

    Widget createResetPasswordTestWidget({
      String? token,
      AuthRepository? authRepository,
    }) => MultiProvider(
      providers: [
        ChangeNotifierProvider<LoadingController>.value(
          value: loadingController,
        ),
        ListenableProvider<AuthRepository>.value(
          value: authRepository ?? mockAuthRepository,
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GoRouter(
          routes: [
            GoRoute(path: '/', builder: _resetPasswordScreenBuilder),
            GoRoute(
              path: '/reset-password-confirmation',
              name: Routes.resetPasswordConfirmation.name,
              builder: _resetPasswordConfirmationScreenBuilder,
            ),
          ],
        ),
      ),
    );

    group(TestGroups.rendering, () {
      testWidgets('renders with all required UI elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createResetPasswordTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        // Verify screen title appears twice (header and button)
        TestHelpers.expectTextTimes('Reset Password', 2);

        // Verify instruction text
        TestHelpers.expectTextOnce('Enter and confirm your new password below');

        // Verify input fields
        expect(find.widgetWithText(AppInput, 'Password'), findsOneWidget);
        expect(
          find.widgetWithText(AppInput, 'Confirm Password'),
          findsOneWidget,
        );

        // Verify reset button
        final resetButtonFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );
        expect(resetButtonFinder, findsOneWidget);

        // Verify close button
        expect(find.byIcon(Icons.close), findsOneWidget);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('password field updates correctly when text is entered', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createResetPasswordTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final passwordFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFieldFinder,
          'newPassword123',
        );

        final editableTextFinder = find.descendant(
          of: passwordFieldFinder,
          matching: find.byType(EditableText),
        );
        final editableText = tester.widget<EditableText>(editableTextFinder);
        expect(editableText.controller.text, 'newPassword123');
      });

      testWidgets(
        'confirm password field updates correctly when text is entered',
        (WidgetTester tester) async {
          await tester.pumpWidget(createResetPasswordTestWidget());
          await TestHelpers.pumpAndSettle(tester);

          final confirmPasswordFieldFinder = find.byWidgetPredicate(
            (widget) =>
                widget is AppInput &&
                widget.type == AppInputType.password &&
                widget.placeholder == 'Confirm Password',
          );

          await TestHelpers.enterTextAndSettle(
            tester,
            confirmPasswordFieldFinder,
            'newPassword123',
          );

          final editableTextFinder = find.descendant(
            of: confirmPasswordFieldFinder,
            matching: find.byType(EditableText),
          );
          final editableText = tester.widget<EditableText>(editableTextFinder);
          expect(editableText.controller.text, 'newPassword123');
        },
      );
    });

    group(TestGroups.validation, () {
      testWidgets('shows error when password field is empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createResetPasswordTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final resetButtonFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );

        await tester.ensureVisible(resetButtonFinder);
        await TestHelpers.tapAndSettle(tester, resetButtonFinder);

        TestHelpers.expectTextOnce('Password does not meet above requirements');
      });

      testWidgets('shows error when password is too short', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createResetPasswordTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final passwordFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFieldFinder,
          'short',
        );

        final resetButtonFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );

        await tester.ensureVisible(resetButtonFinder);
        await TestHelpers.tapAndSettle(tester, resetButtonFinder);

        TestHelpers.expectTextOnce('Password does not meet above requirements');
      });

      testWidgets('shows error when password lacks uppercase letter', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createResetPasswordTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final passwordFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFieldFinder,
          'lowercase123',
        );

        final resetButtonFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );

        await tester.ensureVisible(resetButtonFinder);
        await TestHelpers.tapAndSettle(tester, resetButtonFinder);

        TestHelpers.expectTextOnce('Password does not meet above requirements');
      });

      testWidgets('shows error when password lacks lowercase letter', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createResetPasswordTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final passwordFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFieldFinder,
          'UPPERCASE123',
        );

        final resetButtonFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );

        await tester.ensureVisible(resetButtonFinder);
        await TestHelpers.tapAndSettle(tester, resetButtonFinder);

        TestHelpers.expectTextOnce('Password does not meet above requirements');
      });

      testWidgets('shows error when password lacks digits', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createResetPasswordTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final passwordFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFieldFinder,
          'PasswordABC',
        );

        final resetButtonFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );

        await tester.ensureVisible(resetButtonFinder);
        await TestHelpers.tapAndSettle(tester, resetButtonFinder);

        TestHelpers.expectTextOnce('Password does not meet above requirements');
      });

      testWidgets('shows error when password lacks special characters', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createResetPasswordTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final passwordFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFieldFinder,
          'Password123',
        );

        final resetButtonFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );

        await tester.ensureVisible(resetButtonFinder);
        await TestHelpers.tapAndSettle(tester, resetButtonFinder);

        TestHelpers.expectTextOnce('Password does not meet above requirements');
      });

      testWidgets('shows error when passwords do not match', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createResetPasswordTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final passwordFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );

        final confirmPasswordFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Confirm Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFieldFinder,
          'Password123!',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          confirmPasswordFieldFinder,
          'DifferentPassword123!',
        );

        final resetButtonFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );

        await tester.ensureVisible(resetButtonFinder);
        await TestHelpers.tapAndSettle(tester, resetButtonFinder);

        TestHelpers.expectTextOnce('Password does not meet above requirements');
      });

      testWidgets('shows no error when valid password is entered', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createResetPasswordTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final passwordFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );

        final confirmPasswordFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Confirm Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFieldFinder,
          'Password123!',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          confirmPasswordFieldFinder,
          'Password123!',
        );

        final resetButtonFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );

        await tester.ensureVisible(resetButtonFinder);
        await TestHelpers.tapAndSettle(tester, resetButtonFinder);

        expect(
          find.text('Password does not meet above requirements'),
          findsNothing,
        );
      });
    });

    // group(TestGroups.errorHandling, () {
    //   testWidgets('displays Supabase error when API call fails', (
    //     WidgetTester tester,
    //   ) async {
    //     final errorRepository = MockAuthRepository(
    //       resetUserPasswordResult: Result.error(
    //         AuthApiException('Invalid or expired reset token'),
    //       ),
    //     );

    //     await tester.pumpWidget(
    //       createResetPasswordTestWidget(
    //         token: 'invalid-token',
    //         authRepository: errorRepository,
    //       ),
    //     );
    //     await TestHelpers.pumpAndSettle(tester);

    //     final passwordFieldFinder = find.byWidgetPredicate(
    //       (widget) =>
    //           widget is AppInput &&
    //           widget.type == AppInputType.password &&
    //           widget.placeholder == 'Password',
    //     );

    //     final confirmPasswordFieldFinder = find.byWidgetPredicate(
    //       (widget) =>
    //           widget is AppInput &&
    //           widget.type == AppInputType.password &&
    //           widget.placeholder == 'Confirm Password',
    //     );

    //     await TestHelpers.enterTextAndSettle(
    //       tester,
    //       passwordFieldFinder,
    //       'Password123!',
    //     );
    //     await TestHelpers.enterTextAndSettle(
    //       tester,
    //       confirmPasswordFieldFinder,
    //       'Password123!',
    //     );

    //     final resetButtonFinder = find.byWidgetPredicate(
    //       (widget) =>
    //widget is AppButton && widget.label == 'Reset Password',
    //     );

    //     await tester.ensureVisible(resetButtonFinder);
    //     await TestHelpers.tapAndSettle(tester, resetButtonFinder);

    //     // Allow error dialog to appear
    //     await tester.pump();

    //     // Verify some error message appears (error messages may vary)
    //     expect(find.byType(AlertDialog), findsOneWidget);
    //   });

    //   testWidgets('displays generic error for unknown exceptions', (
    //     WidgetTester tester,
    //   ) async {
    //     final errorRepository = MockAuthRepository(
    //       resetUserPasswordResult: Result.error(Exception('Network error')),
    //     );

    //     await tester.pumpWidget(
    //       createResetPasswordTestWidget(
    //         token: 'test-token',
    //         authRepository: errorRepository,
    //       ),
    //     );
    //     await TestHelpers.pumpAndSettle(tester);

    //     final passwordFieldFinder = find.byWidgetPredicate(
    //       (widget) =>
    //           widget is AppInput &&
    //           widget.type == AppInputType.password &&
    //           widget.placeholder == 'Password',
    //     );

    //     final confirmPasswordFieldFinder = find.byWidgetPredicate(
    //       (widget) =>
    //           widget is AppInput &&
    //           widget.type == AppInputType.password &&
    //           widget.placeholder == 'Confirm Password',
    //     );

    //     await TestHelpers.enterTextAndSettle(
    //       tester,
    //       passwordFieldFinder,
    //       'Password123!',
    //     );
    //     await TestHelpers.enterTextAndSettle(
    //       tester,
    //       confirmPasswordFieldFinder,
    //       'Password123!',
    //     );

    //     final resetButtonFinder = find.byWidgetPredicate(
    //       (widget) =>
    //widget is AppButton && widget.label == 'Reset Password',
    //     );

    //     await tester.ensureVisible(resetButtonFinder);
    //     await TestHelpers.tapAndSettle(tester, resetButtonFinder);

    //     // Verify error message appears
    //     expect(
    //       find.text('An unknown error occured. Please try again'),
    //       findsOneWidget,
    //     );
    //   });
    // });

    group(TestGroups.behavior, () {
      testWidgets('maintains proper component structure and layout', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createResetPasswordTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        // Verify screen is properly structured
        expect(find.byType(ResetPasswordScreen), findsOneWidget);

        // Verify input fields are accessible
        final passwordFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        final confirmPasswordFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Confirm Password',
        );

        expect(passwordFieldFinder, findsOneWidget);
        expect(confirmPasswordFieldFinder, findsOneWidget);

        // Verify button is properly configured
        final resetButtonFinder = find.byWidgetPredicate(
          (widget) => widget is AppButton && widget.label == 'Reset Password',
        );
        expect(resetButtonFinder, findsOneWidget);

        final resetButton = tester.widget<AppButton>(resetButtonFinder);
        expect(resetButton.label, 'Reset Password');
        expect(resetButton.onPressed, isNotNull);
      });
    });
  });
}
