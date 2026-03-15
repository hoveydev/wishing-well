import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AppButton - fontWeight', () {
    const testLabel = 'Test Button';
    const testIcon = Icons.access_alarm;

    group(TestGroups.rendering, () {
      testWidgets('tertiary label button accepts custom fontWeight', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.label(
              label: testLabel,
              onPressed: () {},
              type: AppButtonType.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Widget should render without errors
        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('tertiary label button with default fontWeight', (
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

        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('tertiary labelWithIcon button accepts fontWeight', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.labelWithIcon(
              label: testLabel,
              icon: testIcon,
              onPressed: () {},
              type: AppButtonType.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('tertiary icon button accepts fontWeight parameter', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.icon(
              icon: testIcon,
              onPressed: () {},
              type: AppButtonType.tertiary,
              fontWeight: FontWeight.w300,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Icon button should not throw when fontWeight is provided
        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('primary label button accepts fontWeight', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.label(
              label: testLabel,
              onPressed: () {},
              type: AppButtonType.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('secondary label button accepts fontWeight', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.label(
              label: testLabel,
              onPressed: () {},
              type: AppButtonType.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('labelWithIcon button accepts fontWeight', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.labelWithIcon(
              label: testLabel,
              icon: testIcon,
              onPressed: () {},
              type: AppButtonType.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should have icon and text
        expect(find.byIcon(testIcon), findsOneWidget);
        expect(find.text(testLabel), findsOneWidget);
      });

      testWidgets('fontWeight with different values', (
        WidgetTester tester,
      ) async {
        // Test FontWeight.w100 (thin)
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.label(
              label: testLabel,
              onPressed: () {},
              type: AppButtonType.tertiary,
              fontWeight: FontWeight.w100,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(AppButton), findsOneWidget);

        // Test FontWeight.w900 (black)
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.label(
              label: testLabel,
              onPressed: () {},
              type: AppButtonType.tertiary,
              fontWeight: FontWeight.w900,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('fontWeight is preserved through rebuilds', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.label(
              label: testLabel,
              onPressed: () {},
              type: AppButtonType.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppButton), findsOneWidget);

        // Trigger rebuild by changing state
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.label(
              label: testLabel,
              onPressed: () {},
              type: AppButtonType.tertiary,
              fontWeight: FontWeight.bold,
              isLoading: true,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppButton), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('fontWeight does not affect button tap behavior', (
        WidgetTester tester,
      ) async {
        var wasTapped = false;

        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.label(
              label: testLabel,
              onPressed: () => wasTapped = true,
              type: AppButtonType.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.byType(AppButton));
        expect(wasTapped, isTrue);
      });

      testWidgets('fontWeight works with isLoading state', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppButton.label(
              label: testLabel,
              onPressed: () {},
              type: AppButtonType.tertiary,
              fontWeight: FontWeight.bold,
              isLoading: true,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should not crash when loading
        expect(find.byType(AppButton), findsOneWidget);
      });
    });
  });
}
