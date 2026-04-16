import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/button/types/primary_button.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('PrimaryButton', () {
    group(TestGroups.rendering, () {
      testWidgets('renders label button with text', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            PrimaryButton.label(label: 'Save', onPressed: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Save'), findsOneWidget);
        expect(find.byType(PrimaryButton), findsOneWidget);
      });

      testWidgets('renders icon button', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            PrimaryButton.icon(icon: Icons.save, onPressed: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.save), findsOneWidget);
      });

      testWidgets('renders label with icon button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            PrimaryButton.labelWithIcon(
              label: 'Save',
              icon: Icons.save,
              onPressed: () {},
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Save'), findsOneWidget);
        expect(find.byIcon(Icons.save), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('renders with custom backgroundColor', (
        WidgetTester tester,
      ) async {
        const customColor = Colors.red;
        await tester.pumpWidget(
          createComponentTestWidget(
            PrimaryButton.label(
              label: 'Colored',
              onPressed: () {},
              backgroundColor: customColor,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
        expect(button.backgroundColor, customColor);
      });

      testWidgets('null backgroundColor does not throw', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            PrimaryButton.label(label: 'No Color', onPressed: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
        expect(button.backgroundColor, isNull);
      });

      testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
        var pressed = false;
        await tester.pumpWidget(
          createComponentTestWidget(
            PrimaryButton.label(
              label: 'Tap Me',
              onPressed: () => pressed = true,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Tap Me'));
        await tester.pumpAndSettle();

        expect(pressed, isTrue);
      });

      testWidgets('shows loading indicator when isLoading is true', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            PrimaryButton.label(
              label: 'Loading',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders Semantics wrapper when semanticLabel is set', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            PrimaryButton.icon(
              icon: Icons.save,
              onPressed: () {},
              semanticLabel: 'Save button',
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final semanticsWidget = tester.widget<Semantics>(
          find
              .ancestor(
                of: find.byIcon(Icons.save),
                matching: find.byWidgetPredicate(
                  (w) => w is Semantics && w.properties.label == 'Save button',
                ),
              )
              .first,
        );
        expect(semanticsWidget.properties.label, 'Save button');
      });
    });
  });
}
