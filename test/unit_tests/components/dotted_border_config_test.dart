import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:wishing_well/components/dotted_border_config.dart';

import '../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('DottedBorderConfig', () {
    const testColor = Color(0xFF000000);
    const testStrokeWidth = 3.0;
    const testBorderPadding = EdgeInsets.all(2.0);
    const testDashPattern = [15.0, 8.0];

    group(TestGroups.initialState, () {
      test('creates standard configuration with default parameters', () {
        final config = DottedBorderConfig.standard(color: testColor);

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, 2.0);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.0)); // 2.0 / 2
      });

      test('creates circularAvatar configuration with default parameters', () {
        final config = DottedBorderConfig.circularAvatar(color: testColor);

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, 2.0);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.0)); // 2.0 / 2
      });

      test('creates minimal configuration with default parameters', () {
        final config = DottedBorderConfig.minimal(color: testColor);

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, 2.0);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.0)); // 2.0 / 2
      });

      test('creates automatic configuration with default parameters', () {
        final config = DottedBorderConfig.automatic(color: testColor);

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, 2.0);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.0)); // 2.0 / 2
      });
    });

    group(TestGroups.behavior, () {
      test('standard method accepts custom stroke width', () {
        final config = DottedBorderConfig.standard(
          color: testColor,
          strokeWidth: testStrokeWidth,
        );

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, testStrokeWidth);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.5)); // 3.0 / 2
      });

      test('circularAvatar method accepts custom stroke width', () {
        final config = DottedBorderConfig.circularAvatar(
          color: testColor,
          strokeWidth: testStrokeWidth,
        );

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, testStrokeWidth);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.5)); // 3.0 / 2
      });

      test('minimal method accepts custom stroke width', () {
        final config = DottedBorderConfig.minimal(
          color: testColor,
          strokeWidth: testStrokeWidth,
        );

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, testStrokeWidth);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.5)); // 3.0 / 2
      });

      test('automatic method accepts custom stroke width', () {
        final config = DottedBorderConfig.automatic(
          color: testColor,
          strokeWidth: testStrokeWidth,
        );

        expect(config.dashPattern, [10, 5]);
        expect(config.strokeWidth, testStrokeWidth);
        expect(config.color, testColor);
        expect(config.borderPadding, const EdgeInsets.all(1.5)); // 3.0 / 2
      });

      test('custom method accepts all parameters', () {
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

      test('custom method uses default border padding when not provided', () {
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

    group(TestGroups.validation, () {
      test(
        'all predefined methods calculate borderPadding as strokeWidth/2',
        () {
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

      test('all methods create valid CircularDottedBorderOptions', () {
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

      test('different colors produce different configurations', () {
        const redColor = Color(0xFFFF0000);
        const blueColor = Color(0xFF0000FF);

        final redConfig = DottedBorderConfig.standard(color: redColor);
        final blueConfig = DottedBorderConfig.standard(color: blueColor);

        expect(redConfig.color, redColor);
        expect(blueConfig.color, blueColor);
        expect(redConfig.color, isNot(equals(blueConfig.color)));
      });

      test(
        'predefined methods have consistent behavior for equivalent parameters',
        () {
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
        },
      );
    });
  });
}
