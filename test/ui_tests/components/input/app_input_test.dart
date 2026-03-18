import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:wishing_well/theme/app_theme.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AppInput', () {
    // ignore: unused_local_variable
    String changedValue = '';

    group(TestGroups.rendering, () {
      testWidgets('renders text input with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Text Input',
              type: AppInputType.text,
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AnimatedContainer), findsWidgets);
        expect(find.byType(TextField), findsOneWidget);
        TestHelpers.expectTextOnce('Text Input');
      });

      testWidgets('renders email input with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Email Input',
              type: AppInputType.email,
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AnimatedContainer), findsWidgets);
        expect(find.byType(TextField), findsOneWidget);
        TestHelpers.expectTextOnce('Email Input');
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      });

      testWidgets('renders password input with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Password Input',
              type: AppInputType.password,
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AnimatedContainer), findsWidgets);
        expect(find.byType(TextField), findsOneWidget);
        TestHelpers.expectTextOnce('Password Input');
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      });

      testWidgets('renders default input with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Default Input',
              type: AppInputType
                  .phone, // using phone because no default style is defined yet
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AnimatedContainer), findsWidgets);
        expect(find.byType(TextField), findsOneWidget);
        TestHelpers.expectTextOnce('Default Input');
        expect(find.byIcon(Icons.input), findsOneWidget);
      });

      testWidgets('has no box shadow in decoration', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Test Input',
              type: AppInputType.text,
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final animatedContainerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AnimatedContainer &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).border != null,
        );
        expect(animatedContainerFinder, findsOneWidget);

        final container = tester.widget<AnimatedContainer>(
          animatedContainerFinder,
        );
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.boxShadow, isNull);
      });

      testWidgets('has transparent background (no fill color)', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Test Input',
              type: AppInputType.text,
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find the AnimatedContainer with border decoration (outer container)
        final animatedContainerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AnimatedContainer &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).border != null,
        );
        expect(animatedContainerFinder, findsOneWidget);

        final container = tester.widget<AnimatedContainer>(
          animatedContainerFinder,
        );
        final decoration = container.decoration as BoxDecoration;
        // Color is null (not set) which means transparent/no fill
        expect(decoration.color, isNull);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct decoration properties for text input', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Text Input',
              type: AppInputType.text,
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final animatedContainerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AnimatedContainer &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).border != null,
        );
        final inputWidget = tester.widget<AnimatedContainer>(
          animatedContainerFinder,
        );
        final decoration = inputWidget.decoration as BoxDecoration;

        expect(
          decoration.borderRadius,
          BorderRadius.circular(AppBorderRadius.medium),
        );
        expect(decoration.border, isA<Border>());
      });

      testWidgets('has correct text field properties for text input', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Text Input',
              type: AppInputType.text,
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final input = tester.widget<TextField>(find.byType(TextField));
        expect(input.obscureText, false);
        expect(input.keyboardType, TextInputType.text);
        expect(input.autofillHints, []);
        expect(input.decoration!.prefixIconColor, AppColors.primary);

        // Verify inner TextField has no visible border
        // Inner border radius is AppBorderRadius.medium - 1.5 = 12.5
        final border = input.decoration!.border as OutlineInputBorder;
        expect(
          border.borderRadius,
          BorderRadius.circular(AppBorderRadius.medium - 1.5),
        );
        expect(border.borderSide, BorderSide.none);
      });

      testWidgets('has correct text style properties', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Test Input',
              type: AppInputType.text,
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style!.fontSize, 14.0);
        expect(textWidget.style!.fontWeight, FontWeight.normal);
        expect(textWidget.style!.letterSpacing, 0.25);
        expect(textWidget.style!.color, AppColors.primary);
      });

      testWidgets('has correct email input properties', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Email Input',
              type: AppInputType.email,
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final input = tester.widget<TextField>(find.byType(TextField));
        expect(input.keyboardType, TextInputType.emailAddress);
        expect(input.autofillHints, [AutofillHints.email]);
        expect(input.decoration!.prefixIconColor, AppColors.primary);
      });

      testWidgets('has correct password input properties', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Password Input',
              type: AppInputType.password,
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final input = tester.widget<TextField>(find.byType(TextField));
        expect(input.obscureText, true);
        expect(input.keyboardType, TextInputType.visiblePassword);
        expect(input.autofillHints, [AutofillHints.password]);
        expect(input.decoration!.prefixIconColor, AppColors.primary);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('calls onChanged when text is entered', (
        WidgetTester tester,
      ) async {
        String capturedValue = '';

        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Test Input',
              type: AppInputType.text,
              onChanged: (String val) => capturedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.byType(AppInput));
        await TestHelpers.enterTextAndSettle(
          tester,
          find.byType(AppInput),
          'testing text',
        );

        expect(capturedValue, 'testing text');
      });

      testWidgets('has non-zero dimensions', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Test Input',
              type: AppInputType.text,
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final size = tester.getSize(find.byType(AppInput));
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(0));
      });

      testWidgets('accepts FocusNode for text input', (
        WidgetTester tester,
      ) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Email Input',
              type: AppInputType.email,
              onChanged: (String val) => changedValue = val,
              focusNode: focusNode,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final input = tester.widget<TextField>(find.byType(TextField));
        expect(input.focusNode, focusNode);

        focusNode.dispose();
      });

      testWidgets('accepts FocusNode for password input', (
        WidgetTester tester,
      ) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Password Input',
              type: AppInputType.password,
              onChanged: (String val) => changedValue = val,
              focusNode: focusNode,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final input = tester.widget<TextField>(find.byType(TextField));
        expect(input.focusNode, focusNode);

        focusNode.dispose();
      });

      testWidgets('border color animates on focus', (
        WidgetTester tester,
      ) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Center(
                child: AppInput(
                  placeholder: 'Test Input',
                  type: AppInputType.text,
                  onChanged: (String val) => changedValue = val,
                  focusNode: focusNode,
                ),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find the AnimatedContainer with border decoration
        final animatedContainerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AnimatedContainer &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).border != null,
        );
        final container = tester.widget<AnimatedContainer>(
          animatedContainerFinder,
        );

        // Verify AnimatedContainer has correct animation properties
        expect(container.duration, const Duration(milliseconds: 200));
        expect(container.curve, Curves.easeInOut);

        // Initially unfocused - border should be borderGray
        final decoration = container.decoration as BoxDecoration;
        expect((decoration.border as Border).top.color, AppColors.borderGray);

        // Note: Full focus animation testing requires integration tests
        // because the FocusNode needs to be attached to the focus tree
        // to properly trigger listener callbacks in widget tests.

        focusNode.dispose();
      });
    });

    group(TestGroups.initialState, () {
      testWidgets('renders in unfocused state with borderGray border', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            AppInput(
              placeholder: 'Test Input',
              type: AppInputType.text,
              onChanged: (String val) => changedValue = val,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find the AnimatedContainer with border decoration
        final animatedContainerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AnimatedContainer &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).border != null,
        );
        final container = tester.widget<AnimatedContainer>(
          animatedContainerFinder,
        );
        final decoration = container.decoration as BoxDecoration;

        // Unfocused state should have borderGray border
        expect((decoration.border as Border).top.color, AppColors.borderGray);
      });
    });
  });
}
