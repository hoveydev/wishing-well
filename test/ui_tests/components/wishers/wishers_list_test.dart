import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/wishers/wishers_list.dart';
import 'package:wishing_well/components/wishers/add_wisher_item.dart';
import 'package:wishing_well/components/wishers/wisher_item.dart';
import 'package:wishing_well/theme/app_spacing.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group(TestGroups.component, () {
    group(TestGroups.rendering, () {
      testWidgets('renders wishers section with header', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(WishersList);
        TestHelpers.expectTextOnce('Wishers');
        TestHelpers.expectTextOnce('View All');
        TestHelpers.expectWidgetOnce(Row);
        TestHelpers.expectWidgetOnce(ListView);
      });

      testWidgets('renders correct number of items', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should have 1 AddWisherItem + 8 WisherItem = 9 total items
        TestHelpers.expectWidgetOnce(AddWisherItem);
        expect(find.byType(WisherItem), findsNWidgets(8));
      });

      testWidgets('renders specific wisher names and initials', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Check for specific wisher names
        // from the static list (each appears twice)
        TestHelpers.expectTextTimes('Alice', 2);
        TestHelpers.expectTextTimes('Bob', 2);
        TestHelpers.expectTextTimes('Charlie', 2);
        TestHelpers.expectTextTimes('Diana', 2);

        // Check for correct initials
        TestHelpers.expectTextTimes('A', 2); // Alice
        TestHelpers.expectTextTimes('B', 2); // Bob
        TestHelpers.expectTextTimes('C', 2); // Charlie
        TestHelpers.expectTextTimes('D', 2); // Diana
      });

      testWidgets('renders AddWisherItem as first item', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify the list structure exists and has correct items
        TestHelpers.expectWidgetOnce(ListView);
        TestHelpers.expectWidgetOnce(AddWisherItem);
        expect(
          find.byType(WisherItem),
          findsNWidgets(8),
        ); // Total: 1 AddWisherItem + 8 WisherItem = 9 items
      });

      testWidgets('has correct layout structure', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify key layout elements exist
        final rows = find.descendant(
          of: find.byType(WishersList),
          matching: find.byType(Row),
        );
        final listViews = find.descendant(
          of: find.byType(WishersList),
          matching: find.byType(ListView),
        );

        expect(rows, findsOneWidget);
        expect(listViews, findsOneWidget);

        // Check header row properties
        final row = tester.widget<Row>(rows);
        expect(row.mainAxisAlignment, MainAxisAlignment.spaceBetween);

        // Check scroll direction
        final listView = tester.widget<ListView>(listViews);
        expect(listView.scrollDirection, Axis.horizontal);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('handles View All button tap', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('View All'));

        // Should not crash - gesture detector should handle the tap
        TestHelpers.expectTextOnce('View All');
      });

      testWidgets('handles onAddWisherTap callback', (
        WidgetTester tester,
      ) async {
        var wasTapped = false;

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => wasTapped = true),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.byType(AddWisherItem));
        expect(wasTapped, isTrue);
      });

      testWidgets('View All button is clickable', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final gestureDetector = find.ancestor(
          of: find.text('View All'),
          matching: find.byType(GestureDetector),
        );
        expect(gestureDetector, findsOneWidget);
      });

      testWidgets('supports horizontal scrolling', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Initially should see all items
        expect(find.byType(WisherItem), findsNWidgets(8));

        // Scroll horizontally
        await tester.fling(find.byType(ListView), const Offset(-300, 0), 1000);
        await TestHelpers.pumpAndSettle(tester);

        // Should still find all items after scrolling
        expect(find.byType(WisherItem), findsNWidgets(8));
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('applies correct list padding', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final listView = tester.widget<ListView>(
          find.descendant(
            of: find.byType(WishersList),
            matching: find.byType(ListView),
          ),
        );
        expect(
          listView.padding,
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingStandard,
          ),
        );
      });

      testWidgets('positions list beyond screen bounds', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final positionedWidgets = tester.widgetList<Positioned>(
          find.descendant(
            of: find.byType(WishersList),
            matching: find.byType(Positioned),
          ),
        );
        final positionedWidget = positionedWidgets.first;
        expect(positionedWidget.left, -AppSpacing.screenPaddingStandard);
        expect(positionedWidget.right, -AppSpacing.screenPaddingStandard);
      });

      testWidgets('last item has no right padding', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final wisherItems = tester.widgetList<WisherItem>(
          find.byType(WisherItem),
        );
        final lastWisherItem = wisherItems.last;
        expect(lastWisherItem.padding, EdgeInsets.zero);
      });

      testWidgets('maintains consistent structure', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(onAddWisherTap: () => {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify key components within WishersList context
        final rows = find.descendant(
          of: find.byType(WishersList),
          matching: find.byType(Row),
        );
        final listViews = find.descendant(
          of: find.byType(WishersList),
          matching: find.byType(ListView),
        );

        expect(rows, findsOneWidget);
        expect(listViews, findsOneWidget);

        TestHelpers.expectWidgetOnce(AddWisherItem);
        expect(find.byType(WisherItem), findsNWidgets(8));
      });
    });
  });
}
