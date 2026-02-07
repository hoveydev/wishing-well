import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/home/components/home_header.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('HomeHeader', () {
    group(TestGroups.rendering, () {
      testWidgets('renders welcome text when firstName is not provided', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeHeader()),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Welcome!');
      });

      testWidgets('renders welcome text with firstName parameter', (
        WidgetTester tester,
      ) async {
        const firstName = 'John';

        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeHeader(firstName: firstName)),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Welcome, $firstName!');
      });

      testWidgets('uses titleLarge text style for header', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeHeader()),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textFinder = find.text('Welcome!');
        final textWidget = tester.widget<Text>(textFinder);
        expect(textWidget.style?.fontSize, isNotNull);
        expect(textWidget.style?.fontWeight, equals(FontWeight.w400));
      });
    });

    group(TestGroups.accessibility, () {
      testWidgets('has correct semantics label with firstName', (
        WidgetTester tester,
      ) async {
        const firstName = 'Jane';

        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeHeader(firstName: firstName)),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textFinder = find.text('Welcome, $firstName!');
        final textWidget = tester.widget<Text>(textFinder);
        expect(textWidget.semanticsLabel, equals('Welcome, $firstName!'));
      });

      testWidgets('handles empty firstName gracefully', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: const HomeHeader(firstName: '')),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Welcome, !');
      });
    });
  });
}
