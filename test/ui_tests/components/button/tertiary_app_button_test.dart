import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';

import '../../../../testing_resources/helpers/create_test_widget.dart';

final RoundedRectangleBorder roundedRectangle = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(14),
);

EdgeInsets edgeInsets = const EdgeInsets.symmetric(
  vertical: 16,
  horizontal: 24,
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
      expect(iconWidget.size, 24.0);
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
        expect(iconWidget.size, 24.0);
      },
    );

    testWidgets('Tertiary Label with Long Text Wraps', (
      WidgetTester tester,
    ) async {
      final Widget longTextButton = AppButton.label(
        label:
            'This is a very long button label that should wrap to multiple'
            'lines when screen is small or text size is large',
        onPressed: () {},
        type: AppButtonType.tertiary,
      );
      await tester.pumpWidget(createTestWidget(longTextButton));
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.maxLines, null);
      expect(textWidget.overflow, null);
    });
  });
}
