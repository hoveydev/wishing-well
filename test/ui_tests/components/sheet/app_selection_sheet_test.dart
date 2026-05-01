import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/sheet/app_selection_sheet.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AppSheetHeader', () {
    group(TestGroups.initialState, () {
      testWidgets('renders title text', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const AppSheetHeader(title: 'Test Title'),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Test Title');
      });

      testWidgets('renders handle bar container', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const AppSheetHeader(title: 'Test Title'),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final headerFinder = find.byType(AppSheetHeader);
        final handleBarFinder = find.descendant(
          of: headerFinder,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container &&
                widget.margin == const EdgeInsets.only(top: 12),
          ),
        );
        expect(handleBarFinder, findsOneWidget);
      });

      testWidgets('handle bar has correct margin', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const AppSheetHeader(title: 'Test Title'),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final headerFinder = find.byType(AppSheetHeader);
        final containerFinder = find.descendant(
          of: headerFinder,
          matching: find.byType(Container),
        );
        final container = tester.widget<Container>(containerFinder.first);
        expect(container.margin, const EdgeInsets.only(top: 12));
      });

      testWidgets('uses titleMedium text style', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const AppSheetHeader(title: 'My Sheet'),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textWidget = tester.widget<Text>(find.text('My Sheet'));
        final context = tester.element(find.text('My Sheet'));
        expect(textWidget.style, Theme.of(context).textTheme.titleMedium);
      });

      testWidgets('renders as StatelessWidget', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const AppSheetHeader(title: 'Test Title'),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppSheetHeader), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('title text reflects passed string', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const AppSheetHeader(title: 'Custom Title'),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Custom Title');
        expect(find.text('Other Title'), findsNothing);
      });
    });
  });

  group('AppSelectionSheet', () {
    group(TestGroups.initialState, () {
      testWidgets('show() opens a modal bottom sheet', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AppSelectionSheet.show(
                  context: context,
                  builder: (context) => const SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [AppSheetHeader(title: 'Sheet Content')],
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Sheet Content');
      });

      testWidgets('show() sheet has Material wrapper', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AppSelectionSheet.show(
                  context: context,
                  builder: (context) => const SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [AppSheetHeader(title: 'Sheet')],
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Material), findsWidgets);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('show() returns value popped from navigator', (
        WidgetTester tester,
      ) async {
        String? result;

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await AppSelectionSheet.show<String>(
                    context: context,
                    builder: (context) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppSheetHeader(title: 'Sheet'),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop('hello'),
                            child: const Text('Pop'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Pop'));
        await TestHelpers.pumpAndSettle(tester);

        expect(result, 'hello');
      });

      testWidgets('show() can reopen after closing', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AppSelectionSheet.show(
                  context: context,
                  builder: (context) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppSheetHeader(title: 'Sheet'),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);
        expect(find.text('Sheet'), findsOneWidget);

        await tester.tap(find.text('Close'));
        await TestHelpers.pumpAndSettle(tester);
        expect(find.text('Sheet'), findsNothing);

        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);
        expect(find.text('Sheet'), findsOneWidget);
      });
    });
  });
}
