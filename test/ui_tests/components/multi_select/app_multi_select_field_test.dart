import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/checklist/checklist_icon.dart';
import 'package:wishing_well/components/multi_select/app_multi_select_field.dart';
import 'package:wishing_well/components/multi_select/multi_select_sheet.dart';
import 'package:wishing_well/components/sheet/app_selection_sheet.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

const _testItems = [
  AppMultiSelectItem(value: 'apple', label: 'Apple'),
  AppMultiSelectItem(value: 'banana', label: 'Banana'),
  AppMultiSelectItem(value: 'mango', label: 'Mango'),
];

Widget _buildField({
  List<String> selectedValues = const [],
  ValueChanged<List<String>>? onChanged,
}) => createScreenComponentTestWidget(
  AppMultiSelectField(
    items: _testItems,
    selectedValues: selectedValues,
    onChanged: onChanged ?? (_) {},
    placeholder: 'Pick fruits',
    title: 'Favourite Fruits',
  ),
);

void main() {
  group('AppMultiSelectField', () {
    group(TestGroups.initialState, () {
      testWidgets('renders placeholder when nothing is selected', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(_buildField());
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Pick fruits');
      });

      testWidgets('renders checklist icon', (WidgetTester tester) async {
        await tester.pumpWidget(_buildField());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.checklist_outlined), findsOneWidget);
      });

      testWidgets('renders dropdown arrow icon', (WidgetTester tester) async {
        await tester.pumpWidget(_buildField());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      });

      testWidgets('renders TouchFeedbackOpacity as trigger', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(_buildField());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(TouchFeedbackOpacity), findsOneWidget);
      });

      testWidgets('does not show chips when nothing is selected', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(_buildField());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Chip), findsNothing);
      });

      testWidgets('shows count text when values pre-selected', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          _buildField(selectedValues: ['apple', 'banana']),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('2 selected');
      });

      testWidgets('shows chips for pre-selected values', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          _buildField(selectedValues: ['apple', 'banana']),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Chip), findsNWidgets(2));
        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('tapping trigger opens multi-select sheet', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(_buildField());
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(TouchFeedbackOpacity));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(MultiSelectSheet);
      });

      testWidgets('sheet shows title from field', (WidgetTester tester) async {
        await tester.pumpWidget(_buildField());
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(TouchFeedbackOpacity));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Favourite Fruits');
      });

      testWidgets('sheet shows all items', (WidgetTester tester) async {
        await tester.pumpWidget(_buildField());
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(TouchFeedbackOpacity));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Mango'), findsOneWidget);
      });

      testWidgets('selecting items and tapping Done calls onChanged', (
        WidgetTester tester,
      ) async {
        List<String>? changed;

        await tester.pumpWidget(_buildField(onChanged: (v) => changed = v));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(TouchFeedbackOpacity));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Apple'));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Done'));
        await TestHelpers.pumpAndSettle(tester);

        expect(changed, containsAll(['apple']));
      });

      testWidgets('dismissing sheet without Done does not call onChanged', (
        WidgetTester tester,
      ) async {
        var callCount = 0;

        await tester.pumpWidget(_buildField(onChanged: (_) => callCount++));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(TouchFeedbackOpacity));
        await TestHelpers.pumpAndSettle(tester);

        // Dismiss by dragging the sheet down
        await tester.fling(
          find.byType(MultiSelectSheet),
          const Offset(0, 400),
          800,
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(callCount, 0);
      });

      testWidgets('chip delete removes item via onChanged', (
        WidgetTester tester,
      ) async {
        List<String> current = ['apple', 'banana'];

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            StatefulBuilder(
              builder: (context, setState) => AppMultiSelectField(
                items: _testItems,
                selectedValues: current,
                onChanged: (v) => setState(() => current = v),
                placeholder: 'Pick fruits',
                title: 'Fruits',
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Delete "Apple" chip
        final appleChip = find.ancestor(
          of: find.text('Apple'),
          matching: find.byType(Chip),
        );
        final deleteIcon = find.descendant(
          of: appleChip,
          matching: find.byIcon(Icons.cancel),
        );
        await tester.tap(deleteIcon);
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Apple'), findsNothing);
        expect(find.text('Banana'), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('sheet uses AppSheetHeader', (WidgetTester tester) async {
        await tester.pumpWidget(_buildField());
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(TouchFeedbackOpacity));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppSheetHeader), findsOneWidget);
      });

      testWidgets('sheet has ChecklistIcon for each item', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(_buildField());
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(TouchFeedbackOpacity));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(ChecklistIcon), findsNWidgets(_testItems.length));
      });

      testWidgets('pre-selected values show check icon in sheet', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(_buildField(selectedValues: ['banana']));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(TouchFeedbackOpacity));
        await TestHelpers.pumpAndSettle(tester);

        expect(
          find.byWidgetPredicate(
            (w) => w is ChecklistIcon && w.icon == Icons.check,
          ),
          findsOneWidget,
        );
      });

      testWidgets('Done button closes the sheet', (WidgetTester tester) async {
        await tester.pumpWidget(_buildField());
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(TouchFeedbackOpacity));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(MultiSelectSheet), findsOneWidget);

        await tester.tap(find.text('Done'));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(MultiSelectSheet), findsNothing);
      });
    });

    group(TestGroups.validation, () {
      testWidgets('field renders as StatefulWidget', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(_buildField());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppMultiSelectField), findsOneWidget);
      });

      testWidgets('placeholder not shown when items are selected', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(_buildField(selectedValues: ['apple']));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Pick fruits'), findsNothing);
        TestHelpers.expectTextOnce('1 selected');
      });
    });
  });
}
