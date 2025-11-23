import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_content.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:wishing_well/theme/app_theme.dart';

Widget createTestWidget(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  home: Scaffold(body: child),
);

final RoundedRectangleBorder roundedRectangle = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(14),
);

EdgeInsets edgeInsets = const EdgeInsets.symmetric(vertical: 16);

void main() {
  group('Non-iOS Specific Primary Button Styles', () {
    testWidgets('Primary Label AppButton returns Label Content', (
      WidgetTester tester,
    ) async {
      bool buttonTapped = false;
      final Widget primaryLabelButton = AppButton.label(
        label: 'Primary Label Button',
        onPressed: () {
          buttonTapped = true;
        },
        type: AppButtonType.primary,
      );
      await tester.pumpWidget(createTestWidget(primaryLabelButton));
      expect(
        find.widgetWithText(AppButton, 'Primary Label Button'),
        findsOneWidget,
      );
      final buttonWidget = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(
        buttonWidget.style!.backgroundColor!.resolve({}),
        AppColors.primary,
      );
      expect(buttonWidget.style!.shape!.resolve({}), roundedRectangle);
      expect(buttonWidget.style!.padding!.resolve({}), edgeInsets);
      await tester.tap(find.byType(AppButton));
      expect(buttonTapped, true);
      final size = tester.getSize(find.byType(AppButton));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
      // text styles
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style!.fontSize, 16.0);
      expect(textWidget.style!.fontWeight, FontWeight.normal);
      expect(textWidget.style!.letterSpacing, 0.5);
      expect(textWidget.style!.color, AppColors.white);
    });

    testWidgets('Primary Icon AppButton returns Icon Content', (
      WidgetTester tester,
    ) async {
      bool buttonTapped = false;
      final Widget primaryIconButton = AppButton.icon(
        icon: Icons.access_alarm,
        onPressed: () {
          buttonTapped = true;
        },
        type: AppButtonType.primary,
      );
      await tester.pumpWidget(createTestWidget(primaryIconButton));
      expect(
        find.widgetWithIcon(AppButton, Icons.access_alarm),
        findsOneWidget,
      );
      final buttonWidget = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(
        buttonWidget.style!.backgroundColor!.resolve({}),
        AppColors.primary,
      );
      expect(buttonWidget.style!.shape!.resolve({}), roundedRectangle);
      expect(buttonWidget.style!.padding!.resolve({}), edgeInsets);
      await tester.tap(find.byType(AppButton));
      expect(buttonTapped, true);
      final size = tester.getSize(find.byType(AppButton));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
      // text styles
      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.size, 32.0);
      expect(iconWidget.color, AppColors.white);
    });

    testWidgets(
      'Primary Label with Icon AppButton returns Label with Icon Content',
      (WidgetTester tester) async {
        bool buttonTapped = false;
        final Widget primaryLabelWithIconButton = AppButton.labelWithIcon(
          label: 'Primary Label with Icon Button',
          icon: Icons.access_alarm,
          onPressed: () {
            buttonTapped = true;
          },
          type: AppButtonType.primary,
        );
        await tester.pumpWidget(createTestWidget(primaryLabelWithIconButton));
        expect(
          find.widgetWithText(AppButton, 'Primary Label with Icon Button'),
          findsOneWidget,
        );
        expect(
          find.widgetWithIcon(AppButton, Icons.access_alarm),
          findsOneWidget,
        );
        final buttonWidget = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(
          buttonWidget.style!.backgroundColor!.resolve({}),
          AppColors.primary,
        );
        expect(buttonWidget.style!.shape!.resolve({}), roundedRectangle);
        expect(buttonWidget.style!.padding!.resolve({}), edgeInsets);
        await tester.tap(find.byType(AppButton));
        expect(buttonTapped, true);
        final size = tester.getSize(find.byType(AppButton));
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(0));
        // text styles
        final iconWidget = tester.widget<Icon>(find.byType(Icon));
        expect(iconWidget.size, 32.0);
        expect(iconWidget.color, AppColors.white);
      },
    );
  });

  group('iOS Primary Button Styles', () {
    testWidgets('Primary Label AppButton returns Label Content iOS', (
      WidgetTester tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      bool buttonTapped = false;
      final Widget primaryLabelButton = AppButton.label(
        label: 'Primary Label Button',
        onPressed: () {
          buttonTapped = true;
        },
        type: AppButtonType.primary,
      );
      await tester.pumpWidget(createTestWidget(primaryLabelButton));
      expect(
        find.widgetWithText(AppButton, 'Primary Label Button'),
        findsOneWidget,
      );
      final buttonWidget = tester.widget<CupertinoButton>(
        find.byType(CupertinoButton),
      );
      expect(buttonWidget.color, AppColors.primary);
      expect(buttonWidget.foregroundColor, AppColors.white);
      final buttonContent = tester.widget<AppButtonContent>(
        find.byType(AppButtonContent),
      );
      expect(buttonContent.alignment, MainAxisAlignment.center);
      await tester.tap(find.byType(AppButton));
      expect(buttonTapped, true);
      final size = tester.getSize(find.byType(AppButton));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
      // text styles
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style!.fontSize, 16.0);
      expect(textWidget.style!.fontWeight, FontWeight.normal);
      expect(textWidget.style!.letterSpacing, 0.5);
      expect(textWidget.style!.color, AppColors.white);
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
