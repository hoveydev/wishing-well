import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/shared/confirmation/confirmation_screen.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('Forgot Password Confirmation Screen', () {
    group(TestGroups.rendering, () {
      testWidgets('renders screen with all required elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: const ConfirmationScreen.forgotPassword(),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(Icon);
        TestHelpers.expectTextOnce('Reset Password Request Sent!');
        TestHelpers.expectTextOnce(
          'Please check your email for password reset instructions.',
        );
      });
    });
  });
}
