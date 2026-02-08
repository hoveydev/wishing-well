import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/theme/app_colors.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppButton', () {
    const testLabel = 'Test Button';
    const testIcon = Icons.access_alarm;

    // Common button style properties
    final roundedRectangle = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );

    const primaryPadding = EdgeInsets.symmetric(vertical: 16, horizontal: 24);

    group(TestGroups.rendering, () {
      group('Primary Button', () {
        testWidgets('renders primary label button correctly', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.label(
                label: testLabel,
                onPressed: () {},
                type: AppButtonType.primary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          TestHelpers.expectTextOnce(testLabel);
          expect(find.byType(AppButton), findsOneWidget);
          expect(find.byType(TextButton), findsOneWidget);
        });

        testWidgets('renders primary icon button correctly', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.icon(
                icon: testIcon,
                onPressed: () {},
                type: AppButtonType.primary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          expect(find.byIcon(testIcon), findsOneWidget);
          expect(find.byType(AppButton), findsOneWidget);
        });

        testWidgets('renders primary label with icon button correctly', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.labelWithIcon(
                label: testLabel,
                icon: testIcon,
                onPressed: () {},
                type: AppButtonType.primary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          TestHelpers.expectTextOnce(testLabel);
          expect(find.byIcon(testIcon), findsOneWidget);
          expect(find.byType(AppButton), findsOneWidget);
        });
      });

      group('Secondary Button', () {
        testWidgets('renders secondary label button correctly', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.label(
                label: testLabel,
                onPressed: () {},
                type: AppButtonType.secondary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          TestHelpers.expectTextOnce(testLabel);
          expect(find.byType(AppButton), findsOneWidget);
          expect(find.byType(TextButton), findsOneWidget);
        });

        testWidgets('renders secondary icon button correctly', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.icon(
                icon: testIcon,
                onPressed: () {},
                type: AppButtonType.secondary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          expect(find.byIcon(testIcon), findsOneWidget);
          expect(find.byType(AppButton), findsOneWidget);
        });

        testWidgets('renders secondary label with icon button correctly', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.labelWithIcon(
                label: testLabel,
                icon: testIcon,
                onPressed: () {},
                type: AppButtonType.secondary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          TestHelpers.expectTextOnce(testLabel);
          expect(find.byIcon(testIcon), findsOneWidget);
          expect(find.byType(AppButton), findsOneWidget);
        });
      });

      group('Tertiary Button', () {
        testWidgets('renders tertiary label button correctly', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.label(
                label: testLabel,
                onPressed: () {},
                type: AppButtonType.tertiary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          TestHelpers.expectTextOnce(testLabel);
          expect(find.byType(AppButton), findsOneWidget);
          expect(find.byType(TextButton), findsOneWidget);
        });

        testWidgets('renders tertiary icon button correctly', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.icon(
                icon: testIcon,
                onPressed: () {},
                type: AppButtonType.tertiary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          expect(find.byIcon(testIcon), findsOneWidget);
          expect(find.byType(AppButton), findsOneWidget);
        });

        testWidgets('renders tertiary label with icon button correctly', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.labelWithIcon(
                label: testLabel,
                icon: testIcon,
                onPressed: () {},
                type: AppButtonType.tertiary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          TestHelpers.expectTextOnce(testLabel);
          expect(find.byIcon(testIcon), findsOneWidget);
          expect(find.byType(AppButton), findsOneWidget);
        });
      });

      testWidgets('long text wraps correctly', (WidgetTester tester) async {
        const longText =
            'This is a very long button label that '
            'should wrap to multiple lines';

        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.label(
              label: longText,
              onPressed: () {},
              type: AppButtonType.primary,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.maxLines, isNull);
        expect(textWidget.overflow, isNull);
        TestHelpers.expectTextOnce(longText);
      });
    });

    group(TestGroups.interaction, () {
      group('Primary Button', () {
        testWidgets('primary label button calls onPressed when tapped', (
          WidgetTester tester,
        ) async {
          var wasTapped = false;

          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.label(
                label: testLabel,
                onPressed: () => wasTapped = true,
                type: AppButtonType.primary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(tester, find.byType(AppButton));
          expect(wasTapped, isTrue);
        });

        testWidgets('primary icon button calls onPressed when tapped', (
          WidgetTester tester,
        ) async {
          var wasTapped = false;

          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.icon(
                icon: testIcon,
                onPressed: () => wasTapped = true,
                type: AppButtonType.primary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(tester, find.byType(AppButton));
          expect(wasTapped, isTrue);
        });

        testWidgets(
          'primary label with icon button calls onPressed when tapped',
          (WidgetTester tester) async {
            var wasTapped = false;

            await tester.pumpWidget(
              createComponentTestWidget(
                AppButton.labelWithIcon(
                  label: testLabel,
                  icon: testIcon,
                  onPressed: () => wasTapped = true,
                  type: AppButtonType.primary,
                ),
              ),
            );
            await TestHelpers.pumpAndSettle(tester);

            await TestHelpers.tapAndSettle(tester, find.byType(AppButton));
            expect(wasTapped, isTrue);
          },
        );
      });

      group('Secondary Button', () {
        testWidgets('secondary label button calls onPressed when tapped', (
          WidgetTester tester,
        ) async {
          var wasTapped = false;

          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.label(
                label: testLabel,
                onPressed: () => wasTapped = true,
                type: AppButtonType.secondary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(tester, find.byType(AppButton));
          expect(wasTapped, isTrue);
        });

        testWidgets('secondary icon button calls onPressed when tapped', (
          WidgetTester tester,
        ) async {
          var wasTapped = false;

          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.icon(
                icon: testIcon,
                onPressed: () => wasTapped = true,
                type: AppButtonType.secondary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(tester, find.byType(AppButton));
          expect(wasTapped, isTrue);
        });

        testWidgets(
          'secondary label with icon button calls onPressed when tapped',
          (WidgetTester tester) async {
            var wasTapped = false;

            await tester.pumpWidget(
              createComponentTestWidget(
                AppButton.labelWithIcon(
                  label: testLabel,
                  icon: testIcon,
                  onPressed: () => wasTapped = true,
                  type: AppButtonType.secondary,
                ),
              ),
            );
            await TestHelpers.pumpAndSettle(tester);

            await TestHelpers.tapAndSettle(tester, find.byType(AppButton));
            expect(wasTapped, isTrue);
          },
        );
      });

      group('Tertiary Button', () {
        testWidgets('tertiary label button calls onPressed when tapped', (
          WidgetTester tester,
        ) async {
          var wasTapped = false;

          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.label(
                label: testLabel,
                onPressed: () => wasTapped = true,
                type: AppButtonType.tertiary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(tester, find.byType(AppButton));
          expect(wasTapped, isTrue);
        });

        testWidgets('tertiary icon button calls onPressed when tapped', (
          WidgetTester tester,
        ) async {
          var wasTapped = false;

          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.icon(
                icon: testIcon,
                onPressed: () => wasTapped = true,
                type: AppButtonType.tertiary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(tester, find.byType(AppButton));
          expect(wasTapped, isTrue);
        });

        testWidgets(
          'tertiary label with icon button calls onPressed when tapped',
          (WidgetTester tester) async {
            var wasTapped = false;

            await tester.pumpWidget(
              createComponentTestWidget(
                AppButton.labelWithIcon(
                  label: testLabel,
                  icon: testIcon,
                  onPressed: () => wasTapped = true,
                  type: AppButtonType.tertiary,
                ),
              ),
            );
            await TestHelpers.pumpAndSettle(tester);

            await TestHelpers.tapAndSettle(tester, find.byType(AppButton));
            expect(wasTapped, isTrue);
          },
        );
      });
    });

    group(TestGroups.behavior, () {
      group('Primary Button Properties', () {
        testWidgets('has correct visual properties', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.label(
                label: testLabel,
                onPressed: () {},
                type: AppButtonType.primary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          final buttonWidget = tester.widget<TextButton>(
            find.byType(TextButton),
          );
          expect(buttonWidget.style!.shape!.resolve({}), roundedRectangle);
          expect(buttonWidget.style!.padding!.resolve({}), primaryPadding);
          expect(
            buttonWidget.style!.foregroundColor?.resolve({}),
            AppColors.onPrimary,
          );
        });

        testWidgets('has proper text styling', (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.label(
                label: testLabel,
                onPressed: () {},
                type: AppButtonType.primary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          final textWidget = tester.widget<Text>(find.byType(Text));
          expect(textWidget.style!.fontSize, 16.0);
        });

        testWidgets('has proper icon styling', (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.icon(
                icon: testIcon,
                onPressed: () {},
                type: AppButtonType.primary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(iconWidget.size, 24.0);
        });
      });

      group('Secondary Button Properties', () {
        testWidgets('has correct visual properties with border', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.label(
                label: testLabel,
                onPressed: () {},
                type: AppButtonType.secondary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          final buttonWidget = tester.widget<TextButton>(
            find.byType(TextButton),
          );
          expect(buttonWidget.style!.shape!.resolve({}), roundedRectangle);
          expect(buttonWidget.style!.padding!.resolve({}), primaryPadding);
          const borderSide = BorderSide(color: AppColors.primary);
          expect(buttonWidget.style!.side!.resolve({}), borderSide);
        });

        testWidgets('has proper text styling', (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.label(
                label: testLabel,
                onPressed: () {},
                type: AppButtonType.secondary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          final textWidget = tester.widget<Text>(find.byType(Text));
          expect(textWidget.style!.fontSize, 16.0);
        });

        testWidgets('has proper icon styling', (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.icon(
                icon: testIcon,
                onPressed: () {},
                type: AppButtonType.secondary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(iconWidget.size, 24.0);
        });
      });

      group('Tertiary Button Properties', () {
        testWidgets(
          'has correct visual properties with circular shape and no padding',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              createComponentTestWidget(
                AppButton.icon(
                  icon: testIcon,
                  onPressed: () {},
                  type: AppButtonType.tertiary,
                ),
              ),
            );
            await TestHelpers.pumpAndSettle(tester);

            final buttonWidget = tester.widget<TextButton>(
              find.byType(TextButton),
            );
            expect(
              buttonWidget.style!.shape!.resolve({}),
              const CircleBorder(),
            );
            expect(buttonWidget.style!.padding!.resolve({}), EdgeInsets.zero);
          },
        );

        testWidgets('tertiary label button has rounded rectangle shape', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.label(
                label: testLabel,
                onPressed: () {},
                type: AppButtonType.tertiary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          final buttonWidget = tester.widget<TextButton>(
            find.byType(TextButton),
          );
          expect(buttonWidget.style!.shape!.resolve({}), roundedRectangle);
          expect(buttonWidget.style!.padding!.resolve({}), primaryPadding);
        });

        testWidgets(
          'tertiary label with icon button has rounded rectangle shape',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              createComponentTestWidget(
                AppButton.labelWithIcon(
                  label: testLabel,
                  icon: testIcon,
                  onPressed: () {},
                  type: AppButtonType.tertiary,
                ),
              ),
            );
            await TestHelpers.pumpAndSettle(tester);

            final buttonWidget = tester.widget<TextButton>(
              find.byType(TextButton),
            );
            expect(buttonWidget.style!.shape!.resolve({}), roundedRectangle);
            expect(buttonWidget.style!.padding!.resolve({}), primaryPadding);
          },
        );

        testWidgets('has proper text styling', (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.label(
                label: testLabel,
                onPressed: () {},
                type: AppButtonType.tertiary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          final textWidget = tester.widget<Text>(find.byType(Text));
          expect(textWidget.style!.fontSize, 16.0);
        });

        testWidgets('has proper icon styling', (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppButton.icon(
                icon: testIcon,
                onPressed: () {},
                type: AppButtonType.tertiary,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(iconWidget.size, 24.0);
        });
      });

      testWidgets('button has non-zero dimensions', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.label(
              label: testLabel,
              onPressed: () {},
              type: AppButtonType.primary,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final size = tester.getSize(find.byType(AppButton));
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(0));
      });

      testWidgets('button responds to touch gestures', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.label(
              label: testLabel,
              onPressed: () {},
              type: AppButtonType.primary,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(AppButton)),
        );
        await tester.pump();

        // Button should still be present during gesture
        expect(find.byType(AppButton), findsOneWidget);

        await gesture.up();
        await TestHelpers.pumpAndSettle(tester);
      });
    });
  });
}
