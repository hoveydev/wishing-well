import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_colors.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

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

        expect(find.byType(DecoratedBox), findsOneWidget);
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

        expect(find.byType(DecoratedBox), findsOneWidget);
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

        expect(find.byType(DecoratedBox), findsOneWidget);
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

        expect(find.byType(DecoratedBox), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        TestHelpers.expectTextOnce('Default Input');
        expect(find.byIcon(Icons.input), findsOneWidget);
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

        final decoratedBoxFinder = find.byWidgetPredicate(
          (widget) => widget is DecoratedBox && widget.child is TextField,
        );
        final inputWidget = tester.widget<DecoratedBox>(decoratedBoxFinder);
        final BoxDecoration decoration = BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        );
        expect(inputWidget.decoration, decoration);
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

        final border = OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          borderSide: BorderSide.none,
        );
        expect(input.decoration!.border, border);
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
    });
  });
}
