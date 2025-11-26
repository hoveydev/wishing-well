import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';

void main() {
  group('AppSpacer', () {
    testWidgets('AppSpacer.xsmall renders SizedBox with correct height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppSpacer.xsmall())),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppSpacerSize.xsmall);
    });

    testWidgets('AppSpacer.small renders SizedBox with correct height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppSpacer.small())),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppSpacerSize.small);
    });

    testWidgets('AppSpacer.medium renders SizedBox with correct height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppSpacer.medium())),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppSpacerSize.medium);
    });

    testWidgets('AppSpacer.large renders SizedBox with correct height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppSpacer.large())),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppSpacerSize.large);
    });

    testWidgets('AppSpacer.xlarge renders SizedBox with correct height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppSpacer.xlarge())),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppSpacerSize.xlarge);
    });

    testWidgets('All spacer sizes have different heights', (
      WidgetTester tester,
    ) async {
      final sizes = [
        AppSpacerSize.xsmall,
        AppSpacerSize.small,
        AppSpacerSize.medium,
        AppSpacerSize.large,
        AppSpacerSize.xlarge,
      ];

      // Verify all sizes are unique
      expect(sizes.toSet().length, sizes.length);

      // Verify they are in ascending order
      for (int i = 0; i < sizes.length - 1; i++) {
        expect(sizes[i], lessThan(sizes[i + 1]));
      }
    });

    testWidgets('AppSpacer renders without children', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppSpacer.medium())),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.child, isNull);
    });

    testWidgets('AppSpacer has no width constraint', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppSpacer.medium())),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, isNull);
    });

    testWidgets('Multiple AppSpacers can be used in sequence', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('First'),
                AppSpacer.small(),
                Text('Second'),
                AppSpacer.medium(),
                Text('Third'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(AppSpacer), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
      expect(find.text('Third'), findsOneWidget);
    });

    testWidgets('AppSpacer with xsmall creates minimal vertical space', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SizedBox(height: 100, child: Text('Top')),
                AppSpacer.xsmall(),
                SizedBox(height: 100, child: Text('Bottom')),
              ],
            ),
          ),
        ),
      );

      final firstBox = find.byType(SizedBox).at(0);
      final spacer = find.byType(SizedBox).at(1);
      final lastBox = find.byType(SizedBox).at(2);

      expect(firstBox, findsOneWidget);
      expect(spacer, findsOneWidget);
      expect(lastBox, findsOneWidget);
    });

    testWidgets('AppSpacer height is positive for all sizes', (
      WidgetTester tester,
    ) async {
      final spacers = [
        AppSpacer.xsmall(key: UniqueKey()),
        AppSpacer.small(key: UniqueKey()),
        AppSpacer.medium(key: UniqueKey()),
        AppSpacer.large(key: UniqueKey()),
        AppSpacer.xlarge(key: UniqueKey()),
      ];

      for (final spacer in spacers) {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: spacer)));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, greaterThan(0));
      }
    });

    testWidgets('AppSpacer accepts a key parameter', (
      WidgetTester tester,
    ) async {
      const testKey = Key('test_spacer');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppSpacer.medium(key: testKey)),
        ),
      );

      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('AppSpacer.xsmall is the smallest', (
      WidgetTester tester,
    ) async {
      final sizes = [
        AppSpacerSize.xsmall,
        AppSpacerSize.small,
        AppSpacerSize.medium,
        AppSpacerSize.large,
        AppSpacerSize.xlarge,
      ];

      expect(
        AppSpacerSize.xsmall,
        equals(sizes.reduce((a, b) => a < b ? a : b)),
      );
    });

    testWidgets('AppSpacer.xlarge is the largest', (WidgetTester tester) async {
      final sizes = [
        AppSpacerSize.xsmall,
        AppSpacerSize.small,
        AppSpacerSize.medium,
        AppSpacerSize.large,
        AppSpacerSize.xlarge,
      ];

      expect(
        AppSpacerSize.xlarge,
        equals(sizes.reduce((a, b) => a > b ? a : b)),
      );
    });
  });
}
