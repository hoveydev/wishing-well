import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/wishers/add_wisher_item.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group(TestGroups.component, () {
    group(TestGroups.rendering, () {
      testWidgets('renders with correct structure', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherItem(EdgeInsets.zero, () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherItem);
        TestHelpers.expectWidgetOnce(TouchFeedbackOpacity);
        TestHelpers.expectWidgetOnce(DottedBorder);
        TestHelpers.expectWidgetOnce(CircleAvatar);
        TestHelpers.expectTextOnce('Add');
        TestHelpers.expectWidgetOnce(Icon);

        // Verify the main column structure within AddWisherItem
        final column = tester.widget<Column>(
          find.descendant(
            of: find.byType(AddWisherItem),
            matching: find.byType(Column),
          ),
        );
        expect(
          column.children.length,
          3,
        ); // TouchFeedbackOpacity, AppSpacer, and Text
      });

      testWidgets('renders Add text from localization', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherItem(EdgeInsets.zero, () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Add');
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('calls onTap when tapped', (WidgetTester tester) async {
        var wasTapped = false;

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherItem(EdgeInsets.zero, () => wasTapped = true),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.byType(AddWisherItem));
        expect(wasTapped, isTrue);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('applies padding correctly', (WidgetTester tester) async {
        const testPadding = EdgeInsets.all(16.0);

        await tester.pumpWidget(
          createScreenComponentTestWidget(AddWisherItem(testPadding, () => {})),
        );
        await TestHelpers.pumpAndSettle(tester);

        final addWisherItem = tester.widget<AddWisherItem>(
          find.byType(AddWisherItem),
        );
        expect(addWisherItem.padding, testPadding);
      });

      testWidgets('renders with CircleAvatar radius 28', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherItem(EdgeInsets.zero, () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final circleAvatar = tester.widget<CircleAvatar>(
          find.byType(CircleAvatar),
        );
        expect(circleAvatar.radius, 28);
      });
    });
  });
}
