import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/button/types/tertiary_button.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('TertiaryButton', () {
    group(TestGroups.rendering, () {
      testWidgets('renders icon button with icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            TertiaryButton.icon(icon: Icons.edit_outlined, onPressed: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
        expect(find.byType(TertiaryButton), findsOneWidget);
      });

      testWidgets('renders label button with text', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            TertiaryButton.label(label: 'Cancel', onPressed: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Cancel'), findsOneWidget);
        expect(find.byType(TertiaryButton), findsOneWidget);
      });

      testWidgets('renders labelWithIcon button', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            TertiaryButton.labelWithIcon(
              label: 'Edit',
              icon: Icons.edit,
              onPressed: () {},
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Edit'), findsOneWidget);
        expect(find.byIcon(Icons.edit), findsOneWidget);
      });

      testWidgets('icon button uses CircleBorder shape', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            TertiaryButton.icon(icon: Icons.close, onPressed: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final button = tester.widget<TextButton>(find.byType(TextButton));
        final shape = button.style?.shape?.resolve({});
        expect(shape, isA<CircleBorder>());
      });

      testWidgets('icon button has 48x48 minimum size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            TertiaryButton.icon(icon: Icons.close, onPressed: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final button = tester.widget<TextButton>(find.byType(TextButton));
        final size = button.style?.minimumSize?.resolve({});
        expect(size, const Size(48, 48));
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
        var pressed = false;
        await tester.pumpWidget(
          createComponentTestWidget(
            TertiaryButton.label(label: 'Tap', onPressed: () => pressed = true),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Tap'));
        await tester.pumpAndSettle();

        expect(pressed, isTrue);
      });

      testWidgets('shows loading indicator when isLoading is true', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            TertiaryButton.label(
              label: 'Loading',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('does not call onPressed when isLoading is true', (
        WidgetTester tester,
      ) async {
        var pressed = false;
        await tester.pumpWidget(
          createComponentTestWidget(
            TertiaryButton.label(
              label: 'Loading',
              onPressed: () => pressed = true,
              isLoading: true,
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.byType(TertiaryButton));
        await tester.pump();

        expect(pressed, isFalse);
      });

      testWidgets('renders with custom color', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            TertiaryButton.label(
              label: 'Red',
              onPressed: () {},
              color: Colors.red,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Red'), findsOneWidget);
      });
    });
  });
}
