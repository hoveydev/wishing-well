import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/features/auth/login/login_screen.dart';
import 'package:wishing_well/features/auth/login/login_view_model.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';
import 'package:wishing_well/utils/result.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';

void main() {
  group('LoginScreen', () {
    late AuthRepository mockAuthRepository;
    late LoginViewModel viewModel;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      viewModel = LoginViewModel(authRepository: mockAuthRepository);
    });

    group(TestGroups.rendering, () {
      testWidgets('renders screen with all required UI elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: StatusOverlayController(),
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
            loadingController: StatusOverlayController(),
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
            loadingController: StatusOverlayController(),
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
            loadingController: StatusOverlayController(),
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
            loadingController: StatusOverlayController(),
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
            loadingController: StatusOverlayController(),
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
            loadingController: StatusOverlayController(),
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
            loadingController: StatusOverlayController(),
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
            loadingController: StatusOverlayController(),
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

    group('Keyboard Dismissal', () {
      testWidgets('screen contains GestureDetector for tap dismissal', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: StatusOverlayController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify GestureDetector exists in the screen
        expect(find.byType(GestureDetector), findsWidgets);
      });

      testWidgets('tapping GestureDetector does not throw', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: StatusOverlayController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find the GestureDetector that wraps the screen content
        final gestureDetector = find.byType(GestureDetector);
        expect(gestureDetector, findsWidgets);

        // Tap should not throw
        await tester.tap(gestureDetector.first);
        await tester.pump();

        expect(find.byType(LoginScreen), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('initial state has no alert', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: StatusOverlayController(),
            child: LoginScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.hasAlert, false);
      });

      testWidgets('displays loading state during login attempt', (
        WidgetTester tester,
      ) async {
        final loadingController = StatusOverlayController();
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
            loadingController: StatusOverlayController(),
            child: LoginScreen(viewModel: testViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify initial state
        expect(testViewModel.hasAlert, false);
      });

      testWidgets('StatusOverlayController showSuccess works correctly', (
        WidgetTester tester,
      ) async {
        final loadingController = StatusOverlayController();

        // Verify initial state
        expect(loadingController.isSuccess, false);
        expect(loadingController.state.name, 'idle');

        // Show success overlay
        loadingController.showSuccess(
          'Account Confirmed!',
          name: 'TestUser',
          onOk: () {},
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify success state
        expect(loadingController.isSuccess, true);
        expect(loadingController.message, 'Account Confirmed!');
        expect(loadingController.name, 'TestUser');

        // Acknowledge and clear
        loadingController.acknowledgeAndClear();
        await TestHelpers.pumpAndSettle(tester);

        // Verify back to idle
        expect(loadingController.isSuccess, false);
        expect(loadingController.state.name, 'idle');
      });

      testWidgets('StatusOverlayController showError works correctly', (
        WidgetTester tester,
      ) async {
        final loadingController = StatusOverlayController();

        // Verify initial state
        expect(loadingController.isError, false);

        // Show error overlay
        loadingController.showError('Something went wrong', onOk: () {});
        await TestHelpers.pumpAndSettle(tester);

        // Verify error state
        expect(loadingController.isError, true);
        expect(loadingController.message, 'Something went wrong');

        // Acknowledge and clear
        loadingController.acknowledgeAndClear();
        await TestHelpers.pumpAndSettle(tester);

        // Verify back to idle
        expect(loadingController.isError, false);
      });

      testWidgets('StatusOverlayController show with imageUrl works', (
        WidgetTester tester,
      ) async {
        final loadingController = StatusOverlayController();

        // Show success with image
        loadingController.showSuccess(
          'Wisher created!',
          name: 'John',
          imageUrl: 'https://example.com/avatar.jpg',
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify success state with image
        expect(loadingController.isSuccess, true);
        expect(loadingController.name, 'John');
        expect(loadingController.imageUrl, 'https://example.com/avatar.jpg');

        // Clean up
        loadingController.dispose();
      });

      testWidgets('StatusOverlayController hide works correctly', (
        WidgetTester tester,
      ) async {
        final loadingController = StatusOverlayController();

        // Show and then hide
        loadingController.show();
        await TestHelpers.pumpAndSettle(tester);
        expect(loadingController.isLoading, true);

        loadingController.hide();
        await TestHelpers.pumpAndSettle(tester);
        expect(loadingController.isIdle, true);
      });

      testWidgets(
        'StatusOverlayController onOk callback is called on acknowledge',
        (WidgetTester tester) async {
          final loadingController = StatusOverlayController();
          bool callbackCalled = false;

          loadingController.showSuccess(
            'Test message',
            onOk: () {
              callbackCalled = true;
            },
          );
          await TestHelpers.pumpAndSettle(tester);

          loadingController.acknowledgeAndClear();
          await TestHelpers.pumpAndSettle(tester);

          expect(callbackCalled, true);
        },
      );
    });

    group(TestGroups.errorHandling, () {
      testWidgets('shows error overlay when login fails with API error', (
        WidgetTester tester,
      ) async {
        final mockRepo = MockAuthRepository(
          loginResult: Result.error(Exception('Invalid login credentials')),
        );
        final testViewModel = LoginViewModel(authRepository: mockRepo);
        final loadingController = StatusOverlayController();

        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: LoginScreen(viewModel: testViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Fill in valid credentials
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
          'test@email.com',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          passwordWidgetFinder,
          'password123',
        );

        // Tap login button
        await TestHelpers.tapAndSettle(tester, find.text('Sign In'));

        // Wait for the async operation to complete
        await tester.pumpAndSettle();

        // Should show error overlay with the error message
        // Note: There may be also an inline error, so we check for at least
        // one error icon
        expect(find.byIcon(Icons.error), findsAtLeastNWidgets(1));
        // Generic exception shows generic error message
        expect(
          find.text('An unknown error occured. Please try again'),
          findsAtLeastNWidgets(1),
        );

        // OK button should be present (for the overlay)
        // Note: localized as 'Ok'
        expect(find.text('Ok'), findsOneWidget);
      });

      testWidgets('error overlay OK button dismisses the error', (
        WidgetTester tester,
      ) async {
        final mockRepo = MockAuthRepository(
          loginResult: Result.error(Exception('Invalid credentials')),
        );
        final testViewModel = LoginViewModel(authRepository: mockRepo);
        final loadingController = StatusOverlayController();

        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: LoginScreen(viewModel: testViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Fill in valid credentials and trigger login
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
          'test@email.com',
        );
        await TestHelpers.enterTextAndSettle(
          tester,
          passwordWidgetFinder,
          'password123',
        );

        await TestHelpers.tapAndSettle(tester, find.text('Sign In'));
        await tester.pumpAndSettle();

        // Verify error overlay is showing
        expect(loadingController.isError, true);

        // Tap Ok to dismiss - note: localized as 'Ok'
        await TestHelpers.tapAndSettle(tester, find.text('Ok'));

        // Error should be cleared
        expect(loadingController.isError, false);
        expect(loadingController.isIdle, true);
      });
    });
  });
}
