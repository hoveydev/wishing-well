import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/throbber/app_throbber.dart';
import 'package:wishing_well/components/throbber/app_throbber_size.dart';

import '../../../../testing_resources/helpers/create_test_widget.dart';

void main() {
  group('AppThrobber', () {
    testWidgets('xsmall constructor applies correct size', (tester) async {
      await tester.pumpWidget(createTestWidget(const AppThrobber.xsmall()));
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppThrobberSize.xsmall);
      expect(sizedBox.width, AppThrobberSize.xsmall);
    });

    testWidgets('small constructor applies correct size', (tester) async {
      await tester.pumpWidget(createTestWidget(const AppThrobber.small()));
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppThrobberSize.small);
      expect(sizedBox.width, AppThrobberSize.small);
    });

    testWidgets('medium constructor applies correct size', (tester) async {
      await tester.pumpWidget(createTestWidget(const AppThrobber.medium()));
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppThrobberSize.medium);
      expect(sizedBox.width, AppThrobberSize.medium);
    });

    testWidgets('large constructor applies correct size', (tester) async {
      await tester.pumpWidget(createTestWidget(const AppThrobber.large()));
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppThrobberSize.large);
      expect(sizedBox.width, AppThrobberSize.large);
    });

    testWidgets('xlarge constructor applies correct size', (tester) async {
      await tester.pumpWidget(createTestWidget(const AppThrobber.xlarge()));
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppThrobberSize.xlarge);
      expect(sizedBox.width, AppThrobberSize.xlarge);
    });

    testWidgets('renders CustomPaint for custom spinner', (tester) async {
      await tester.pumpWidget(createTestWidget(const AppThrobber.medium()));
      expect(
        find.descendant(
          of: find.byType(AppThrobber),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
    });

    testWidgets('renders AnimatedBuilder for animation', (tester) async {
      await tester.pumpWidget(createTestWidget(const AppThrobber.medium()));
      expect(
        find.descendant(
          of: find.byType(AppThrobber),
          matching: find.byType(AnimatedBuilder),
        ),
        findsOneWidget,
      );
    });

    testWidgets('animation continues over time', (tester) async {
      await tester.pumpWidget(createTestWidget(const AppThrobber.medium()));
      final throbberFinder = find.byType(AppThrobber);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(throbberFinder, findsOneWidget);
    });
  });
}
