import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_colors.dart';

import '../../../../testing_resources/helpers/create_test_widget.dart';

void main() {
  group('All Input Styles', () {
    String changedValue = '';
    testWidgets('Text Input Styles', (WidgetTester tester) async {
      final Widget textInput = AppInput(
        placeholder: 'Text Input',
        type: AppInputType.text,
        onChanged: (String val) => changedValue = val,
      );
      await tester.pumpWidget(createTestWidget(textInput));
      final decoratedBoxFinder = find.byWidgetPredicate(
        (widget) => widget is DecoratedBox && widget.child is TextField,
      );
      final inputWidget = tester.widget<DecoratedBox>(decoratedBoxFinder);
      final BoxDecoration decoration = BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      );
      expect(inputWidget.decoration, decoration);
      // text field validations
      final TextField input = tester.widget<TextField>(find.byType(TextField));
      expect(input.obscureText, false);
      expect(input.keyboardType, TextInputType.text);
      expect(input.autofillHints, []);
      expect(input.decoration!.prefixIconColor, AppColors.primary);
      final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        borderSide: BorderSide.none,
      );
      expect(input.decoration!.border, border);
      expect(find.widgetWithText(TextField, 'Text Input'), findsOneWidget);
      final icon = find.byIcon(Icons.input);
      expect(icon, findsOneWidget);
      // action validations
      await tester.tap(find.byType(AppInput));
      await tester.enterText(find.byType(AppInput), 'testing the text');
      expect(changedValue, 'testing the text');
      // size validations
      final size = tester.getSize(find.byType(AppInput));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
      // text styles
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style!.fontSize, 14.0);
      expect(textWidget.style!.fontWeight, FontWeight.normal);
      expect(textWidget.style!.letterSpacing, 0.25);
      expect(textWidget.style!.color, AppColors.primary);
      changedValue = '';
    });

    testWidgets('Email Input Styles', (WidgetTester tester) async {
      final Widget textInput = AppInput(
        placeholder: 'Text Input',
        type: AppInputType.email,
        onChanged: (String val) => changedValue = val,
      );
      await tester.pumpWidget(createTestWidget(textInput));
      final decoratedBoxFinder = find.byWidgetPredicate(
        (widget) => widget is DecoratedBox && widget.child is TextField,
      );
      final inputWidget = tester.widget<DecoratedBox>(decoratedBoxFinder);
      final BoxDecoration decoration = BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      );
      expect(inputWidget.decoration, decoration);
      // text field validations
      final TextField input = tester.widget<TextField>(find.byType(TextField));
      expect(input.obscureText, false);
      expect(input.keyboardType, TextInputType.emailAddress);
      expect(input.autofillHints, [AutofillHints.email]);
      expect(input.decoration!.prefixIconColor, AppColors.primary);
      final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        borderSide: BorderSide.none,
      );
      expect(input.decoration!.border, border);
      expect(find.widgetWithText(TextField, 'Text Input'), findsOneWidget);
      final icon = find.byIcon(Icons.email_outlined);
      expect(icon, findsOneWidget);
      // action validations
      await tester.tap(find.byType(AppInput));
      await tester.enterText(find.byType(AppInput), 'testing the text');
      expect(changedValue, 'testing the text');
      // size validations
      final size = tester.getSize(find.byType(AppInput));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
      // text styles
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style!.fontSize, 14.0);
      expect(textWidget.style!.fontWeight, FontWeight.normal);
      expect(textWidget.style!.letterSpacing, 0.25);
      expect(textWidget.style!.color, AppColors.primary);
      changedValue = '';
    });

    testWidgets('Password Input Styles', (WidgetTester tester) async {
      final Widget textInput = AppInput(
        placeholder: 'Text Input',
        type: AppInputType.password,
        onChanged: (String val) => changedValue = val,
      );
      await tester.pumpWidget(createTestWidget(textInput));
      final decoratedBoxFinder = find.byWidgetPredicate(
        (widget) => widget is DecoratedBox && widget.child is TextField,
      );
      final inputWidget = tester.widget<DecoratedBox>(decoratedBoxFinder);
      final BoxDecoration decoration = BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      );
      expect(inputWidget.decoration, decoration);
      // text field validations
      final TextField input = tester.widget<TextField>(find.byType(TextField));
      expect(input.obscureText, true);
      expect(input.keyboardType, TextInputType.visiblePassword);
      expect(input.autofillHints, [AutofillHints.password]);
      expect(input.decoration!.prefixIconColor, AppColors.primary);
      final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        borderSide: BorderSide.none,
      );
      expect(input.decoration!.border, border);
      expect(find.widgetWithText(TextField, 'Text Input'), findsOneWidget);
      final icon = find.byIcon(Icons.lock_outline);
      expect(icon, findsOneWidget);
      // action validations
      await tester.tap(find.byType(AppInput));
      await tester.enterText(find.byType(AppInput), 'testing the text');
      expect(changedValue, 'testing the text');
      // size validations
      final size = tester.getSize(find.byType(AppInput));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
      // text styles
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style!.fontSize, 14.0);
      expect(textWidget.style!.fontWeight, FontWeight.normal);
      expect(textWidget.style!.letterSpacing, 0.25);
      expect(textWidget.style!.color, AppColors.primary);
      changedValue = '';
    });

    testWidgets('Default Input Styles', (WidgetTester tester) async {
      final Widget textInput = AppInput(
        placeholder: 'Text Input',
        type: AppInputType.phone, // using phone because no style is defined yet
        onChanged: (String val) => changedValue = val,
      );
      await tester.pumpWidget(createTestWidget(textInput));
      final decoratedBoxFinder = find.byWidgetPredicate(
        (widget) => widget is DecoratedBox && widget.child is TextField,
      );
      final inputWidget = tester.widget<DecoratedBox>(decoratedBoxFinder);
      final BoxDecoration decoration = BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      );
      expect(inputWidget.decoration, decoration);
      // text field validations
      final TextField input = tester.widget<TextField>(find.byType(TextField));
      expect(input.obscureText, false);
      expect(input.keyboardType, TextInputType.text);
      expect(input.autofillHints, []);
      expect(input.decoration!.prefixIconColor, AppColors.primary);
      final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        borderSide: BorderSide.none,
      );
      expect(input.decoration!.border, border);
      expect(find.widgetWithText(TextField, 'Text Input'), findsOneWidget);
      final icon = find.byIcon(Icons.input);
      expect(icon, findsOneWidget);
      // action validations
      await tester.tap(find.byType(AppInput));
      await tester.enterText(find.byType(AppInput), 'testing the text');
      expect(changedValue, 'testing the text');
      // size validations
      final size = tester.getSize(find.byType(AppInput));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
      // text styles
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style!.fontSize, 14.0);
      expect(textWidget.style!.fontWeight, FontWeight.normal);
      expect(textWidget.style!.letterSpacing, 0.25);
      expect(textWidget.style!.color, AppColors.primary);
      changedValue = '';
    });

    testWidgets('Email Input accepts FocusNode', (WidgetTester tester) async {
      final focusNode = FocusNode();
      final Widget textInput = AppInput(
        placeholder: 'Email Input',
        type: AppInputType.email,
        onChanged: (String val) => changedValue = val,
        focusNode: focusNode,
      );
      await tester.pumpWidget(createTestWidget(textInput));
      final TextField input = tester.widget<TextField>(find.byType(TextField));
      expect(input.focusNode, focusNode);
      focusNode.dispose();
      changedValue = '';
    });

    testWidgets('Password Input accepts FocusNode', (
      WidgetTester tester,
    ) async {
      final focusNode = FocusNode();
      final Widget textInput = AppInput(
        placeholder: 'Password Input',
        type: AppInputType.password,
        onChanged: (String val) => changedValue = val,
        focusNode: focusNode,
      );
      await tester.pumpWidget(createTestWidget(textInput));
      final TextField input = tester.widget<TextField>(find.byType(TextField));
      expect(input.focusNode, focusNode);
      focusNode.dispose();
      changedValue = '';
    });
  });
}
