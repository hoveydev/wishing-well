import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:wishing_well/components/date_picker/app_date_picker_field.dart';
import 'package:wishing_well/components/date_picker/app_date_picker_overlay.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  final firstDate = DateTime(1900);
  final lastDate = DateTime(2100);

  Widget buildTestWidget({
    DateTime? value,
    DateTime? localFirst,
    DateTime? localLast,
  }) => buildMaterialAppHome(
    Scaffold(
      body: AppDatePickerField(
        placeholder: 'Select date',
        value: value,
        firstDate: localFirst ?? firstDate,
        lastDate: localLast ?? lastDate,
        onChanged: (_) {},
      ),
    ),
  );

  group('AppDatePickerField', () {
    group(TestGroups.rendering, () {
      testWidgets('renders placeholder when no date selected', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Select date');
      });

      testWidgets('renders formatted date when value is set', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: DateTime(2025, 6, 15)));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('June 15, 2025');
      });

      testWidgets('renders calendar icon', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
      });

      testWidgets('renders clear icon when date is set', (tester) async {
        await tester.pumpWidget(buildTestWidget(value: DateTime(2025, 6, 15)));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('does not render clear icon when no date set', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.close), findsNothing);
      });

      testWidgets('renders dropdown icon when no date is set', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      });

      testWidgets('keeps the same height with and without selected date', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildMaterialAppHome(
            Scaffold(
              body: Column(
                children: [
                  AppDatePickerField(
                    placeholder: 'Empty date',
                    onChanged: (_) {},
                  ),
                  AppDatePickerField(
                    placeholder: 'Filled date',
                    value: DateTime(2025, 6, 15),
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final emptyField = find.byWidgetPredicate(
          (w) =>
              w is AppDatePickerField &&
              w.placeholder == 'Empty date' &&
              w.value == null,
        );
        final filledField = find.byWidgetPredicate(
          (w) =>
              w is AppDatePickerField &&
              w.placeholder == 'Filled date' &&
              w.value != null,
        );

        expect(tester.getSize(emptyField), equals(tester.getSize(filledField)));
      });

      testWidgets('clear icon aligns with dropdown icon position', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildMaterialAppHome(
            Scaffold(
              body: Column(
                children: [
                  AppDatePickerField(
                    placeholder: 'Select date',
                    onChanged: (_) {},
                  ),
                  AppDatePickerField(
                    placeholder: 'Select date',
                    value: DateTime(2025, 6, 15),
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final arrowCenter = tester.getCenter(
          find.byIcon(Icons.arrow_drop_down),
        );
        final closeCenter = tester.getCenter(find.byIcon(Icons.close));

        expect((arrowCenter.dx - closeCenter.dx).abs(), lessThan(1));
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('tapping field opens date picker overlay', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(AppDatePickerField));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AppDatePickerOverlay);
      });

      testWidgets('clear button calls onChanged with null', (tester) async {
        DateTime? result = DateTime(2025, 6, 15);
        await tester.pumpWidget(
          buildMaterialAppHome(
            Scaffold(
              body: AppDatePickerField(
                placeholder: 'Select date',
                value: result,
                onChanged: (date) => result = date,
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byIcon(Icons.close));
        await TestHelpers.pumpAndSettle(tester);

        expect(result, isNull);
      });

      testWidgets('opens picker focused on current month when value is null', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(AppDatePickerField));
        await TestHelpers.pumpAndSettle(tester);

        final currentMonthLabel = DateFormat.yMMMM().format(DateTime.now());
        TestHelpers.expectTextOnce(currentMonthLabel);
      });
    });

    group(TestGroups.accessibility, () {
      testWidgets('has button semantics', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final semantics = tester.getSemantics(find.byType(AppDatePickerField));
        expect(semantics.flagsCollection.isButton, isTrue);
      });

      testWidgets('semantics label includes placeholder when no date', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final semantics = tester.getSemantics(find.byType(AppDatePickerField));
        expect(semantics.label, contains('Select date'));
      });

      testWidgets('semantics label includes date when value is set', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(value: DateTime(2025, 6, 15)));
        await TestHelpers.pumpAndSettle(tester);

        final semantics = tester.getSemantics(find.byType(AppDatePickerField));
        expect(semantics.label, contains('June 15, 2025'));
      });
    });
  });
}
