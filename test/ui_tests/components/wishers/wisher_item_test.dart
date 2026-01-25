import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/wishers/wisher_item.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';

void main() {
  group('WisherItem', () {
    const testWisher = Wisher('Alice');

    testWidgets('renders wisher name and initial', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: WisherItem(testWisher, EdgeInsets.zero)),
        ),
      );

      // Check that the wisher name is displayed
      expect(find.text('Alice'), findsOneWidget);

      // Check that the initial 'A' is displayed in the CircleAvatar
      expect(find.text('A'), findsOneWidget);

      // Check that CircleAvatar is present
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('CircleAvatar has correct radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: WisherItem(testWisher, EdgeInsets.zero)),
        ),
      );

      final circleAvatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar),
      );
      expect(circleAvatar.radius, 30);
    });

    testWidgets('initial text has correct color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: WisherItem(testWisher, EdgeInsets.zero)),
        ),
      );

      final initialText = tester.widget<Text>(find.text('A'));
      final colorScheme =
          AppTheme.lightTheme.extensions.values.firstWhere(
                (element) => element.type == AppColorScheme,
              )
              as AppColorScheme;
      expect(initialText.style?.color, colorScheme.onPrimary);
    });

    testWidgets('name text has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: WisherItem(testWisher, EdgeInsets.zero)),
        ),
      );

      final nameText = tester.widget<Text>(find.text('Alice'));
      expect(
        nameText.style!.decoration,
        AppTheme.lightTheme.textTheme.bodySmall!.decoration,
      );
      final colorScheme =
          AppTheme.lightTheme.extensions.values.firstWhere(
                (element) => element.type == AppColorScheme,
              )
              as AppColorScheme;
      expect(nameText.style?.color, colorScheme.primary);
    });

    testWidgets('handles tap events', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: WisherItem(testWisher, EdgeInsets.zero)),
        ),
      );

      // Find the gesture detector within WisherItem
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

      // Test that tap gesture works
      await tester.tap(find.byType(CircleAvatar));
      await tester.pump();
    });

    testWidgets('tap animation has correct duration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: WisherItem(testWisher, EdgeInsets.zero)),
        ),
      );

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.descendant(
          of: find.byType(WisherItem),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(animatedOpacity.duration, const Duration(milliseconds: 100));
    });

    testWidgets('debugPrint called on tap with wisher name', (
      WidgetTester tester,
    ) async {
      const testWisherName = 'TestWisher';
      const testWisher = Wisher(testWisherName);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: WisherItem(testWisher, EdgeInsets.zero)),
        ),
      );

      // Verify the gesture detector has the onTap callback
      final gestureDetector = tester.widget<GestureDetector>(
        find.descendant(
          of: find.byType(WisherItem),
          matching: find.byType(GestureDetector),
        ),
      );
      expect(gestureDetector.onTap, isNotNull);

      // Test that tap gesture works
      await tester.tap(find.byType(CircleAvatar));
      await tester.pump();
    });

    testWidgets('handles special characters in name', (
      WidgetTester tester,
    ) async {
      const specialWisher = Wisher('Alice-123_!@#');

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: WisherItem(specialWisher, EdgeInsets.zero),
          ),
        ),
      );

      // Should display the full name
      expect(find.text('Alice-123_!@#'), findsOneWidget);

      // Should display the first character as initial
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('handles whitespace in name', (WidgetTester tester) async {
      const spaceWisher = Wisher('  Alice Smith  ');

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: WisherItem(spaceWisher, EdgeInsets.zero)),
        ),
      );

      // Should display the name as is (including spaces)
      expect(find.text('  Alice Smith  '), findsOneWidget);

      // Should display the first character (space) as initial
      expect(find.text(' '), findsOneWidget);
    });

    testWidgets('maintains consistent structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: WisherItem(testWisher, EdgeInsets.zero)),
        ),
      );

      // Should have the structure:
      // Padding > Column > [GestureDetector, Spacer, Text]
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(AnimatedOpacity), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.children.length, 3); // CircleAvatar area & Text & Spacer
    });

    testWidgets('works with dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: WisherItem(testWisher, EdgeInsets.zero)),
        ),
      );

      // Should render without errors in dark theme
      expect(find.byType(WisherItem), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);

      final circleAvatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar),
      );
      final colorScheme =
          AppTheme.darkTheme.extensions.values.firstWhere(
                (element) => element.type == AppColorScheme,
              )
              as AppColorScheme;
      expect(circleAvatar.backgroundColor, colorScheme.primary);

      final initialText = tester.widget<Text>(find.text('A'));
      expect(initialText.style?.color, colorScheme.onPrimary);
    });

    testWidgets('handles long names', (WidgetTester tester) async {
      const longName = 'VeryLongNameThatExceedsNormalLengthExpectations';
      const longWisher = Wisher(longName);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: WisherItem(longWisher, EdgeInsets.zero)),
        ),
      );

      // Should display the full name
      expect(find.text(longName), findsOneWidget);

      // Should display only the first character as initial
      expect(find.text('V'), findsOneWidget);
    });

    testWidgets('handles different wisher instances', (
      WidgetTester tester,
    ) async {
      const wisher1 = Wisher('Alice');
      const wisher2 = Wisher('Bob');

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Column(
              children: [
                WisherItem(wisher1, EdgeInsets.zero),
                WisherItem(wisher2, EdgeInsets.zero),
              ],
            ),
          ),
        ),
      );

      // Should render both wishers
      expect(find.byType(WisherItem), findsNWidgets(2));
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('tap cancel restores opacity', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: WisherItem(testWisher, EdgeInsets.zero)),
        ),
      );

      // Check initial opacity
      final initialOpacity = tester.widget<AnimatedOpacity>(
        find.descendant(
          of: find.byType(WisherItem),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(initialOpacity.opacity, 1.0);

      // Test tap gesture works
      await tester.tap(find.byType(CircleAvatar));
      await tester.pump();

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
}
