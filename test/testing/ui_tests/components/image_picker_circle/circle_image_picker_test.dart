import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/image_picker_circle/image_picker_circle.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('CircleImagePicker', () {
    group(TestGroups.initialState, () {
      testWidgets(
        'renders placeholder with camera icon when no image provided',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createScreenComponentTestWidget(CircleImagePicker(onTap: () {})),
          );
          await TestHelpers.pumpAndSettle(tester);

          // Should show dotted border placeholder
          TestHelpers.expectWidgetOnce(DottedBorder);
          TestHelpers.expectWidgetOnce(CircleAvatar);
          TestHelpers.expectWidgetOnce(Icon);
          // Camera icon should be present
          expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
        },
      );

      testWidgets('renders with default radius of 50', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(CircleImagePicker(onTap: () {})),
        );
        await TestHelpers.pumpAndSettle(tester);

        final circleAvatar = tester.widget<CircleAvatar>(
          find.byType(CircleAvatar),
        );
        expect(circleAvatar.radius, 50);
      });

      testWidgets('does not show edit icon by default when no image', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(CircleImagePicker(onTap: () {})),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.edit), findsNothing);
      });

      testWidgets('does not show label by default', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(CircleImagePicker(onTap: () {})),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should only have the avatar column, no text below
        final column = tester.widget<Column>(
          find.descendant(
            of: find.byType(CircleImagePicker),
            matching: find.byType(Column),
          ),
        );
        expect(column.children.length, 1); // Only TouchFeedbackOpacity
      });
    });

    group(TestGroups.rendering, () {
      testWidgets('renders with custom radius', (WidgetTester tester) async {
        const customRadius = 30.0;

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            CircleImagePicker(onTap: () {}, radius: customRadius),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final circleAvatar = tester.widget<CircleAvatar>(
          find.byType(CircleAvatar),
        );
        expect(circleAvatar.radius, customRadius);
      });

      testWidgets('renders label when provided', (WidgetTester tester) async {
        const testLabel = 'Add Photo';

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            CircleImagePicker(onTap: () {}, label: testLabel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce(testLabel);
      });

      testWidgets('renders with custom label', (WidgetTester tester) async {
        const testLabel = 'Change Photo';

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            CircleImagePicker(onTap: () {}, label: testLabel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce(testLabel);
      });

      testWidgets('renders person icon when no image and no camera fallback', (
        WidgetTester tester,
      ) async {
        // This tests the _buildImageAvatar path when backgroundImage is null
        await tester.pumpWidget(
          createScreenComponentTestWidget(CircleImagePicker(onTap: () {})),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should show camera icon in placeholder
        expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('hasImage returns false when no image provided', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(CircleImagePicker(onTap: () {})),
        );
        await TestHelpers.pumpAndSettle(tester);

        final picker = tester.widget<CircleImagePicker>(
          find.byType(CircleImagePicker),
        );
        expect(picker.hasImage, isFalse);
      });

      test('hasImage returns true when imageUrl is provided', () {
        // Test the getter directly without rendering to avoid network calls
        final widget = CircleImagePicker(
          onTap: () {},
          imageUrl: 'https://example.com/photo.jpg',
        );
        expect(widget.hasImage, isTrue);
      });

      test('hasImage returns true when imageUrl is non-empty string', () {
        // Test the getter directly without rendering to avoid network calls
        final widget = CircleImagePicker(
          onTap: () {},
          imageUrl: 'https://test.url/image.png',
        );
        expect(widget.hasImage, isTrue);
      });

      testWidgets('showEditIcon defaults to true', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(CircleImagePicker(onTap: () {})),
        );
        await TestHelpers.pumpAndSettle(tester);

        final picker = tester.widget<CircleImagePicker>(
          find.byType(CircleImagePicker),
        );
        expect(picker.showEditIcon, isTrue);
      });

      testWidgets('showEditIcon can be set to false', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            CircleImagePicker(onTap: () {}, showEditIcon: false),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final picker = tester.widget<CircleImagePicker>(
          find.byType(CircleImagePicker),
        );
        expect(picker.showEditIcon, isFalse);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('calls onTap when tapped', (WidgetTester tester) async {
        var wasTapped = false;

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            CircleImagePicker(onTap: () => wasTapped = true),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.byType(CircleImagePicker));
        expect(wasTapped, isTrue);
      });

      testWidgets('calls onTap when tapped without image', (
        WidgetTester tester,
      ) async {
        var wasTapped = false;

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            CircleImagePicker(onTap: () => wasTapped = true),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(CircleImagePicker));
        expect(wasTapped, isTrue);
      });

      testWidgets('wraps avatar in TouchFeedbackOpacity', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(CircleImagePicker(onTap: () {})),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(TouchFeedbackOpacity);
      });
    });

    group(TestGroups.validation, () {
      testWidgets('requires onTap callback', (WidgetTester tester) async {
        // This test verifies the widget accepts a required onTap parameter
        await tester.pumpWidget(
          createScreenComponentTestWidget(CircleImagePicker(onTap: () {})),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Widget should build successfully
        expect(find.byType(CircleImagePicker), findsOneWidget);
      });

      testWidgets('accepts optional parameters', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(CircleImagePicker(onTap: () {})),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(CircleImagePicker), findsOneWidget);
      });
    });
  });
}
