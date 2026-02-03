import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/wishers/wisher_item.dart';
import 'package:wishing_well/data/models/wisher.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group(TestGroups.component, () {
    const testWisher = Wisher('Alice');

    group(TestGroups.rendering, () {
      testWidgets('renders wisher name and initial', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const WisherItem(testWisher, EdgeInsets.zero),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(WisherItem);
        TestHelpers.expectWidgetOnce(CircleAvatar);
        TestHelpers.expectTextOnce('Alice');
        TestHelpers.expectTextOnce('A');
      });

      testWidgets('renders correct structure', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const WisherItem(testWisher, EdgeInsets.zero),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(WisherItem);
        TestHelpers.expectWidgetOnce(CircleAvatar);
        TestHelpers.expectTextOnce('Alice');
        TestHelpers.expectTextOnce('A');

        // Verify the main column structure within WisherItem
        final columns = find.descendant(
          of: find.byType(WisherItem),
          matching: find.byType(Column),
        );
        expect(columns, findsOneWidget);

        final column = tester.widget<Column>(columns);
        expect(
          column.children.length,
          3,
        ); // TouchFeedbackOpacity, AppSpacer, and Text
      });

      testWidgets('CircleAvatar has correct properties', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const WisherItem(testWisher, EdgeInsets.zero),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final circleAvatar = tester.widget<CircleAvatar>(
          find.byType(CircleAvatar),
        );
        expect(circleAvatar.radius, 30);
      });

      testWidgets('handles special characters in name', (
        WidgetTester tester,
      ) async {
        const specialWisher = Wisher('Alice-123_!@#');

        await tester.pumpWidget(
          createComponentTestWidget(
            const WisherItem(specialWisher, EdgeInsets.zero),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Alice-123_!@#');
        TestHelpers.expectTextOnce('A');
      });

      testWidgets('handles whitespace in name', (WidgetTester tester) async {
        const spaceWisher = Wisher('  Alice Smith  ');

        await tester.pumpWidget(
          createComponentTestWidget(
            const WisherItem(spaceWisher, EdgeInsets.zero),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('  Alice Smith  ');
        TestHelpers.expectTextOnce(' ');
      });

      testWidgets('handles long names', (WidgetTester tester) async {
        const longName = 'VeryLongNameThatExceedsNormalLengthExpectations';
        const longWisher = Wisher(longName);

        await tester.pumpWidget(
          createComponentTestWidget(
            const WisherItem(longWisher, EdgeInsets.zero),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce(longName);
        TestHelpers.expectTextOnce('V');
      });

      testWidgets('renders multiple wishers correctly', (
        WidgetTester tester,
      ) async {
        const wisher1 = Wisher('Alice');
        const wisher2 = Wisher('Bob');

        await tester.pumpWidget(
          createComponentTestWidget(
            const Column(
              children: [
                WisherItem(wisher1, EdgeInsets.zero),
                WisherItem(wisher2, EdgeInsets.zero),
              ],
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(WisherItem), findsNWidgets(2));
        TestHelpers.expectTextOnce('Alice');
        TestHelpers.expectTextOnce('Bob');
        TestHelpers.expectTextOnce('A');
        TestHelpers.expectTextOnce('B');
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('handles tap events', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const WisherItem(testWisher, EdgeInsets.zero),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.byType(CircleAvatar));

        // Should not crash - gesture detector should handle the tap
        TestHelpers.expectWidgetOnce(WisherItem);
      });

      testWidgets('tap gesture works correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const WisherItem(testWisher, EdgeInsets.zero),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final gestureDetector = tester.widget<GestureDetector>(
          find.descendant(
            of: find.byType(WisherItem),
            matching: find.byType(GestureDetector),
          ),
        );
        expect(gestureDetector.onTap, isNotNull);
        expect(gestureDetector.onTapDown, isNotNull);
        expect(gestureDetector.onTapUp, isNotNull);
        expect(gestureDetector.onTapCancel, isNotNull);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('applies padding correctly', (WidgetTester tester) async {
        const testPadding = EdgeInsets.all(16.0);

        await tester.pumpWidget(
          createComponentTestWidget(const WisherItem(testWisher, testPadding)),
        );
        await TestHelpers.pumpAndSettle(tester);

        final wisherItem = tester.widget<WisherItem>(find.byType(WisherItem));
        expect(wisherItem.padding, testPadding);
      });

      testWidgets('uses wisher data correctly', (WidgetTester tester) async {
        const testWisher = Wisher('TestName');

        await tester.pumpWidget(
          createComponentTestWidget(
            const WisherItem(testWisher, EdgeInsets.zero),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final wisherItem = tester.widget<WisherItem>(find.byType(WisherItem));
        expect(wisherItem.wisher.name, 'TestName');
        TestHelpers.expectTextOnce('TestName');
        TestHelpers.expectTextOnce('T');
      });

      testWidgets('TouchFeedbackOpacity has correct duration', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const WisherItem(testWisher, EdgeInsets.zero),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final animatedOpacity = tester.widget<AnimatedOpacity>(
          find.descendant(
            of: find.byType(WisherItem),
            matching: find.byType(AnimatedOpacity),
          ),
        );
        expect(animatedOpacity.duration, const Duration(milliseconds: 100));
      });

      testWidgets('opacity resets after tap', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const WisherItem(testWisher, EdgeInsets.zero),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Check initial opacity
        final initialOpacity = tester.widget<AnimatedOpacity>(
          find.descendant(
            of: find.byType(WisherItem),
            matching: find.byType(AnimatedOpacity),
          ),
        );
        expect(initialOpacity.opacity, 1.0);

        // Test tap gesture works
        await TestHelpers.tapAndSettle(tester, find.byType(CircleAvatar));

        // Should still be at normal opacity after complete tap
        final finalOpacity = tester.widget<AnimatedOpacity>(
          find.descendant(
            of: find.byType(WisherItem),
            matching: find.byType(AnimatedOpacity),
          ),
        );
        expect(finalOpacity.opacity, 1.0);
      });
    });
  });
}
