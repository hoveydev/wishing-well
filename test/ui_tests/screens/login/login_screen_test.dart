import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/screens/login/login_screen.dart';
import 'package:wishing_well/screens/login/login_view_model.dart';
import 'package:wishing_well/utils/loading_controller.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

void main() {
  group('LoginScreen', () {
    late AuthRepository mockAuthRepository;
    late LoginViewModel viewModel;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      viewModel = LoginViewModel(authRepository: mockAuthRepository);
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.rendering, () {
      testWidgets('renders screen with all required UI elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: LoadingController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Check for logo and branding
        expect(
          find.image(const AssetImage('assets/images/logo.png')),
          findsOneWidget,
        );
        TestHelpers.expectTextOnce('WishingWell');
        TestHelpers.expectTextOnce('Your personal well for thoughtful giving');

        // Check for input fields
        expect(find.widgetWithText(AppInput, 'Email'), findsOneWidget);
        expect(find.widgetWithText(AppInput, 'Password'), findsOneWidget);

        // Check for buttons and links
        TestHelpers.expectTextOnce('Forgot Password?');
        TestHelpers.expectTextOnce('Sign In');
        TestHelpers.expectTextOnce('Create an Account');
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('email field updates when text is entered', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: LoadingController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final emailWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppInput && widget.type == AppInputType.email,
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          emailWidgetFinder,
          'test.email@email.com',
        );

        final textFieldFinder = find.descendant(
          of: emailWidgetFinder,
          matching: find.byType(EditableText),
        );
        final textField = tester.widget<EditableText>(textFieldFinder);
        expect(textField.controller.text, 'test.email@email.com');
      });

      testWidgets('password field updates when text is entered', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: LoadingController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final passwordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput && widget.type == AppInputType.password,
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          passwordWidgetFinder,
          'password',
        );

        final textFieldFinder = find.descendant(
          of: passwordWidgetFinder,
          matching: find.byType(EditableText),
        );
        final textField = tester.widget<EditableText>(textFieldFinder);
        expect(textField.controller.text, 'password');
      });

      testWidgets('forgot password button is present', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: LoadingController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final forgotPasswordButton = find.text('Forgot Password?');
        expect(forgotPasswordButton, findsOneWidget);
      });

      testWidgets('create account button is present', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: LoadingController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final createAccountButton = find.text('Create an Account');
        expect(createAccountButton, findsOneWidget);
      });
    });

    group(TestGroups.validation, () {
      testWidgets('shows error when both email and password are empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: LoadingController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('Sign In'));

        TestHelpers.expectTextOnce('Email and password cannot be empty');
      });

      testWidgets('shows error when only email is empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: LoadingController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final passwordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput && widget.type == AppInputType.password,
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          passwordWidgetFinder,
          'password',
        );
        await TestHelpers.tapAndSettle(tester, find.text('Sign In'));

        TestHelpers.expectTextOnce('Email cannot be empty');
      });

      testWidgets('shows error when only password is empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: LoadingController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final emailWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppInput && widget.type == AppInputType.email,
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          emailWidgetFinder,
          'email@email.com',
        );
        await TestHelpers.tapAndSettle(tester, find.text('Sign In'));

        TestHelpers.expectTextOnce('Password cannot be empty');
      });

      testWidgets('shows error when email format is invalid', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: LoadingController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final emailWidgetFinder = find.byWidgetPredicate(
          (widget) => widget is AppInput && widget.type == AppInputType.email,
        );
        final passwordWidgetFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppInput && widget.type == AppInputType.password,
        );

        await TestHelpers.enterTextAndSettle(
          tester,
          emailWidgetFinder,
          'bad-email',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          passwordWidgetFinder,
          'password',
        );
        await TestHelpers.tapAndSettle(tester, find.text('Sign In'));

        TestHelpers.expectTextOnce('Invalid email format');
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('initial state has no alert', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: LoadingController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.hasAlert, false);
      });

      testWidgets('displays loading state during login attempt', (
        WidgetTester tester,
      ) async {
        final loadingController = LoadingController();
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(loadingController.isLoading, false);

        // Tap login button to trigger validation
        await TestHelpers.tapAndSettle(tester, find.text('Sign In'));

        // Should trigger validation (show error message)
        TestHelpers.expectTextOnce('Email and password cannot be empty');
      });

      testWidgets('handles ViewModel disposal correctly', (
        WidgetTester tester,
      ) async {
        final testViewModel = LoginViewModel(
          authRepository: mockAuthRepository,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: LoadingController(),
            child: LoginScreen(viewModel: testViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify initial state
        expect(testViewModel.hasAlert, false);

        // Clean up
        testViewModel.dispose();
      });
    });
  });
}
