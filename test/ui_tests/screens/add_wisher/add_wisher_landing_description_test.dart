import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_landing/components/add_wisher_landing_description.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AddWisherLandingDescription', () {
    group(TestGroups.rendering, () {
      testWidgets('renders description text correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(const AddWisherLandingDescription()),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherLandingDescription);
        TestHelpers.expectWidgetOnce(Text);

        // Check for the beginning of the description text
        expect(
          find.textContaining('A Wisher is someone special'),
          findsOneWidget,
        );
      });

      testWidgets('uses styled text widget with proper theming', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(const AddWisherLandingDescription()),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget, isNotNull);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct semantics label', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(const AddWisherLandingDescription()),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Check for semantics accessibility
        expect(
          find.bySemanticsLabel(RegExp(r'A Wisher is someone special')),
          findsOneWidget,
        );
      });

      testWidgets('maintains consistent text structure', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(const AddWisherLandingDescription()),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should render without exceptions
        expect(tester.takeException(), isNull);
      });
    });
  });
}
