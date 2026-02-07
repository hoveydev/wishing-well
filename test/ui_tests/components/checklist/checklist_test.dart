import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/checklist/checklist_icon.dart';
import 'package:wishing_well/components/checklist/checklist_item.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('Checklist Components', () {
    group('ChecklistIcon', () {
      const iconColor = Colors.blue;
      const bgColor = Colors.white;
      const borderColor = Colors.black;

      group(TestGroups.rendering, () {
        testWidgets('renders with correct properties', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              const ChecklistIcon(
                iconColor: iconColor,
                bgColor: bgColor,
                borderColor: borderColor,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          expect(find.byType(Container), findsOneWidget);

          final container = tester.widget<Container>(find.byType(Container));
          final decoration = container.decoration as BoxDecoration;

          expect(decoration.color, bgColor);
          expect(decoration.shape, BoxShape.circle);

          final border = decoration.border as Border;
          expect(border.top.color, borderColor);
        });

        testWidgets('renders with check icon when icon is provided', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              const ChecklistIcon(
                iconColor: iconColor,
                bgColor: bgColor,
                borderColor: borderColor,
                icon: Icons.check,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          expect(find.byIcon(Icons.check), findsOneWidget);

          final iconWidget = tester.widget<Icon>(find.byIcon(Icons.check));
          expect(iconWidget.size, 14.0);
          expect(iconWidget.color, iconColor);
        });

        testWidgets('renders icon widget even when icon is null', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              const ChecklistIcon(
                iconColor: iconColor,
                bgColor: bgColor,
                borderColor: borderColor,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          final iconWidget = tester.widget<Icon>(find.byType(Icon));
          expect(iconWidget.icon, isNull);
        });
      });

      group(TestGroups.behavior, () {
        testWidgets('has correct dimensions', (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              const ChecklistIcon(
                iconColor: iconColor,
                bgColor: bgColor,
                borderColor: borderColor,
                icon: Icons.check,
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          final containerFinder = find.byType(Container);
          final size = tester.getSize(containerFinder);

          expect(size.width, 18.0);
          expect(size.height, 18.0);
        });
      });
    });

    group('ChecklistItem', () {
      const testLabel = 'Test Requirement';

      group(TestGroups.rendering, () {
        testWidgets('renders label correctly', (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              const ChecklistItem(label: testLabel, isSatisfied: false),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          TestHelpers.expectTextOnce(testLabel);
        });

        testWidgets('renders check icon when satisfied', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              const ChecklistItem(label: 'Requirement', isSatisfied: true),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          expect(find.byIcon(Icons.check), findsOneWidget);
        });

        testWidgets('does not render check icon when not satisfied', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              const ChecklistItem(label: 'Requirement', isSatisfied: false),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          expect(find.byIcon(Icons.check), findsNothing);
        });

        testWidgets('renders as Row with Icon and Text', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              const ChecklistItem(label: 'Requirement', isSatisfied: true),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          expect(find.byType(Row), findsOneWidget);
          expect(find.byType(Icon), findsOneWidget);
          expect(find.byType(Text), findsOneWidget);
        });
      });

      group(TestGroups.behavior, () {
        testWidgets('has correct semantics when satisfied', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              const ChecklistItem(label: testLabel, isSatisfied: true),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          final semantics = tester.getSemantics(find.byType(ChecklistItem));
          expect(
            semantics.getSemanticsData().hasAction(SemanticsAction.tap),
            isFalse,
          );
        });

        testWidgets('has correct semantics label', (WidgetTester tester) async {
          await tester.pumpWidget(
            createComponentTestWidget(
              const ChecklistItem(label: testLabel, isSatisfied: false),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          TestHelpers.expectTextOnce(testLabel);
        });
      });
    });
  });
}
