import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/theme/app_colors.dart';

import '../../../../testing_resources/helpers/create_test_widget.dart';

final RoundedRectangleBorder roundedRectangle = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(14),
);

EdgeInsets edgeInsets = const EdgeInsets.symmetric(
  vertical: 16,
  horizontal: 24,
);
BorderSide borderSide = const BorderSide(color: AppColors.primary);

void main() {
  group('Secondary Button Styles', () {
    testWidgets('Secondary Label AppButton returns Label Content', (
      WidgetTester tester,
    ) async {
      bool buttonTapped = false;
      final Widget secondaryLabelButton = AppButton.label(
        label: 'Secondary Label Button',
        onPressed: () {
          buttonTapped = true;
        },
        type: AppButtonType.secondary,
      );
      await tester.pumpWidget(createTestWidget(secondaryLabelButton));
      expect(
        find.widgetWithText(AppButton, 'Secondary Label Button'),
        findsOneWidget,
      );
      final buttonWidget = tester.widget<TextButton>(find.byType(TextButton));
      expect(buttonWidget.style!.backgroundBuilder, isNotNull);
      expect(buttonWidget.style!.shape!.resolve({}), roundedRectangle);
      expect(buttonWidget.style!.padding!.resolve({}), edgeInsets);
      expect(buttonWidget.style!.side!.resolve({}), borderSide);
      await tester.tap(find.byType(AppButton));
      expect(buttonTapped, true);
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(AppButton)),
      );
      await tester.pump();
      expect(buttonWidget.style!.backgroundBuilder, isNotNull);
      await gesture.up();
      await tester.pumpAndSettle();
      final size = tester.getSize(find.byType(AppButton));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
      // text styles
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style!.fontSize, 16.0);
    });

    testWidgets('Secondary Icon AppButton returns Icon Content', (
      WidgetTester tester,
    ) async {
      bool buttonTapped = false;
      final Widget secondaryIconButton = AppButton.icon(
        icon: Icons.access_alarm,
        onPressed: () {
          buttonTapped = true;
        },
        type: AppButtonType.secondary,
      );
      await tester.pumpWidget(createTestWidget(secondaryIconButton));
      expect(
        find.widgetWithIcon(AppButton, Icons.access_alarm),
        findsOneWidget,
      );
      final buttonWidget = tester.widget<TextButton>(find.byType(TextButton));
      expect(buttonWidget.style!.backgroundBuilder, isNotNull);
      expect(buttonWidget.style!.shape!.resolve({}), roundedRectangle);
      expect(buttonWidget.style!.padding!.resolve({}), edgeInsets);
      expect(buttonWidget.style!.side!.resolve({}), borderSide);
      await tester.tap(find.byType(AppButton));
      expect(buttonTapped, true);
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(AppButton)),
      );
      await tester.pump();
      expect(buttonWidget.style!.backgroundBuilder, isNotNull);
      await gesture.up();
      await tester.pumpAndSettle();
      final size = tester.getSize(find.byType(AppButton));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
      // text styles
      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.size, 24.0);
    });

    testWidgets(
      'Secondary Label with Icon AppButton returns Label with Icon Content',
      (WidgetTester tester) async {
        bool buttonTapped = false;
        final Widget secondaryLabelWithIconButton = AppButton.labelWithIcon(
          label: 'Secondary Label with Icon Button',
          icon: Icons.access_alarm,
          onPressed: () {
            buttonTapped = true;
          },
          type: AppButtonType.secondary,
        );
        await tester.pumpWidget(createTestWidget(secondaryLabelWithIconButton));
        expect(
          find.widgetWithText(AppButton, 'Secondary Label with Icon Button'),
          findsOneWidget,
        );
        expect(
          find.widgetWithIcon(AppButton, Icons.access_alarm),
          findsOneWidget,
        );
        final buttonWidget = tester.widget<TextButton>(find.byType(TextButton));
        expect(buttonWidget.style!.backgroundBuilder, isNotNull);
        expect(buttonWidget.style!.shape!.resolve({}), roundedRectangle);
        expect(buttonWidget.style!.padding!.resolve({}), edgeInsets);
        expect(buttonWidget.style!.side!.resolve({}), borderSide);
        await tester.tap(find.byType(AppButton));
        expect(buttonTapped, true);
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(AppButton)),
        );
        await tester.pump();
        expect(buttonWidget.style!.backgroundBuilder, isNotNull);
        await gesture.up();
        await tester.pumpAndSettle();
        final size = tester.getSize(find.byType(AppButton));
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(0));
        // text styles
        final iconWidget = tester.widget<Icon>(find.byType(Icon));
        expect(iconWidget.size, 24.0);
      },
    );

    testWidgets('Secondary Label with Long Text Wraps', (
      WidgetTester tester,
    ) async {
      final Widget longTextButton = AppButton.label(
        label:
            'This is a very long button label that should wrap to multiple'
            'lines when screen is small or text size is large',
        onPressed: () {},
        type: AppButtonType.secondary,
      );
      await tester.pumpWidget(createTestWidget(longTextButton));
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.maxLines, null);
      expect(textWidget.overflow, null);
    });
  });
}
