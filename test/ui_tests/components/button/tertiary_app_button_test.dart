import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/button/app_button.dart';
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

EdgeInsets edgeInsets = const EdgeInsets.symmetric(
  vertical: 16,
  horizontal: 32,
);

void main() {
  group('Tertiary Button Styles', () {
    testWidgets('Tertiary Label AppButton returns Label Content', (
      WidgetTester tester,
    ) async {
      bool buttonTapped = false;
      final Widget tertiaryLabelButton = AppButton.label(
        label: 'Tertiary Label Button',
        onPressed: () {
          buttonTapped = true;
        },
        type: AppButtonType.tertiary,
      );
      await tester.pumpWidget(createTestWidget(tertiaryLabelButton));
      expect(
        find.widgetWithText(AppButton, 'Tertiary Label Button'),
        findsOneWidget,
      );
      expect(find.byType(TextButton), findsOneWidget);
      final buttonWidget = tester.widget<TextButton>(find.byType(TextButton));
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
      expect(textWidget.style!.color, AppColors.primary);
    });

    testWidgets('Tertiary Icon AppButton returns Icon Content', (
      WidgetTester tester,
    ) async {
      bool buttonTapped = false;
      final Widget tertiaryIconButton = AppButton.icon(
        icon: Icons.access_alarm,
        onPressed: () {
          buttonTapped = true;
        },
        type: AppButtonType.tertiary,
      );
      await tester.pumpWidget(createTestWidget(tertiaryIconButton));
      expect(
        find.widgetWithIcon(AppButton, Icons.access_alarm),
        findsOneWidget,
      );
      final buttonWidget = tester.widget<TextButton>(find.byType(TextButton));
      expect(buttonWidget.style!.shape!.resolve({}), roundedRectangle);
      expect(buttonWidget.style!.padding!.resolve({}), EdgeInsets.zero);
      await tester.tap(find.byType(AppButton));
      expect(buttonTapped, true);
      final size = tester.getSize(find.byType(AppButton));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
      // text styles
      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.size, 32.0);
      expect(iconWidget.color, AppColors.primary);
    });

    testWidgets(
      'Teritary Label with Icon AppButton returns Label with Icon Content',
      (WidgetTester tester) async {
        bool buttonTapped = false;
        final Widget tertiaryLabelWithIconButton = AppButton.labelWithIcon(
          label: 'Tertiary Label with Icon Button',
          icon: Icons.access_alarm,
          onPressed: () {
            buttonTapped = true;
          },
          type: AppButtonType.tertiary,
        );
        await tester.pumpWidget(createTestWidget(tertiaryLabelWithIconButton));
        expect(
          find.widgetWithText(AppButton, 'Tertiary Label with Icon Button'),
          findsOneWidget,
        );
        expect(
          find.widgetWithIcon(AppButton, Icons.access_alarm),
          findsOneWidget,
        );
        final buttonWidget = tester.widget<TextButton>(find.byType(TextButton));
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
        expect(iconWidget.color, AppColors.primary);
      },
    );
  });
}
