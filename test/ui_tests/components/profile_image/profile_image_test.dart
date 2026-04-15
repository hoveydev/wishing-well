import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/profile_image/profile_image.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('ProfileImage', () {
    group(TestGroups.rendering, () {
      testWidgets('renders initials when no image provided', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const ProfileImage(firstName: 'Alice')),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('A'), findsOneWidget);
      });

      testWidgets('renders placeholder initial when firstName is empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const ProfileImage()),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('?'), findsOneWidget);
      });

      testWidgets('renders edit icon overlay when showEditIcon is true', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const ProfileImage(firstName: 'Alice', showEditIcon: true),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.edit), findsOneWidget);
      });

      testWidgets('does not render edit icon overlay by default', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const ProfileImage(firstName: 'Alice')),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.edit), findsNothing);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('hasImage returns false when no image provided', (
        WidgetTester tester,
      ) async {
        const widget = ProfileImage(firstName: 'Alice');
        expect(widget.hasImage, isFalse);
      });

      testWidgets('hasImage returns false when imageUrl is empty', (
        WidgetTester tester,
      ) async {
        const widget = ProfileImage(firstName: 'Alice', imageUrl: '');
        expect(widget.hasImage, isFalse);
      });

      testWidgets('hasImage returns true when imageUrl is set', (
        WidgetTester tester,
      ) async {
        const widget = ProfileImage(
          firstName: 'Alice',
          imageUrl: 'https://example.com/image.jpg',
        );
        expect(widget.hasImage, isTrue);
      });

      testWidgets('calls onTap when tapped', (WidgetTester tester) async {
        var tapped = false;
        await tester.pumpWidget(
          createComponentTestWidget(
            ProfileImage(firstName: 'Alice', onTap: () => tapped = true),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(ProfileImage));
        await tester.pumpAndSettle();

        expect(tapped, isTrue);
      });
    });
  });

  group('ProfileAvatar', () {
    group(TestGroups.rendering, () {
      testWidgets('renders initial when no imageUrl', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const ProfileAvatar(firstName: 'Bob', lastName: 'Smith'),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('B'), findsOneWidget);
      });

      testWidgets('shows ? when firstName is empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const ProfileAvatar()),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('?'), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      test('hasImage is false when no imageUrl', () {
        const avatar = ProfileAvatar(firstName: 'Alice');
        expect(avatar.hasImage, isFalse);
      });

      test('hasImage is true when imageUrl is provided', () {
        const avatar = ProfileAvatar(
          firstName: 'Alice',
          imageUrl: 'https://example.com/img.png',
        );
        expect(avatar.hasImage, isTrue);
      });

      test('name returns combined firstName and lastName', () {
        const avatar = ProfileAvatar(firstName: 'Alice', lastName: 'Smith');
        expect(avatar.name, 'Alice Smith');
      });

      test('initial returns uppercase first letter', () {
        const avatar = ProfileAvatar(firstName: 'alice');
        expect(avatar.initial, 'A');
      });
    });
  });

  group('ProfileImageWithLabel', () {
    group(TestGroups.rendering, () {
      testWidgets('renders name label', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const ProfileImageWithLabel(name: 'Alice Smith'),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Alice Smith'), findsOneWidget);
      });

      testWidgets('renders ProfileImage', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const ProfileImageWithLabel(name: 'Alice Smith'),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(ProfileImage), findsOneWidget);
      });

      testWidgets('renders ProfileImageWithLabel with imageUrl', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const ProfileImageWithLabel(
              name: 'Alice Smith',
              imageUrl: 'https://example.com/img.png',
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Alice Smith'), findsOneWidget);
        expect(find.byType(ProfileImage), findsOneWidget);
      });
    });
  });

  group('ProfileImage additional coverage', () {
    group(TestGroups.rendering, () {
      testWidgets('renders with imageUrl (network path)', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const ProfileImage(
              firstName: 'Alice',
              imageUrl: 'https://example.com/image.jpg',
            ),
          ),
        );
        // Don't settle — CachedNetworkImage shows placeholder immediately
        await tester.pump();

        expect(find.byType(ProfileImage), findsOneWidget);
      });

      testWidgets('hasImage true for localImageFile', (
        WidgetTester tester,
      ) async {
        final tempFile = File('${Directory.systemTemp.path}/test_img2.png');

        final widget = ProfileImage(
          firstName: 'Alice',
          localImageFile: tempFile,
        );
        expect(widget.hasImage, isTrue);
      });
    });
  });

  group('ProfileAvatar additional coverage', () {
    group(TestGroups.rendering, () {
      testWidgets('renders with imageUrl uses CachedNetworkImage', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const ProfileAvatar(
              firstName: 'Alice',
              imageUrl: 'https://example.com/img.png',
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(ProfileAvatar), findsOneWidget);
      });

      testWidgets('hasImage is false for empty imageUrl string', (
        WidgetTester tester,
      ) async {
        const avatar = ProfileAvatar(firstName: 'Alice', imageUrl: '');
        expect(avatar.hasImage, isFalse);
      });

      testWidgets('name trims correctly with empty lastName', (
        WidgetTester tester,
      ) async {
        const avatar = ProfileAvatar(firstName: 'Alice');
        expect(avatar.name, 'Alice');
      });
    });
  });
}
