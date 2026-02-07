import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/button/app_button_type.dart';

import '../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppButtonType', () {
    group(TestGroups.initialState, () {
      test('has three enum values', () {
        expect(AppButtonType.values.length, 3);
      });

      test('contains primary value', () {
        expect(AppButtonType.values.contains(AppButtonType.primary), isTrue);
      });

      test('contains secondary value', () {
        expect(AppButtonType.values.contains(AppButtonType.secondary), isTrue);
      });

      test('contains tertiary value', () {
        expect(AppButtonType.values.contains(AppButtonType.tertiary), isTrue);
      });
    });

    group(TestGroups.validation, () {
      test('enum values have correct string representation', () {
        expect(AppButtonType.primary.toString(), 'AppButtonType.primary');
        expect(AppButtonType.secondary.toString(), 'AppButtonType.secondary');
        expect(AppButtonType.tertiary.toString(), 'AppButtonType.tertiary');
      });

      test('enum values are unique', () {
        const values = AppButtonType.values;
        final uniqueValues = values.toSet();
        expect(values.length, uniqueValues.length);
      });

      test('primary is first value', () {
        expect(AppButtonType.values.first, AppButtonType.primary);
      });

      test('tertiary is last value', () {
        expect(AppButtonType.values.last, AppButtonType.tertiary);
      });
    });
  });
}
