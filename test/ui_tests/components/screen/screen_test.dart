import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('Screen', () {
    group(TestGroups.rendering, () {
      testWidgets('renders with children', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: const Screen(children: [Text('Test Content')]),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Test Content'), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('renders with appBar', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: Screen(
              appBar: AppBar(title: const Text('Test AppBar')),
              children: const [Text('Content')],
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Test AppBar'), findsOneWidget);
      });

      testWidgets('renders with empty children list', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const Screen(children: [])),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Screen), findsOneWidget);
      });

      testWidgets('has SingleChildScrollView for scrolling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: const Screen(children: [Text('Scrollable Content')]),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('has SafeArea wrapper', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: const Screen(children: [Text('Content')]),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(SafeArea), findsOneWidget);
      });
    });
  });
}
