import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wishing_well/components/wishers/wisher_item.dart';
import 'package:wishing_well/data/models/wisher.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('WisherItem', () {
    // Helper to create test wishers
    Wisher createTestWisher({
      String id = 'test-id',
      String firstName = 'Alice',
      String lastName = 'Johnson',
      String? profilePicture,
    }) => Wisher(
      id: id,
      userId: 'test-user-id',
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    final testWisher = createTestWisher();

    group(TestGroups.rendering, () {
      testWidgets('renders wisher firstName and initial', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(testWisher, EdgeInsets.zero, onTap: () {}),
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
            WisherItem(testWisher, EdgeInsets.zero, onTap: () {}),
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
            WisherItem(testWisher, EdgeInsets.zero, onTap: () {}),
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
        final specialWisher = createTestWisher(
          firstName: 'Alice-123',
          lastName: 'Test',
        );

        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(specialWisher, EdgeInsets.zero, onTap: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Alice-123');
        TestHelpers.expectTextOnce('A');
      });

      testWidgets('handles long names', (WidgetTester tester) async {
        const longName = 'VeryLongNameThatExceedsNormalLengthExpectations';
        final longWisher = createTestWisher(firstName: longName);

        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(longWisher, EdgeInsets.zero, onTap: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce(longName);
        TestHelpers.expectTextOnce('V');
      });

      testWidgets('renders multiple wishers correctly', (
        WidgetTester tester,
      ) async {
        final wisher1 = createTestWisher(id: '1', firstName: 'Alec');
        final wisher2 = createTestWisher(id: '2', firstName: 'Bob');

        await tester.pumpWidget(
          createComponentTestWidget(
            Column(
              children: [
                WisherItem(wisher1, EdgeInsets.zero, onTap: () {}),
                WisherItem(wisher2, EdgeInsets.zero, onTap: () {}),
              ],
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(WisherItem), findsNWidgets(2));
        TestHelpers.expectTextOnce('Alec');
        TestHelpers.expectTextOnce('Bob');
        TestHelpers.expectTextOnce('A');
        TestHelpers.expectTextOnce('B');
      });

      testWidgets('shows profile picture when available', (
        WidgetTester tester,
      ) async {
        final wisherWithPic = createTestWisher(
          profilePicture: 'https://example.com/photo.jpg',
        );

        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(wisherWithPic, EdgeInsets.zero, onTap: () {}),
          ),
        );

        // Pump a few frames to allow the async image loading to start
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        // The profile picture is shown using CachedNetworkImage
        final imageFinder = find.byType(CachedNetworkImage);
        expect(imageFinder, findsOneWidget);

        // Verify the image widget has the correct URL
        final image = tester.widget<CachedNetworkImage>(imageFinder);
        expect(image.imageUrl, 'https://example.com/photo.jpg');
      });

      testWidgets('shows initial when no profile picture', (
        WidgetTester tester,
      ) async {
        final wisherNoPic = createTestWisher();

        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(wisherNoPic, EdgeInsets.zero, onTap: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final circleAvatar = tester.widget<CircleAvatar>(
          find.byType(CircleAvatar),
        );
        expect(circleAvatar.backgroundImage, isNull);
        expect(circleAvatar.child, isNotNull);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('handles tap events', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(testWisher, EdgeInsets.zero, onTap: () {}),
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
            WisherItem(testWisher, EdgeInsets.zero, onTap: () {}),
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
          createComponentTestWidget(
            WisherItem(testWisher, testPadding, onTap: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final wisherItem = tester.widget<WisherItem>(find.byType(WisherItem));
        expect(wisherItem.padding, testPadding);
      });

      testWidgets('uses wisher data correctly', (WidgetTester tester) async {
        final testWisher = createTestWisher(
          firstName: 'TestName',
          lastName: 'TestLast',
        );

        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(testWisher, EdgeInsets.zero, onTap: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final wisherItem = tester.widget<WisherItem>(find.byType(WisherItem));
        expect(wisherItem.wisher.firstName, 'TestName');
        expect(wisherItem.wisher.name, 'TestName TestLast');
        TestHelpers.expectTextOnce('TestName');
        TestHelpers.expectTextOnce('T');
      });

      testWidgets('TouchFeedbackOpacity has correct duration', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(testWisher, EdgeInsets.zero, onTap: () {}),
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
            WisherItem(testWisher, EdgeInsets.zero, onTap: () {}),
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

    group('OnTap Callback', () {
      testWidgets('calls onTap callback when avatar is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        var onTapCalled = false;
        void callback() {
          onTapCalled = true;
        }

        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(testWisher, EdgeInsets.zero, onTap: callback),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Act
        await tester.tap(find.byType(CircleAvatar));
        await tester.pumpAndSettle();

        // Assert
        expect(onTapCalled, isTrue);
      });

      testWidgets('calls onTap with correct context', (
        WidgetTester tester,
      ) async {
        // Arrange
        var callCount = 0;

        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(testWisher, EdgeInsets.zero, onTap: () => callCount++),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Act
        await tester.tap(find.byType(CircleAvatar));
        await tester.pumpAndSettle();

        // Assert
        expect(callCount, 1);
      });

      testWidgets('calls onTap only once per tap', (WidgetTester tester) async {
        // Arrange
        var tapCount = 0;

        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(testWisher, EdgeInsets.zero, onTap: () => tapCount++),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Act
        await tester.tap(find.byType(CircleAvatar));
        await tester.pumpAndSettle();

        // Assert
        expect(tapCount, 1);
      });

      testWidgets('calls onTap for multiple sequential taps', (
        WidgetTester tester,
      ) async {
        // Arrange
        var tapCount = 0;

        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(testWisher, EdgeInsets.zero, onTap: () => tapCount++),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Act - Tap multiple times
        await tester.tap(find.byType(CircleAvatar));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(CircleAvatar));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(CircleAvatar));
        await tester.pumpAndSettle();

        // Assert
        expect(tapCount, 3);
      });

      testWidgets('does not call onTap when passed empty callback (no-op)', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(testWisher, EdgeInsets.zero, onTap: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Act & Assert - Should not throw
        await tester.tap(find.byType(CircleAvatar));
        await tester.pumpAndSettle();

        expect(find.byType(CircleAvatar), findsOneWidget);
      });

      testWidgets('passes different wisher data to same onTap', (
        WidgetTester tester,
      ) async {
        // Arrange
        final List<String> tappedWishers = [];
        final wish1 = createTestWisher(id: 'wish-1');
        final wish2 = createTestWisher(id: 'wish-2', firstName: 'Bob');

        // Act & Assert - Tap first wisher
        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(
              wish1,
              EdgeInsets.zero,
              onTap: () => tappedWishers.add(wish1.id),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(CircleAvatar));
        await tester.pumpAndSettle();

        expect(tappedWishers.length, 1);
        expect(tappedWishers.first, 'wish-1');

        // Act & Assert - Tap second wisher
        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(
              wish2,
              EdgeInsets.zero,
              onTap: () => tappedWishers.add(wish2.id),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(CircleAvatar));
        await tester.pumpAndSettle();

        expect(tappedWishers.length, 2);
        expect(tappedWishers.last, 'wish-2');
      });

      testWidgets('onTap is called even with edge insets', (
        WidgetTester tester,
      ) async {
        // Arrange
        var onTapCalled = false;
        const padding = EdgeInsets.all(16.0);

        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(testWisher, padding, onTap: () => onTapCalled = true),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Act
        await tester.tap(find.byType(CircleAvatar));
        await tester.pumpAndSettle();

        // Assert
        expect(onTapCalled, isTrue);
      });

      testWidgets('onTap callback is accessible via TouchFeedbackOpacity', (
        WidgetTester tester,
      ) async {
        // Arrange
        var callbackExecuted = false;

        await tester.pumpWidget(
          createComponentTestWidget(
            WisherItem(
              testWisher,
              EdgeInsets.zero,
              onTap: () => callbackExecuted = true,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Act - Tap the area with the gesture detector
        await tester.tap(find.byType(CircleAvatar));
        await tester.pumpAndSettle();

        // Assert
        expect(callbackExecuted, isTrue);
      });
    });
  });
}
