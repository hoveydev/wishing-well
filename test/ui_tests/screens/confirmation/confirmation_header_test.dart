import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/confirmation/components/confirmation_header.dart';
import 'package:wishing_well/screens/confirmation/confirmation_screen.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('ConfirmationHeader', () {
    group(TestGroups.rendering, () {
      testWidgets('renders account confirmation header', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const ConfirmationHeader(flavor: ConfirmationScreenFlavor.account),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Account Confirmed!');
      });

      testWidgets('renders create account confirmation header', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const ConfirmationHeader(
              flavor: ConfirmationScreenFlavor.createAccount,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Account Successfully Created!');
      });

      testWidgets('renders forgot password confirmation header', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const ConfirmationHeader(
              flavor: ConfirmationScreenFlavor.forgotPassword,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Reset Password Request Sent!');
      });

      testWidgets('renders reset password confirmation header', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const ConfirmationHeader(
              flavor: ConfirmationScreenFlavor.resetPassword,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Password Successfully Reset!');
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('uses headlineLarge text style for account confirmation', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const ConfirmationHeader(flavor: ConfirmationScreenFlavor.account),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textFinder = find.text('Account Confirmed!');
        final textWidget = tester.widget<Text>(textFinder);

        expect(textWidget.style?.fontSize, isNotNull);
        expect(textWidget.style?.fontWeight, isNotNull);
      });

      testWidgets('centers text correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const ConfirmationHeader(
              flavor: ConfirmationScreenFlavor.resetPassword,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textFinder = find.text('Password Successfully Reset!');
        final textWidget = tester.widget<Text>(textFinder);

        expect(textWidget.textAlign, TextAlign.center);
      });

      testWidgets('has correct semantics label', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const ConfirmationHeader(flavor: ConfirmationScreenFlavor.account),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textFinder = find.text('Account Confirmed!');
        final textWidget = tester.widget<Text>(textFinder);

        expect(textWidget.semanticsLabel, 'Account Confirmed!');
      });
    });
  });
}
