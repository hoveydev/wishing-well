import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:wishing_well/components/date_picker/app_date_picker_overlay.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  final jan2025 = DateTime(2025);
  final dec2025 = DateTime(2025, 12, 31);

  Widget buildTestWidget({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) => buildMaterialAppHome(
    Scaffold(
      body: AppDatePickerOverlay(
        initialDate: initialDate,
        firstDate: firstDate ?? jan2025,
        lastDate: lastDate ?? dec2025,
      ),
    ),
  );

  group('AppDatePickerOverlay', () {
    group(TestGroups.rendering, () {
      testWidgets('renders title "Select a Date"', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Select a Date');
      });

      testWidgets('renders Cancel button', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Cancel');
      });

      testWidgets('renders Confirm button', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Confirm');
      });

      testWidgets('renders current month/year label', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(initialDate: DateTime(2025, 3, 15)),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('March 2025');
      });

      testWidgets('renders 7 day-of-week abbreviations', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        // 7 day header cells, with duplicated initials for Sunday/Saturday
        // and Tuesday/Thursday.
        const dayHeaderCounts = {'S': 2, 'M': 1, 'T': 2, 'W': 1, 'F': 1};

        dayHeaderCounts.forEach((day, expectedCount) {
          expect(find.text(day), findsNWidgets(expectedCount));
        });
      });

      testWidgets('renders day numbers for the displayed month', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(initialDate: DateTime(2025, 3, 15)),
        );
        await TestHelpers.pumpAndSettle(tester);

        // March has 31 days — spot check a few
        expect(find.text('1'), findsOneWidget);
        expect(find.text('15'), findsOneWidget);
        expect(find.text('31'), findsOneWidget);
      });

      testWidgets('renders prev and next navigation icons', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(initialDate: DateTime(2025, 6)),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.chevron_left), findsOneWidget);
        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      });
    });

    group(TestGroups.initialState, () {
      testWidgets('shows initialDate month when provided', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(initialDate: DateTime(2025, 7, 20)),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('July 2025');
      });

      testWidgets('shows firstDate month when no initialDate', (tester) async {
        await tester.pumpWidget(buildTestWidget(firstDate: DateTime(2025, 4)));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('April 2025');
      });

      testWidgets('asserts when initialDate is before firstDate', (
        tester,
      ) async {
        // initialDate before firstDate — should fail fast with assertion
        expect(
          () => AppDatePickerOverlay(
            firstDate: DateTime(2025),
            lastDate: DateTime(2025, 12, 31),
            initialDate: DateTime(2020), // before firstDate
          ),
          throwsAssertionError,
        );
      });

      testWidgets('normalizes initialDate with time component', (tester) async {
        // initialDate at midnight-plus time should still be accepted
        await tester.pumpWidget(
          buildTestWidget(initialDate: DateTime(2025, 3, 15, 14, 30)),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('March 2025');
      });
    });

    group('Month Navigation', () {
      testWidgets('tapping next advances the displayed month', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(initialDate: DateTime(2025, 3)),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byIcon(Icons.chevron_right));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('April 2025');
      });

      testWidgets('tapping prev retreats the displayed month', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(initialDate: DateTime(2025, 3)),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byIcon(Icons.chevron_left));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('February 2025');
      });

      testWidgets('prev navigation is a no-op at firstDate month', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        // Already at January — prev tap should not change the month
        await tester.tap(find.byIcon(Icons.chevron_left), warnIfMissed: false);
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('January 2025');
      });

      testWidgets('next navigation is a no-op at lastDate month', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(initialDate: DateTime(2025, 12)),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Already at December — next tap should not change the month
        await tester.tap(find.byIcon(Icons.chevron_right), warnIfMissed: false);
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('December 2025');
      });
    });

    group('Date Selection', () {
      testWidgets('tapping a day selects it', (tester) async {
        // Use a fixed past month so today is never in the grid, avoiding
        // ambiguous "15" matches
        await tester.pumpWidget(
          buildTestWidget(
            firstDate: DateTime(2020, 3),
            lastDate: DateTime(2020, 3, 31),
            initialDate: DateTime(2020, 3),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('15'));
        await TestHelpers.pumpAndSettle(tester);

        // Verify by widget predicate – selected cell should have 'selected'
        final march15Label = DateFormat.yMMMMd().format(DateTime(2020, 3, 15));
        final semanticsWidget = tester.widget<Semantics>(
          find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == march15Label,
          ),
        );
        expect(semanticsWidget.properties.selected, isTrue);
      });

      testWidgets('out-of-range days cannot be selected', (tester) async {
        // Set firstDate to the 15th so days 1-14 are out of range
        await tester.pumpWidget(
          buildTestWidget(
            firstDate: DateTime(2020, 3, 15),
            lastDate: DateTime(2020, 3, 31),
            initialDate: DateTime(2020, 3, 15),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Tap day 1 (out of range)
        await tester.tap(find.text('1'), warnIfMissed: false);
        await TestHelpers.pumpAndSettle(tester);

        // The month label should still be showing (we haven't been dismissed)
        TestHelpers.expectTextOnce('March 2020');
        // Day 15 should still be selected
        expect(
          find.bySemanticsLabel(RegExp(r'March 15, 2020')),
          findsOneWidget,
        );
      });
    });

    group('Confirm / Cancel', () {
      testWidgets('Confirm pops with selected date', (tester) async {
        DateTime? returned;
        await tester.pumpWidget(
          buildMaterialAppHome(
            Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    returned = await AppDatePickerOverlay.show(
                      context: context,
                      initialDate: DateTime(2025, 3, 15),
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2025, 12, 31),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Confirm'));
        await TestHelpers.pumpAndSettle(tester);

        expect(returned, equals(DateTime(2025, 3, 15)));
      });

      testWidgets('Confirm pops with null when no date selected', (
        tester,
      ) async {
        DateTime? returned = DateTime(2000);
        await tester.pumpWidget(
          buildMaterialAppHome(
            Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    returned = await AppDatePickerOverlay.show(
                      context: context,
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2025, 12, 31),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Confirm'));
        await TestHelpers.pumpAndSettle(tester);

        expect(returned, isNull);
      });

      testWidgets('Cancel pops with null', (tester) async {
        DateTime? returned = DateTime(2000);
        await tester.pumpWidget(
          buildMaterialAppHome(
            Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    returned = await AppDatePickerOverlay.show(
                      context: context,
                      initialDate: DateTime(2025, 3, 15),
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2025, 12, 31),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Cancel'));
        await TestHelpers.pumpAndSettle(tester);

        expect(returned, isNull);
      });
    });

    group(TestGroups.accessibility, () {
      testWidgets('in-range day cells have button semantics', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            firstDate: DateTime(2025, 3),
            lastDate: DateTime(2025, 3, 31),
            initialDate: DateTime(2025, 3),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final march10Label = DateFormat.yMMMMd().format(DateTime(2025, 3, 10));
        final semanticsWidget = tester.widget<Semantics>(
          find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == march10Label,
          ),
        );
        expect(semanticsWidget.properties.button, isTrue);
        expect(semanticsWidget.properties.enabled, isTrue);
      });

      testWidgets('out-of-range day cells do not have button semantics', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            firstDate: DateTime(2025, 3, 16),
            lastDate: DateTime(2025, 3, 31),
            initialDate: DateTime(2025, 3, 16),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final march1Label = DateFormat.yMMMMd().format(DateTime(2025, 3));
        final semanticsWidget = tester.widget<Semantics>(
          find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == march1Label,
          ),
        );
        expect(semanticsWidget.properties.button, isFalse);
      });

      testWidgets('selected day cell has selected semantics', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            firstDate: DateTime(2025, 3),
            lastDate: DateTime(2025, 3, 31),
            initialDate: DateTime(2025, 3, 15),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final march15Label = DateFormat.yMMMMd().format(DateTime(2025, 3, 15));
        final semanticsWidget = tester.widget<Semantics>(
          find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == march15Label,
          ),
        );
        expect(semanticsWidget.properties.selected, isTrue);
      });
    });

    group('Month Label Format', () {
      testWidgets('displays correct format for month/year', (tester) async {
        final monthLabel = DateFormat.yMMMM().format(DateTime(2025, 11));
        await tester.pumpWidget(
          buildTestWidget(initialDate: DateTime(2025, 11)),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce(monthLabel);
      });
    });
  });
}
