import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:wishing_well/components/dotted_border_config.dart';

void main() {
  group('DottedBorderConfig', () {
    const testColor = Color(0xFF000000);
    const testStrokeWidth = 3.0;
    const testBorderPadding = EdgeInsets.all(2.0);
    const testDashPattern = [15.0, 8.0];

    Widget createTestWidget(Widget child) =>
        MaterialApp(home: Scaffold(body: child));

    group('standard method', () {
      testWidgets('creates configuration with default parameters', (
        WidgetTester tester,
      ) async {
        final config = DottedBorderConfig.standard(color: testColor);

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, 2.0);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.0)); // 2.0 / 2
      });

      testWidgets('creates configuration with custom stroke width', (
        WidgetTester tester,
      ) async {
        final config = DottedBorderConfig.standard(
          color: testColor,
          strokeWidth: testStrokeWidth,
        );

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, testStrokeWidth);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.5)); // 3.0 / 2
      });
    });

    group('circularAvatar method', () {
      testWidgets('creates configuration with default parameters', (
        WidgetTester tester,
      ) async {
        final config = DottedBorderConfig.circularAvatar(color: testColor);

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, 2.0);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.0)); // 2.0 / 2
      });

      testWidgets('creates configuration with custom stroke width', (
        WidgetTester tester,
      ) async {
        final config = DottedBorderConfig.circularAvatar(
          color: testColor,
          strokeWidth: testStrokeWidth,
        );

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, testStrokeWidth);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.5)); // 3.0 / 2
      });
    });

    group('minimal method', () {
      testWidgets('creates configuration with default parameters', (
        WidgetTester tester,
      ) async {
        final config = DottedBorderConfig.minimal(color: testColor);

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, 2.0);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.0)); // 2.0 / 2
      });

      testWidgets('creates configuration with custom stroke width', (
        WidgetTester tester,
      ) async {
        final config = DottedBorderConfig.minimal(
          color: testColor,
          strokeWidth: testStrokeWidth,
        );

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, testStrokeWidth);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.5)); // 3.0 / 2
      });
    });

    group('automatic method', () {
      testWidgets('creates configuration with default parameters', (
        WidgetTester tester,
      ) async {
        final config = DottedBorderConfig.automatic(color: testColor);

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, 2.0);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.0)); // 2.0 / 2
      });

      testWidgets('creates configuration with custom stroke width', (
        WidgetTester tester,
      ) async {
        final config = DottedBorderConfig.automatic(
          color: testColor,
          strokeWidth: testStrokeWidth,
        );

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, testStrokeWidth);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.5)); // 3.0 / 2
      });
    });

    group('custom method', () {
      testWidgets(
        'creates configuration with default border padding (strokeWidth/2)',
        (WidgetTester tester) async {
          final config = DottedBorderConfig.custom(color: testColor);

          expect(config.dashPattern, [10, 5]);
          expect(config.strokeWidth, 2.0);
          expect(config.color, testColor);
          expect(config.borderPadding, const EdgeInsets.all(1.0)); // 2.0 / 2
        },
      );

      testWidgets('creates configuration with custom border padding', (
        WidgetTester tester,
      ) async {
        final config = DottedBorderConfig.custom(
          color: testColor,
          dashPattern: testDashPattern,
          strokeWidth: testStrokeWidth,
          borderPadding: testBorderPadding,
        );

        expect(config.dashPattern, testDashPattern);
        expect(config.strokeWidth, testStrokeWidth);
        expect(config.color, testColor);
        expect(config.borderPadding, testBorderPadding);
      });

      testWidgets('creates configuration with custom stroke'
          'width and default border padding', (WidgetTester tester) async {
        final config = DottedBorderConfig.custom(
          color: testColor,
          strokeWidth: testStrokeWidth,
        );

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, testStrokeWidth);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.5)); // 3.0 / 2
      });
    });

    group('Border padding calculation verification', () {
      testWidgets(
        'all predefined methods calculate borderPadding as strokeWidth/2',
        (WidgetTester tester) async {
          const strokeWidths = [1.0, 2.0, 4.0, 5.5, 8.0];

          for (final strokeWidth in strokeWidths) {
            final expectedPadding = EdgeInsets.all(strokeWidth / 2);

            final standardConfig = DottedBorderConfig.standard(
              color: testColor,
              strokeWidth: strokeWidth,
            );
            final circularAvatarConfig = DottedBorderConfig.circularAvatar(
              color: testColor,
              strokeWidth: strokeWidth,
            );
            final minimalConfig = DottedBorderConfig.minimal(
              color: testColor,
              strokeWidth: strokeWidth,
            );
            final automaticConfig = DottedBorderConfig.automatic(
              color: testColor,
              strokeWidth: strokeWidth,
            );

            expect(
              standardConfig.borderPadding,
              expectedPadding,
              reason: 'standard method failed for strokeWidth $strokeWidth',
            );
            expect(
              circularAvatarConfig.borderPadding,
              expectedPadding,
              reason:
                  'circularAvatar method failed for strokeWidth $strokeWidth',
            );
            expect(
              minimalConfig.borderPadding,
              expectedPadding,
              reason: 'minimal method failed for strokeWidth $strokeWidth',
            );
            expect(
              automaticConfig.borderPadding,
              expectedPadding,
              reason: 'automatic method failed for strokeWidth $strokeWidth',
            );
          }
        },
      );
    });

    group('Integration with DottedBorder', () {
      testWidgets('circularAvatar config works with DottedBorder widget', (
        WidgetTester tester,
      ) async {
        final dottedBorderWidget = DottedBorder(
          options: DottedBorderConfig.circularAvatar(color: testColor),
          child: const SizedBox(width: 50, height: 50, child: Text('Test')),
        );

        await tester.pumpWidget(createTestWidget(dottedBorderWidget));

        expect(find.byType(DottedBorder), findsOneWidget);
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('standard config works with DottedBorder widget', (
        WidgetTester tester,
      ) async {
        final dottedBorderWidget = DottedBorder(
          options: DottedBorderConfig.standard(color: testColor),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('Test Container')),
          ),
        );

        await tester.pumpWidget(createTestWidget(dottedBorderWidget));

        expect(find.byType(DottedBorder), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
        expect(find.text('Test Container'), findsOneWidget);
      });

      testWidgets('minimal config works with DottedBorder widget', (
        WidgetTester tester,
      ) async {
        final dottedBorderWidget = DottedBorder(
          options: DottedBorderConfig.minimal(color: testColor),
          child: const Icon(Icons.star, size: 30),
        );

        await tester.pumpWidget(createTestWidget(dottedBorderWidget));

        expect(find.byType(DottedBorder), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('automatic config works with DottedBorder widget', (
        WidgetTester tester,
      ) async {
        final dottedBorderWidget = DottedBorder(
          options: DottedBorderConfig.automatic(color: testColor),
          child: const Text('Automatic Padding Border'),
        );

        await tester.pumpWidget(createTestWidget(dottedBorderWidget));

        expect(find.byType(DottedBorder), findsOneWidget);
        expect(find.text('Automatic Padding Border'), findsOneWidget);
      });

      testWidgets(
        'custom config with custom dash pattern works with DottedBorder',
        (WidgetTester tester) async {
          final dottedBorderWidget = DottedBorder(
            options: DottedBorderConfig.custom(
              color: testColor,
              dashPattern: [20, 10],
              strokeWidth: 4,
            ),
            child: const SizedBox(
              width: 80,
              height: 80,
              child: Center(child: Text('Custom')),
            ),
          );

          await tester.pumpWidget(createTestWidget(dottedBorderWidget));

          expect(find.byType(DottedBorder), findsOneWidget);
          expect(find.byType(SizedBox), findsOneWidget);
          expect(find.text('Custom'), findsOneWidget);
        },
      );
    });

    group('Consistency across methods', () {
      testWidgets('all methods create valid CircularDottedBorderOptions', (
        WidgetTester tester,
      ) async {
        final configs = [
          DottedBorderConfig.standard(color: testColor),
          DottedBorderConfig.circularAvatar(color: testColor),
          DottedBorderConfig.minimal(color: testColor),
          DottedBorderConfig.automatic(color: testColor),
          DottedBorderConfig.custom(color: testColor),
        ];

        for (final config in configs) {
          expect(config, isA<CircularDottedBorderOptions>());
          expect(config.color, testColor);
          expect(config.dashPattern, isA<List<double>>());
          expect(config.strokeWidth, isA<double>());
          expect(config.strokeWidth, greaterThan(0));
          expect(config.borderPadding, isA<EdgeInsets>());
        }
      });

      testWidgets('different colors produce different visual results', (
        WidgetTester tester,
      ) async {
        const redColor = Color(0xFFFF0000);
        const blueColor = Color(0xFF0000FF);

        final redConfig = DottedBorderConfig.standard(color: redColor);
        final blueConfig = DottedBorderConfig.standard(color: blueColor);

        expect(redConfig.color, redColor);
        expect(blueConfig.color, blueColor);
        expect(redConfig.color, isNot(equals(blueConfig.color)));
      });

      testWidgets('predefined methods all have the same'
          'behavior for equivalent parameters', (WidgetTester tester) async {
        final configs = [
          DottedBorderConfig.standard(
            color: testColor,
            strokeWidth: testStrokeWidth,
          ),
          DottedBorderConfig.circularAvatar(
            color: testColor,
            strokeWidth: testStrokeWidth,
          ),
          DottedBorderConfig.minimal(
            color: testColor,
            strokeWidth: testStrokeWidth,
          ),
          DottedBorderConfig.automatic(
            color: testColor,
            strokeWidth: testStrokeWidth,
          ),
        ];

        for (final config in configs) {
          expect(config.strokeWidth, testStrokeWidth);
          expect(config.color, testColor);
          expect(config.dashPattern, [10, 5]);
          expect(config.borderPadding, const EdgeInsets.all(1.5)); // 3.0 / 2
        }
      });
    });
  });
}
