import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/confirmation/confirmation_screen.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('Create Account Confirmation Screen', () {
    group('Rendering', () {
      testWidgets('renders screen with all required elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: const ConfirmationScreen.createAccount(),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(Icon);
        TestHelpers.expectTextOnce('Account Successfully Created!');
        TestHelpers.expectTextOnce(
          'Please check your email to confirm your account. Your account must '
          'be confirmed before you are able to log in.',
        );
      });
    });
  });
}
