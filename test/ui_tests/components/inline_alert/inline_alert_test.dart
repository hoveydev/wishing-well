import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/theme/app_colors.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppInlineAlert', () {
    group(TestGroups.rendering, () {
      testWidgets('renders info alert with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const AppInlineAlert(
              message: 'infoMessage',
              type: AppInlineAlertType.info,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppInlineAlert), findsOneWidget);
        TestHelpers.expectTextOnce('infoMessage');

        final infoAlertTextWidget = tester.widget<Text>(
          find.text('infoMessage'),
        );
        expect(infoAlertTextWidget.style?.color, AppColors.primary);
      });

      testWidgets('renders success alert with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const AppInlineAlert(
              message: 'successMessage',
              type: AppInlineAlertType.success,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppInlineAlert), findsOneWidget);
        TestHelpers.expectTextOnce('successMessage');

        final successAlertTextWidget = tester.widget<Text>(
          find.text('successMessage'),
        );
        expect(successAlertTextWidget.style?.color, AppColors.success);
      });

      testWidgets('renders warning alert with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const AppInlineAlert(
              message: 'warningMessage',
              type: AppInlineAlertType.warning,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppInlineAlert), findsOneWidget);
        TestHelpers.expectTextOnce('warningMessage');

        final warningAlertTextWidget = tester.widget<Text>(
          find.text('warningMessage'),
        );
        expect(warningAlertTextWidget.style?.color, AppColors.warning);
      });

      testWidgets('renders error alert with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const AppInlineAlert(
              message: 'errorMessage',
              type: AppInlineAlertType.error,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppInlineAlert), findsOneWidget);
        TestHelpers.expectTextOnce('errorMessage');

        final errorAlertTextWidget = tester.widget<Text>(
          find.text('errorMessage'),
        );
        expect(errorAlertTextWidget.style?.color, AppColors.error);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct text style properties', (
        WidgetTester tester,
      ) async {
        const testMessage = 'Test message';

        await tester.pumpWidget(
          createComponentTestWidget(
            const AppInlineAlert(
              message: testMessage,
              type: AppInlineAlertType.info,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textWidget = tester.widget<Text>(find.text(testMessage));
        expect(textWidget.style?.color, AppColors.primary);
      });

      testWidgets('displays correct message for each alert type', (
        WidgetTester tester,
      ) async {
        const testMessage = 'Test message';

        // Test each alert type
        for (final alertType in AppInlineAlertType.values) {
          await tester.pumpWidget(
            createComponentTestWidget(
              AppInlineAlert(message: testMessage, type: alertType),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          TestHelpers.expectTextOnce(testMessage);
          expect(find.byType(AppInlineAlert), findsOneWidget);
        }
      });
    });
  });
}
