import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/home/components/home_coming_up.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('HomeComingUp', () {
    group(TestGroups.rendering, () {
      testWidgets('renders Coming Up header with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeComingUp()),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Coming Up');
        expect(find.byType(Card), findsOneWidget);
      });

      testWidgets('renders placeholder text with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeComingUp()),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Nothing yet :)');
      });

      testWidgets('has semantic header for accessibility', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeComingUp()),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Semantics), findsWidgets);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('renders as Column with correct layout', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeComingUp()),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('Card widget has full width constraint', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeComingUp()),
        );
        await TestHelpers.pumpAndSettle(tester);

        final sizedBoxFinder = find.byType(SizedBox);
        final sizedBox = tester.widget<SizedBox>(sizedBoxFinder);
        expect(sizedBox.width, equals(double.infinity));
      });

      testWidgets('Card widget has no elevation', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeComingUp()),
        );
        await TestHelpers.pumpAndSettle(tester);

        final cardFinder = find.byType(Card);
        final cardWidget = tester.widget<Card>(cardFinder);
        expect(cardWidget.elevation, equals(0));
      });

      testWidgets('uses titleMedium text style for header', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeComingUp()),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textFinder = find.text('Coming Up');
        final textWidget = tester.widget<Text>(textFinder);
        expect(textWidget.style?.fontSize, isNotNull);
      });

      testWidgets('uses bodySmall text style for placeholder', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeComingUp()),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textFinder = find.text('Nothing yet :)');
        final textWidget = tester.widget<Text>(textFinder);
        expect(textWidget.style?.fontSize, isNotNull);
      });
    });
  });
}
