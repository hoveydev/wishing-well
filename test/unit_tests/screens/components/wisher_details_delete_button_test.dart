import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:wishing_well/features/wisher_details/components/wisher_details_delete_button.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/theme/app_colors.dart';

void main() {
  group('WisherDetailsDeleteButton', () {
    group(TestGroups.rendering, () {
      testWidgets('renders delete button with correct label', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          buildMaterialAppHome(WisherDetailsDeleteButton(onPressed: () {})),
        );
        await TestHelpers.pumpAndSettle(tester);
        expect(find.text('Delete Wisher'), findsOneWidget);
      });

      testWidgets('renders with theme error as background color', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          buildMaterialAppHome(WisherDetailsDeleteButton(onPressed: () {})),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find the AnimatedContainer produced by ButtonFeedbackStyle's
        // backgroundBuilder and inspect its BoxDecoration color.
        final animatedFinder = find.descendant(
          of: find.byType(TextButton),
          matching: find.byType(AnimatedContainer),
        );
        expect(animatedFinder, findsOneWidget);

        final animated = tester.widget<AnimatedContainer>(animatedFinder);
        final decoration = animated.decoration as BoxDecoration;

        // Assert decoration color matches app error color.
        expect(decoration.color, isNotNull);
        final actual = decoration.color!;
        expect(actual, AppColors.error);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
        var called = false;
        await tester.pumpWidget(
          buildMaterialAppHome(
            WisherDetailsDeleteButton(
              onPressed: () {
                called = true;
              },
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);
        await tester.tap(find.text('Delete Wisher'));
        await tester.pump();
        expect(called, isTrue);
      });
    });
  });
}
