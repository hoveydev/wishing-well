import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/theme/app_colors.dart';

import '../../../../testing_resources/helpers/create_test_widget.dart';

void main() {
  group('inline alert types', () {
    testWidgets('info', (tester) async {
      final infoAlert = createTestWidget(
        const AppInlineAlert(
          message: 'infoMessage',
          type: AppInlineAlertType.info,
        ),
      );
      await tester.pumpWidget(infoAlert);
      expect(find.byType(AppInlineAlert), findsOneWidget);
      final infoAlertTextFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'infoMessage',
      );
      final infoAlertTextWidget = tester.widget<Text>(infoAlertTextFinder);
      expect(infoAlertTextWidget.style?.color, AppColors.primary);
    });

    testWidgets('success', (tester) async {
      final successAlert = createTestWidget(
        const AppInlineAlert(
          message: 'successMessage',
          type: AppInlineAlertType.success,
        ),
      );
      await tester.pumpWidget(successAlert);
      expect(find.byType(AppInlineAlert), findsOneWidget);
      final successAlertTextFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'successMessage',
      );
      final successAlertTextWidget = tester.widget<Text>(
        successAlertTextFinder,
      );
      expect(successAlertTextWidget.style?.color, AppColors.success);
    });

    testWidgets('warning', (tester) async {
      final warningAlert = createTestWidget(
        const AppInlineAlert(
          message: 'warningMessage',
          type: AppInlineAlertType.warning,
        ),
      );
      await tester.pumpWidget(warningAlert);
      expect(find.byType(AppInlineAlert), findsOneWidget);
      final warningAlertTextFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'warningMessage',
      );
      final warningAlertTextWidget = tester.widget<Text>(
        warningAlertTextFinder,
      );
      expect(warningAlertTextWidget.style?.color, AppColors.warning);
    });

    testWidgets('error', (tester) async {
      final errorAlert = createTestWidget(
        const AppInlineAlert(
          message: 'errorMessage',
          type: AppInlineAlertType.error,
        ),
      );
      await tester.pumpWidget(errorAlert);
      expect(find.byType(AppInlineAlert), findsOneWidget);
      final errorAlertTextFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'errorMessage',
      );
      final errorAlertTextWidget = tester.widget<Text>(errorAlertTextFinder);
      expect(errorAlertTextWidget.style?.color, AppColors.error);
    });
  });
}
