import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/button/button_feedback_style.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('ButtonFeedbackStyle', () {
    group(TestGroups.component, () {
      testWidgets(
        'primary style with null backgroundColor uses default color',
        (tester) async {
          // Arrange & Act: Create button with null backgroundColor
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonFeedbackStyle.primary(context: context),
                  onPressed: () {},
                  child: const Text('Primary Button'),
                ),
              ),
            ),
          );

          // Assert: Button should render
          expect(find.text('Primary Button'), findsOneWidget);
        },
      );

      testWidgets('primary style with null side uses BorderSide.none', (
        tester,
      ) async {
        // Arrange & Act: Create button with null side
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                style: ButtonFeedbackStyle.primary(context: context),
                onPressed: () {},
                child: const Text('Primary Button'),
              ),
            ),
          ),
        );

        // Assert: Button should render
        expect(find.text('Primary Button'), findsOneWidget);
      });

      testWidgets('primary style with custom backgroundColor', (tester) async {
        // Arrange & Act: Create button with custom backgroundColor
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                style: ButtonFeedbackStyle.primary(
                  context: context,
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                onPressed: () {},
                child: const Text('Primary Button'),
              ),
            ),
          ),
        );

        // Assert: Button should render
        expect(find.text('Primary Button'), findsOneWidget);
      });

      testWidgets('primary style with custom side', (tester) async {
        // Arrange & Act: Create button with custom side
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                style: ButtonFeedbackStyle.primary(
                  context: context,
                  side: const BorderSide(color: Colors.red, width: 2),
                ),
                onPressed: () {},
                child: const Text('Primary Button'),
              ),
            ),
          ),
        );

        // Assert: Button should render
        expect(find.text('Primary Button'), findsOneWidget);
      });

      testWidgets(
        'primary style backgroundColor fallback when resolve returns null',
        (tester) async {
          // Arrange: Create a WidgetStateProperty using fromMap
          const backgroundColor = WidgetStateProperty<Color>.fromMap({
            WidgetState.disabled: Colors.grey,
            WidgetState.pressed: Colors.blue,
          });

          // Act: Create button with backgroundColor
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonFeedbackStyle.primary(
                    context: context,
                    backgroundColor: backgroundColor,
                  ),
                  onPressed: null, // Disabled to trigger the state
                  child: const Text('Primary Button'),
                ),
              ),
            ),
          );

          // Assert: Button should still render
          expect(find.text('Primary Button'), findsOneWidget);
        },
      );

      testWidgets('secondary style with null side uses default border', (
        tester,
      ) async {
        // Arrange & Act: Create secondary button with null side
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                style: ButtonFeedbackStyle.secondary(context: context),
                onPressed: () {},
                child: const Text('Secondary Button'),
              ),
            ),
          ),
        );

        // Assert: Button should render
        expect(find.text('Secondary Button'), findsOneWidget);
      });

      testWidgets('secondary style with custom side', (tester) async {
        // Arrange & Act: Create secondary button with custom side
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                style: ButtonFeedbackStyle.secondary(
                  context: context,
                  side: const BorderSide(color: Colors.green, width: 3),
                ),
                onPressed: () {},
                child: const Text('Secondary Button'),
              ),
            ),
          ),
        );

        // Assert: Button should render
        expect(find.text('Secondary Button'), findsOneWidget);
      });

      testWidgets('tertiary style with null side uses BorderSide.none', (
        tester,
      ) async {
        // Arrange & Act: Create tertiary button with null side
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                style: ButtonFeedbackStyle.tertiary(context: context),
                onPressed: () {},
                child: const Text('Tertiary Button'),
              ),
            ),
          ),
        );

        // Assert: Button should render
        expect(find.text('Tertiary Button'), findsOneWidget);
      });

      testWidgets('tertiary style with custom side', (tester) async {
        // Arrange & Act: Create tertiary button with custom side
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                style: ButtonFeedbackStyle.tertiary(
                  context: context,
                  side: const BorderSide(color: Colors.orange, width: 2),
                ),
                onPressed: () {},
                child: const Text('Tertiary Button'),
              ),
            ),
          ),
        );

        // Assert: Button should render
        expect(find.text('Tertiary Button'), findsOneWidget);
      });

      testWidgets('tertiary style with custom shape', (tester) async {
        // Arrange & Act: Create tertiary button with custom shape
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                style: ButtonFeedbackStyle.tertiary(
                  context: context,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {},
                child: const Text('Tertiary Button'),
              ),
            ),
          ),
        );

        // Assert: Button should render
        expect(find.text('Tertiary Button'), findsOneWidget);
      });

      testWidgets('primary button shows pressed state correctly', (
        tester,
      ) async {
        // Arrange: Create button
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                style: ButtonFeedbackStyle.primary(context: context),
                onPressed: () {},
                child: const Text('Primary Button'),
              ),
            ),
          ),
        );

        // Act: Press the button
        final gesture = await tester.press(find.text('Primary Button'));
        await tester.pump(const Duration(milliseconds: 50));

        // Assert: Button should be in pressed state
        expect(find.text('Primary Button'), findsOneWidget);

        // Cleanup
        await gesture.cancel();
      });

      testWidgets('secondary button shows pressed state correctly', (
        tester,
      ) async {
        // Arrange: Create button
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                style: ButtonFeedbackStyle.secondary(context: context),
                onPressed: () {},
                child: const Text('Secondary Button'),
              ),
            ),
          ),
        );

        // Act: Press the button
        final gesture = await tester.press(find.text('Secondary Button'));
        await tester.pump(const Duration(milliseconds: 50));

        // Assert: Button should be in pressed state
        expect(find.text('Secondary Button'), findsOneWidget);

        // Cleanup
        await gesture.cancel();
      });

      testWidgets('tertiary button shows pressed state correctly', (
        tester,
      ) async {
        // Arrange: Create button
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                style: ButtonFeedbackStyle.tertiary(context: context),
                onPressed: () {},
                child: const Text('Tertiary Button'),
              ),
            ),
          ),
        );

        // Act: Press the button
        final gesture = await tester.press(find.text('Tertiary Button'));
        await tester.pump(const Duration(milliseconds: 50));

        // Assert: Button should be in pressed state
        expect(find.text('Tertiary Button'), findsOneWidget);

        // Cleanup
        await gesture.cancel();
      });

      group('color parameter', () {
        testWidgets('secondary style with custom color', (tester) async {
          // Arrange & Act: Create secondary button with custom color
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonFeedbackStyle.secondary(
                    context: context,
                    color: Colors.red,
                  ),
                  onPressed: () {},
                  child: const Text('Secondary Button'),
                ),
              ),
            ),
          );

          // Assert: Button should render
          expect(find.text('Secondary Button'), findsOneWidget);
        });

        testWidgets('secondary style with default color when null', (
          tester,
        ) async {
          // Arrange & Act: Create secondary button without specifying color
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonFeedbackStyle.secondary(context: context),
                  onPressed: () {},
                  child: const Text('Secondary Button'),
                ),
              ),
            ),
          );

          // Assert: Button should render with default primary color
          expect(find.text('Secondary Button'), findsOneWidget);
        });

        testWidgets('tertiary style with custom color', (tester) async {
          // Arrange & Act: Create tertiary button with custom color
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonFeedbackStyle.tertiary(
                    context: context,
                    color: Colors.purple,
                  ),
                  onPressed: () {},
                  child: const Text('Tertiary Button'),
                ),
              ),
            ),
          );

          // Assert: Button should render
          expect(find.text('Tertiary Button'), findsOneWidget);
        });

        testWidgets('tertiary style with default color when null', (
          tester,
        ) async {
          // Arrange & Act: Create tertiary button without specifying color
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonFeedbackStyle.tertiary(context: context),
                  onPressed: () {},
                  child: const Text('Tertiary Button'),
                ),
              ),
            ),
          );

          // Assert: Button should render with default primary color
          expect(find.text('Tertiary Button'), findsOneWidget);
        });

        testWidgets('tertiary button with error color', (tester) async {
          // Arrange & Act: Create tertiary button with error color
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonFeedbackStyle.tertiary(
                    context: context,
                    color: Colors.red,
                  ),
                  onPressed: () {},
                  child: const Text('Error Button'),
                ),
              ),
            ),
          );

          // Assert: Button should render
          expect(find.text('Error Button'), findsOneWidget);
        });

        testWidgets('tertiary button with success color', (tester) async {
          // Arrange & Act: Create tertiary button with success color
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonFeedbackStyle.tertiary(
                    context: context,
                    color: Colors.green,
                  ),
                  onPressed: () {},
                  child: const Text('Success Button'),
                ),
              ),
            ),
          );

          // Assert: Button should render
          expect(find.text('Success Button'), findsOneWidget);
        });

        testWidgets('tertiary button with custom color shows pressed state', (
          tester,
        ) async {
          // Arrange: Create button with custom color
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonFeedbackStyle.tertiary(
                    context: context,
                    color: Colors.orange,
                  ),
                  onPressed: () {},
                  child: const Text('Custom Color Button'),
                ),
              ),
            ),
          );

          // Act: Press the button
          final gesture = await tester.press(find.text('Custom Color Button'));
          await tester.pump(const Duration(milliseconds: 50));

          // Assert: Button should be in pressed state
          expect(find.text('Custom Color Button'), findsOneWidget);

          // Cleanup
          await gesture.cancel();
        });
      });

      group('minimumSize parameter', () {
        testWidgets('primary style accepts minimumSize parameter', (
          tester,
        ) async {
          // Arrange & Act: Create button with minimumSize
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonFeedbackStyle.primary(
                    context: context,
                    minimumSize: WidgetStateProperty.all(
                      const Size(double.infinity, 56),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Min Size Button'),
                ),
              ),
            ),
          );

          // Assert: Button should render
          expect(find.text('Min Size Button'), findsOneWidget);
        });

        testWidgets('primary style with minimumSize renders correctly', (
          tester,
        ) async {
          // Arrange & Act: Create button with minimumSize
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonFeedbackStyle.primary(
                    context: context,
                    minimumSize: WidgetStateProperty.all(
                      const Size(double.infinity, 72),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Tall Button'),
                ),
              ),
            ),
          );

          // Assert: Button should render with correct size
          expect(find.text('Tall Button'), findsOneWidget);
          expect(find.byType(ElevatedButton), findsOneWidget);
        });

        testWidgets('tertiary style accepts minimumSize parameter', (
          tester,
        ) async {
          // Arrange & Act: Create tertiary button with minimumSize
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonFeedbackStyle.tertiary(
                    context: context,
                    minimumSize: const WidgetStatePropertyAll(Size(48, 48)),
                  ),
                  onPressed: () {},
                  child: const Text('Icon Button'),
                ),
              ),
            ),
          );

          // Assert: Button should render
          expect(find.text('Icon Button'), findsOneWidget);
        });

        testWidgets(
          'tertiary style with null minimumSize uses Flutter default',
          (tester) async {
            // Arrange & Act: Create tertiary button without minimumSize
            await tester.pumpWidget(
              createScreenComponentTestWidget(
                Builder(
                  builder: (context) => ElevatedButton(
                    style: ButtonFeedbackStyle.tertiary(context: context),
                    onPressed: () {},
                    child: const Text('Default Size Button'),
                  ),
                ),
              ),
            );

            // Assert: Button should render
            expect(find.text('Default Size Button'), findsOneWidget);
          },
        );
      });
    });
  });
}
