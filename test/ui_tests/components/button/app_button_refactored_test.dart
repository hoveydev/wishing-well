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

    group(TestGroups.rendering, () {
      testWidgets('Primary Label button renders correctly', (
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

      testWidgets('Primary Icon button renders correctly', (
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

      testWidgets('Primary Label with Icon button renders correctly', (
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

      testWidgets('Long text wraps correctly', (WidgetTester tester) async {
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
      testWidgets('Label button calls onPressed when tapped', (
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

      testWidgets('Icon button calls onPressed when tapped', (
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

      testWidgets('Label with Icon button calls onPressed when tapped', (
        WidgetTester tester,
      ) async {
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
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('Button has correct visual properties', (
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

        final buttonWidget = tester.widget<TextButton>(find.byType(TextButton));
        final roundedRectangle = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        );
        const expectedPadding = EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        );

        expect(buttonWidget.style!.shape!.resolve({}), roundedRectangle);
        expect(buttonWidget.style!.padding!.resolve({}), expectedPadding);
        expect(
          buttonWidget.style!.foregroundColor?.resolve({}),
          AppColors.onPrimary,
        );
      });

      testWidgets('Button has proper text styling', (
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

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style!.fontSize, 16.0);
      });

      testWidgets('Icon button has proper icon styling', (
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

        final iconWidget = tester.widget<Icon>(find.byType(Icon));
        expect(iconWidget.size, 24.0);
      });

      testWidgets('Button has non-zero dimensions', (
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

      testWidgets('Button responds to touch gestures', (
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
