import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/confirmation/confirmation_screen.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('Reset Password Confirmation Screen', () {
    group('Rendering', () {
      testWidgets('renders screen with all required elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: const ConfirmationScreen.resetPassword(),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(Icon);
        TestHelpers.expectTextOnce('Password Successfully Reset!');
        TestHelpers.expectTextOnce('You may now log in with your new password');
      });
    });
  });
}
