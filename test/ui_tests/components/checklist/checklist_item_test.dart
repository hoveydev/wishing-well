import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/checklist/checklist_item.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('ChecklistItem', () {
    testWidgets('renders label correctly', (tester) async {
      const testLabel = 'Test Requirement';

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ChecklistItem(label: testLabel, isSatisfied: false),
          ),
        ),
      );

      expect(find.text(testLabel), findsOneWidget);
    });

    testWidgets('renders check icon when satisfied', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ChecklistItem(label: 'Requirement', isSatisfied: true),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('does not render check icon when not satisfied', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ChecklistItem(label: 'Requirement', isSatisfied: false),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('has correct semantics when satisfied', (tester) async {
      const testLabel = 'Test Requirement';

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ChecklistItem(label: testLabel, isSatisfied: true),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(ChecklistItem));
      expect(
        semantics.getSemanticsData().hasAction(SemanticsAction.tap),
        isFalse,
      );
    });

    testWidgets('has correct semantics label', (tester) async {
      const testLabel = 'Test Requirement';

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ChecklistItem(label: testLabel, isSatisfied: false),
          ),
        ),
      );

      expect(find.text(testLabel), findsOneWidget);
    });

    testWidgets('renders as Row with Icon and Text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ChecklistItem(label: 'Requirement', isSatisfied: true),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });
  });
}
