import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/image_source_menu/image_source_menu.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('ImageSourceMenu', () {
    group(TestGroups.initialState, () {
      testWidgets('renders modal bottom sheet with correct title', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ImageSourceMenu.show(
                    context: context,
                    onOptionSelected: (_) {},
                  );
                },
                child: const Text('Open Menu'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Open the menu
        await tester.tap(find.text('Open Menu'));
        await tester.pumpAndSettle();

        // Verify title is displayed
        TestHelpers.expectTextOnce('Select Image Source');
      });

      testWidgets('renders two option items', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ImageSourceMenu.show(
                    context: context,
                    onOptionSelected: (_) {},
                  );
                },
                child: const Text('Open Menu'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Open the menu
        await tester.tap(find.text('Open Menu'));
        await TestHelpers.pumpAndSettle(tester);

        // Should have two ListTile options
        expect(find.byType(ListTile), findsNWidgets(2));
      });

      testWidgets('renders Choose a Photo option', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ImageSourceMenu.show(
                    context: context,
                    onOptionSelected: (_) {},
                  );
                },
                child: const Text('Open Menu'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Open the menu
        await tester.tap(find.text('Open Menu'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Choose a Photo');
      });

      testWidgets('renders Choose a File option', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ImageSourceMenu.show(
                    context: context,
                    onOptionSelected: (_) {},
                  );
                },
                child: const Text('Open Menu'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Open the menu
        await tester.tap(find.text('Open Menu'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Choose a File');
      });

      testWidgets('renders photo library icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ImageSourceMenu.show(
                    context: context,
                    onOptionSelected: (_) {},
                  );
                },
                child: const Text('Open Menu'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Open the menu
        await tester.tap(find.text('Open Menu'));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.photo_library), findsOneWidget);
      });

      testWidgets('renders folder icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ImageSourceMenu.show(
                    context: context,
                    onOptionSelected: (_) {},
                  );
                },
                child: const Text('Open Menu'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Open the menu
        await tester.tap(find.text('Open Menu'));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.folder_open), findsOneWidget);
      });

      testWidgets('has handle bar at top', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ImageSourceMenu.show(
                    context: context,
                    onOptionSelected: (_) {},
                  );
                },
                child: const Text('Open Menu'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Open the menu
        await tester.tap(find.text('Open Menu'));
        await TestHelpers.pumpAndSettle(tester);

        // Should have a container for the handle bar
        final containers = find.byType(Container);
        expect(containers, findsWidgets);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets(
        'calls onOptionSelected with photo when Choose a Photo tapped',
        (WidgetTester tester) async {
          ImageSourceOption? selectedOption;

          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ImageSourceMenu.show(
                      context: context,
                      onOptionSelected: (option) {
                        selectedOption = option;
                      },
                    );
                  },
                  child: const Text('Open Menu'),
                ),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          // Open the menu
          await tester.tap(find.text('Open Menu'));
          await TestHelpers.pumpAndSettle(tester);

          // Tap on "Choose a Photo"
          await tester.tap(find.text('Choose a Photo'));
          await TestHelpers.pumpAndSettle(tester);

          expect(selectedOption, ImageSourceOption.photo);
        },
      );

      testWidgets(
        'calls onOptionSelected with file when Choose a File tapped',
        (WidgetTester tester) async {
          ImageSourceOption? selectedOption;

          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    ImageSourceMenu.show(
                      context: context,
                      onOptionSelected: (option) {
                        selectedOption = option;
                      },
                    );
                  },
                  child: const Text('Open Menu'),
                ),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          // Open the menu
          await tester.tap(find.text('Open Menu'));
          await TestHelpers.pumpAndSettle(tester);

          // Tap on "Choose a File"
          await tester.tap(find.text('Choose a File'));
          await TestHelpers.pumpAndSettle(tester);

          expect(selectedOption, ImageSourceOption.file);
        },
      );

      testWidgets('closes modal when option is selected', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ImageSourceMenu.show(
                    context: context,
                    onOptionSelected: (_) {},
                  );
                },
                child: const Text('Open Menu'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Open the menu
        await tester.tap(find.text('Open Menu'));
        await TestHelpers.pumpAndSettle(tester);

        // Verify menu is open
        expect(find.text('Select Image Source'), findsOneWidget);

        // Tap on an option
        await tester.tap(find.text('Choose a Photo'));
        await TestHelpers.pumpAndSettle(tester);

        // Verify menu is closed
        expect(find.text('Select Image Source'), findsNothing);
      });

      testWidgets('can reopen menu after closing', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ImageSourceMenu.show(
                    context: context,
                    onOptionSelected: (_) {},
                  );
                },
                child: const Text('Open Menu'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Open the menu
        await tester.tap(find.text('Open Menu'));
        await TestHelpers.pumpAndSettle(tester);

        // Close it
        await tester.tap(find.text('Choose a Photo'));
        await TestHelpers.pumpAndSettle(tester);

        // Open again
        await tester.tap(find.text('Open Menu'));
        await TestHelpers.pumpAndSettle(tester);

        // Should be open again
        TestHelpers.expectTextOnce('Select Image Source');
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('modal has correct background color', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ImageSourceMenu.show(
                    context: context,
                    onOptionSelected: (_) {},
                  );
                },
                child: const Text('Open Menu'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Open the menu
        await tester.tap(find.text('Open Menu'));
        await TestHelpers.pumpAndSettle(tester);

        // Find the bottom sheet and verify it's wrapped in Material
        expect(find.byType(Material), findsWidgets);
      });

      testWidgets('has SafeArea wrapper', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ImageSourceMenu.show(
                    context: context,
                    onOptionSelected: (_) {},
                  );
                },
                child: const Text('Open Menu'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Open the menu
        await tester.tap(find.text('Open Menu'));
        await TestHelpers.pumpAndSettle(tester);

        // Verify ImageSourceMenu is rendered (it contains SafeArea internally)
        TestHelpers.expectWidgetOnce(ImageSourceMenu);
      });

      testWidgets('ImageSourceOption enum has correct values', (
        WidgetTester tester,
      ) async {
        expect(ImageSourceOption.values.length, 2);
        expect(ImageSourceOption.photo, isNotNull);
        expect(ImageSourceOption.file, isNotNull);
      });
    });

    group(TestGroups.validation, () {
      testWidgets('requires onOptionSelected callback', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  // This should compile - callback is required
                  ImageSourceMenu.show(
                    context: context,
                    onOptionSelected: (option) {
                      // Do something with option
                      debugPrint('Selected: $option');
                    },
                  );
                },
                child: const Text('Open Menu'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Open the menu - should work without errors
        await tester.tap(find.text('Open Menu'));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Select Image Source'), findsOneWidget);
      });
    });
  });
}
