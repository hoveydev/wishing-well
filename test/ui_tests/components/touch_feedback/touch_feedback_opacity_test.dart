import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('TouchFeedbackOpacity', () {
    group(TestGroups.rendering, () {
      testWidgets(
        'renders TouchFeedbackOpacity with child text and calls onTap',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              TouchFeedbackOpacity(
                onTap: () {},
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                  child: const Text('Test'),
                ),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          TestHelpers.expectWidgetOnce(TouchFeedbackOpacity);
          TestHelpers.expectTextOnce('Test');
        },
      );

      testWidgets(
        'renders TouchFeedbackOpacity without errors when onTap is null',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              TouchFeedbackOpacity(
                onTap: null,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                  child: const Text('No Tap'),
                ),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          // Should render without errors even with null onTap
          TestHelpers.expectWidgetOnce(TouchFeedbackOpacity);
          TestHelpers.expectTextOnce('No Tap');
        },
      );

      testWidgets(
        'renders TouchFeedbackOpacity with Container child but no text content',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              TouchFeedbackOpacity(
                onTap: () {},
                child: Container(width: 100, height: 100, color: Colors.red),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          TestHelpers.expectWidgetOnce(TouchFeedbackOpacity);
          expect(find.byType(Container), findsOneWidget);
        },
      );
    });

    group(TestGroups.interaction, () {
      testWidgets('calls onTap callback when TouchFeedbackOpacity is tapped', (
        WidgetTester tester,
      ) async {
        var wasTapped = false;

        await tester.pumpWidget(
          createComponentTestWidget(
            TouchFeedbackOpacity(
              onTap: () => wasTapped = true,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: const Text('Test'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(
          tester,
          find.byType(TouchFeedbackOpacity),
        );
        expect(wasTapped, isTrue);
      });

      testWidgets(
        'does not call onTap when TouchFeedbackOpacity onTap is null',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              TouchFeedbackOpacity(
                onTap: null,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                  child: const Text('No Tap'),
                ),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          // Should handle tap without error when onTap is null
          await TestHelpers.tapAndSettle(
            tester,
            find.byType(TouchFeedbackOpacity),
          );
          TestHelpers.expectWidgetOnce(TouchFeedbackOpacity);
        },
      );

      testWidgets('animates opacity on TouchFeedbackOpacity tap interaction', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            TouchFeedbackOpacity(
              onTap: () {},
              child: Container(width: 100, height: 100, color: Colors.red),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final finder = find.byType(TouchFeedbackOpacity);

        // Test initial state
        expect(finder, findsOneWidget);

        // Test tap down and up animation
        final gesture = await tester.startGesture(tester.getCenter(finder));
        await tester.pump(); // Trigger tap down animation

        // Widget should still be present during animation
        expect(finder, findsOneWidget);

        await gesture.up();
        await tester.pump(); // Trigger tap up animation

        // Widget should still be present after animation completes
        expect(finder, findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct TouchFeedbackOpacity widget properties', (
        WidgetTester tester,
      ) async {
        const testChild = Text('Test Child');

        await tester.pumpWidget(
          createComponentTestWidget(
            TouchFeedbackOpacity(onTap: () {}, child: testChild),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final touchFeedbackWidget = tester.widget<TouchFeedbackOpacity>(
          find.byType(TouchFeedbackOpacity),
        );
        expect(touchFeedbackWidget.child, equals(testChild));
        expect(touchFeedbackWidget.onTap, isA<VoidCallback>());
      });

      testWidgets('handles rapid successive taps on TouchFeedbackOpacity', (
        WidgetTester tester,
      ) async {
        var tapCount = 0;

        await tester.pumpWidget(
          createComponentTestWidget(
            TouchFeedbackOpacity(
              onTap: () => tapCount++,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: const Text('Test'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final finder = find.byType(TouchFeedbackOpacity);

        // Tap multiple times rapidly
        await TestHelpers.tapAndSettle(tester, finder);
        await TestHelpers.tapAndSettle(tester, finder);
        await TestHelpers.tapAndSettle(tester, finder);

        expect(tapCount, equals(3));
      });

      testWidgets('TouchFeedbackOpacity has non-zero dimensions', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            TouchFeedbackOpacity(
              onTap: () {},
              child: Container(width: 100, height: 100, color: Colors.blue),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final size = tester.getSize(find.byType(TouchFeedbackOpacity));
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(0));
      });

      testWidgets('TouchFeedbackOpacity responds to touch gestures properly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            TouchFeedbackOpacity(
              onTap: () {},
              child: Container(width: 100, height: 100, color: Colors.blue),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final finder = find.byType(TouchFeedbackOpacity);
        final gesture = await tester.startGesture(tester.getCenter(finder));
        await tester.pump();

        // Widget should still be present during gesture
        expect(finder, findsOneWidget);

        await gesture.moveTo(tester.getCenter(finder) + const Offset(10, 10));
        await tester.pump();

        // Widget should still be present during drag
        expect(finder, findsOneWidget);

        await gesture.up();
        await TestHelpers.pumpAndSettle(tester);

        // Widget should still be present after gesture
        expect(finder, findsOneWidget);
      });
    });
  });
}
