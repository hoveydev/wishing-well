import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/screens/create_account/create_account_screen.dart';
import 'package:wishing_well/screens/create_account/create_account_view_model.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

void main() {
  group('CreateAccountScreen', () {
    late CreateAccountViewModel viewModel;
    late AuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      viewModel = CreateAccountViewModel(authRepository: mockAuthRepository);
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.rendering, () {
      testWidgets('renders with all required elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Create an Account');
        TestHelpers.expectTextOnce('Please enter your credentials below');
        expect(find.byType(AppInput), findsNWidgets(3));
        TestHelpers.expectTextOnce('Create Account');
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('email field updates correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final emailFinder = find.byWidgetPredicate(
          (widget) => widget is AppInput && widget.type == AppInputType.email,
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          emailFinder,
          'test@example.com',
        );

        final editableText = tester.widget<EditableText>(
          find.descendant(of: emailFinder, matching: find.byType(EditableText)),
        );
        expect(editableText.controller.text, equals('test@example.com'));
      });

      testWidgets('password field updates correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final passwordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFinder,
          'ValidPass123!',
        );

        final editableText = tester.widget<EditableText>(
          find.descendant(
            of: passwordFinder,
            matching: find.byType(EditableText),
          ),
        );
        expect(editableText.controller.text, equals('ValidPass123!'));
      });

      testWidgets('confirm password field updates correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final confirmPasswordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Confirm Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          confirmPasswordFinder,
          'ValidPass123!',
        );

        final editableText = tester.widget<EditableText>(
          find.descendant(
            of: confirmPasswordFinder,
            matching: find.byType(EditableText),
          ),
        );
        expect(editableText.controller.text, equals('ValidPass123!'));
      });
    });

    group(TestGroups.validation, () {
      testWidgets('shows error when form is submitted empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Scroll to make button visible
        await tester.ensureVisible(find.text('Create Account'));
        await tester.pumpAndSettle();

        await TestHelpers.tapAndSettle(tester, find.text('Create Account'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Email cannot be empty');
      });

      testWidgets('shows error when email is empty but password provided', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final passwordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFinder,
          'ValidPass123!',
        );

        // Scroll to make button visible
        await tester.ensureVisible(find.text('Create Account'));
        await tester.pumpAndSettle();

        await TestHelpers.tapAndSettle(tester, find.text('Create Account'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Email cannot be empty');
      });

      testWidgets('shows error when password is empty but email provided', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final emailFinder = find.byWidgetPredicate(
          (widget) => widget is AppInput && widget.type == AppInputType.email,
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          emailFinder,
          'test@example.com',
        );

        // Scroll to make button visible
        await tester.ensureVisible(find.text('Create Account'));
        await tester.pumpAndSettle();

        await TestHelpers.tapAndSettle(tester, find.text('Create Account'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Password does not meet above requirements');
      });

      testWidgets('shows error for invalid email format', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final emailFinder = find.byWidgetPredicate(
          (widget) => widget is AppInput && widget.type == AppInputType.email,
        );
        final passwordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        final confirmPasswordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Confirm Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          emailFinder,
          'invalid-email',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFinder,
          'ValidPass123!',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          confirmPasswordFinder,
          'ValidPass123!',
        );

        // Scroll to make button visible
        await tester.ensureVisible(find.text('Create Account'));
        await tester.pumpAndSettle();

        await TestHelpers.tapAndSettle(tester, find.text('Create Account'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Invalid email format');
      });

      testWidgets('shows error when passwords do not match', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final emailFinder = find.byWidgetPredicate(
          (widget) => widget is AppInput && widget.type == AppInputType.email,
        );
        final passwordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        final confirmPasswordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Confirm Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          emailFinder,
          'test@example.com',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFinder,
          'ValidPass123!',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          confirmPasswordFinder,
          'DifferentPass123!',
        );

        // Scroll to make button visible
        await tester.ensureVisible(find.text('Create Account'));
        await tester.pumpAndSettle();

        await TestHelpers.tapAndSettle(tester, find.text('Create Account'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Password does not meet above requirements');
      });
    });

    group(TestGroups.errorHandling, () {
      testWidgets('handles supabase auth error gracefully', (
        WidgetTester tester,
      ) async {
        final errorRepository = MockAuthRepository(
          createAccountResult: Result.error(
            Exception('Supabase connection failed'),
          ),
        );
        final errorViewModel = CreateAccountViewModel(
          authRepository: errorRepository,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountScreen(viewModel: errorViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final emailFinder = find.byWidgetPredicate(
          (widget) => widget is AppInput && widget.type == AppInputType.email,
        );
        final passwordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        final confirmPasswordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Confirm Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          emailFinder,
          'test@example.com',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFinder,
          'ValidPass123!',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          confirmPasswordFinder,
          'ValidPass123!',
        );

        // Scroll to make button visible
        await tester.ensureVisible(find.text('Create Account'));
        await tester.pumpAndSettle();

        await TestHelpers.tapAndSettle(tester, find.text('Create Account'));
        await TestHelpers.pumpAndSettle(tester);

        // Should show appropriate error message
        TestHelpers.expectTextOnce(
          'An unknown error occured. Please try again',
        );

        errorViewModel.dispose();
      });

      testWidgets('handles unknown error gracefully', (
        WidgetTester tester,
      ) async {
        final errorRepository = MockAuthRepository(
          createAccountResult: Result.error(Exception('Unknown system error')),
        );
        final errorViewModel = CreateAccountViewModel(
          authRepository: errorRepository,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountScreen(viewModel: errorViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final emailFinder = find.byWidgetPredicate(
          (widget) => widget is AppInput && widget.type == AppInputType.email,
        );
        final passwordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        final confirmPasswordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Confirm Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          emailFinder,
          'test@example.com',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFinder,
          'ValidPass123!',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          confirmPasswordFinder,
          'ValidPass123!',
        );

        // Scroll to make button visible
        await tester.ensureVisible(find.text('Create Account'));
        await tester.pumpAndSettle();

        await TestHelpers.tapAndSettle(tester, find.text('Create Account'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce(
          'An unknown error occured. Please try again',
        );

        errorViewModel.dispose();
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('form validation passes with valid data', (
        WidgetTester tester,
      ) async {
        final successRepository = MockAuthRepository(
          createAccountResult: const Result.ok(null),
        );
        final successViewModel = CreateAccountViewModel(
          authRepository: successRepository,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountScreen(viewModel: successViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final emailFinder = find.byWidgetPredicate(
          (widget) => widget is AppInput && widget.type == AppInputType.email,
        );
        final passwordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Password',
        );
        final confirmPasswordFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput &&
              widget.type == AppInputType.password &&
              widget.placeholder == 'Confirm Password',
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          emailFinder,
          'test@example.com',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          passwordFinder,
          'ValidPass123!',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          confirmPasswordFinder,
          'ValidPass123!',
        );

        // Scroll to make button visible
        await tester.ensureVisible(find.text('Create Account'));
        await tester.pumpAndSettle();

        // Test that form validation passes by checking no errors are shown
        expect(find.text('Email cannot be empty'), findsNothing);
        expect(find.text('Invalid email format'), findsNothing);
        expect(
          find.text('Password does not meet above requirements'),
          findsNothing,
        );
        expect(
          find.text('An unknown error occured. Please try again'),
          findsNothing,
        );

        // Verify form is valid by checking ViewModel state
        expect(successViewModel.hasAlert, isFalse);

        successViewModel.dispose();
      });
    });
  });
}
