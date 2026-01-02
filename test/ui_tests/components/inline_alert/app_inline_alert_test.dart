import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:wishing_well/theme/app_theme.dart';

Widget createTestWidget(AppInlineAlertType alertType) => MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  home: Screen(
    children: [AppInlineAlert(message: 'testMessage', type: alertType)],
  ),
);

void main() {
  group('inline alert types', () {
    testWidgets('info type', (tester) async {
      final successAlert = createTestWidget(AppInlineAlertType.info);
      await tester.pumpWidget(successAlert);
      expect(find.byType(AppInlineAlert), findsOneWidget);
      final successAlertTextFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'testMessage',
      );
      final successAlertTextWidget = tester.widget<Text>(
        successAlertTextFinder,
      );
      expect(successAlertTextWidget.style?.color, AppColors.primary);
    });

    testWidgets('success type', (tester) async {
      final successAlert = createTestWidget(AppInlineAlertType.success);
      await tester.pumpWidget(successAlert);
      expect(find.byType(AppInlineAlert), findsOneWidget);
      final successAlertTextFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'testMessage',
      );
      final successAlertTextWidget = tester.widget<Text>(
        successAlertTextFinder,
      );
      expect(successAlertTextWidget.style?.color, AppColors.success);
    });

    testWidgets('warning type', (tester) async {
      final successAlert = createTestWidget(AppInlineAlertType.warning);
      await tester.pumpWidget(successAlert);
      expect(find.byType(AppInlineAlert), findsOneWidget);
      final successAlertTextFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'testMessage',
      );
      final successAlertTextWidget = tester.widget<Text>(
        successAlertTextFinder,
      );
      expect(successAlertTextWidget.style?.color, AppColors.warning);
    });

    testWidgets('error type', (tester) async {
      final successAlert = createTestWidget(AppInlineAlertType.error);
      await tester.pumpWidget(successAlert);
      expect(find.byType(AppInlineAlert), findsOneWidget);
      final successAlertTextFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'testMessage',
      );
      final successAlertTextWidget = tester.widget<Text>(
        successAlertTextFinder,
      );
      expect(successAlertTextWidget.style?.color, AppColors.error);
    });
  });
}
