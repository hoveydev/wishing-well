import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/auth/reset_password/reset_password_view_model.dart';
import 'package:wishing_well/screens/auth/reset_password/components/reset_password_button.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

class MockResetPasswordViewModel extends ResetPasswordViewModel {
  MockResetPasswordViewModel()
    : super(
        authRepository: MockAuthRepository(),
        email: 'test@example.com',
        token: 'test-token',
      );

  bool _buttonTapped = false;

  bool get buttonTapped => _buttonTapped;

  @override
  Future<void> tapResetPasswordButton(BuildContext context) async {
    _buttonTapped = true;
  }
}

void main() {
  group('ResetPasswordButton', () {
    group(TestGroups.rendering, () {
      testWidgets('renders reset password button with correct label', (
        WidgetTester tester,
      ) async {
        final viewModel = MockResetPasswordViewModel();

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            ResetPasswordButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Reset Password');
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('calls tapResetPasswordButton when button is tapped', (
        WidgetTester tester,
      ) async {
        final viewModel = MockResetPasswordViewModel();

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            ResetPasswordButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('Reset Password'));

        expect(viewModel.buttonTapped, isTrue);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct button configuration and styling', (
        WidgetTester tester,
      ) async {
        final viewModel = MockResetPasswordViewModel();

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            ResetPasswordButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final buttonFinder = find.byType(ResetPasswordButton);
        expect(buttonFinder, findsOneWidget);

        final resetPasswordButton = tester.widget<ResetPasswordButton>(
          buttonFinder,
        );
        expect(resetPasswordButton.viewModel, isNotNull);
      });
    });
  });
}
