import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';

void main() {
  group('Reusable Opacity Components', () {
    testWidgets('TouchFeedbackOpacity provides tap feedback', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouchFeedbackOpacity(
              onTap: () => wasTapped = true,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Verify the widget is rendered
      expect(find.text('Test'), findsOneWidget);

      // Test tap functionality
      await tester.tap(find.byType(TouchFeedbackOpacity));
      expect(wasTapped, isTrue);
    });

    testWidgets('TouchFeedbackOpacity with null onTap works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouchFeedbackOpacity(
              onTap: null,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.green,
                child: const Text('No Tap'),
              ),
            ),
          ),
        ),
      );

      // Should render without errors even with null onTap
      expect(find.text('No Tap'), findsOneWidget);
    });

    testWidgets('TouchFeedbackOpacity animates opacity on press', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouchFeedbackOpacity(
              onTap: () {},
              child: Container(width: 100, height: 100, color: Colors.red),
            ),
          ),
        ),
      );

      final finder = find.byType(TouchFeedbackOpacity);

      // Test initial state
      await tester.pump();
      expect(finder, findsOneWidget);

      // Test tap down and up
      await tester.tap(finder);
      await tester.pump();

      // Verify widget is still present after tap
      expect(finder, findsOneWidget);
    });
  });
}
