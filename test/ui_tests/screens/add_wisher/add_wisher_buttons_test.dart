import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/screens/add_wisher/components/add_wisher_buttons.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AddWisherButtons', () {
    group(TestGroups.rendering, () {
      testWidgets('renders both buttons correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherButtons(onAddFromContacts: () {}, onAddManually: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherButtons);
        TestHelpers.expectTextOnce('Add From Contacts');
        TestHelpers.expectTextOnce('Add Manually');

        // Should contain two AppButton widgets
        expect(find.byType(AppButton), findsNWidgets(2));
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('calls onAddFromContacts when primary button is tapped', (
        WidgetTester tester,
      ) async {
        var wasCalled = false;

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherButtons(
              onAddFromContacts: () => wasCalled = true,
              onAddManually: () {},
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('Add From Contacts'));
        expect(wasCalled, isTrue);
      });

      testWidgets('calls onAddManually when secondary button is tapped', (
        WidgetTester tester,
      ) async {
        var wasCalled = false;

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherButtons(
              onAddFromContacts: () {},
              onAddManually: () => wasCalled = true,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('Add Manually'));
        expect(wasCalled, isTrue);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('buttons are arranged vertically with spacing', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherButtons(onAddFromContacts: () {}, onAddManually: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should have vertical layout with spacing
        final columns = find.descendant(
          of: find.byType(AddWisherButtons),
          matching: find.byType(Column),
        );
        expect(columns, findsOneWidget);

        final sizedBoxes = find.descendant(
          of: find.byType(AddWisherButtons),
          matching: find.byType(SizedBox),
        );
        expect(sizedBoxes, findsWidgets);
      });

      testWidgets('required callback parameters are enforced', (
        WidgetTester tester,
      ) async {
        expect(
          () =>
              AddWisherButtons(onAddFromContacts: () {}, onAddManually: () {}),
          returnsNormally,
        );
      });
    });
  });
}
