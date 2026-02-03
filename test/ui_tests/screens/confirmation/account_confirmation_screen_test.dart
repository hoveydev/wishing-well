import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/confirmation/confirmation_screen.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('Account Confirmation Screen', () {
    group('Rendering', () {
      testWidgets('renders screen with all required elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const ConfirmationScreen.account()),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Account Confirmed!');
        TestHelpers.expectTextOnce(
          'You may now securely log in to WishingWell',
        );
        TestHelpers.expectWidgetOnce(Icon);
      });
    });

    group('Behavior', () {
      testWidgets('handles close icon correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const ConfirmationScreen.account()),
        );
        await TestHelpers.pumpAndSettle(tester);

        final closeIconFinder = find.byWidgetPredicate(
          (widget) => widget is Icon && widget.icon == Icons.close,
        );
        expect(closeIconFinder, findsOneWidget);
      });
    });
  });
}
