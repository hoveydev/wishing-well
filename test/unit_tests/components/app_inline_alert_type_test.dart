import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';

import '../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppInlineAlertType', () {
    group(TestGroups.initialState, () {
      test('has four enum values', () {
        expect(AppInlineAlertType.values.length, 4);
      });

      test('contains info value', () {
        expect(
          AppInlineAlertType.values.contains(AppInlineAlertType.info),
          isTrue,
        );
      });

      test('contains success value', () {
        expect(
          AppInlineAlertType.values.contains(AppInlineAlertType.success),
          isTrue,
        );
      });

      test('contains warning value', () {
        expect(
          AppInlineAlertType.values.contains(AppInlineAlertType.warning),
          isTrue,
        );
      });

      test('contains error value', () {
        expect(
          AppInlineAlertType.values.contains(AppInlineAlertType.error),
          isTrue,
        );
      });
    });

    group(TestGroups.validation, () {
      test('enum values have correct string representation', () {
        expect(AppInlineAlertType.info.toString(), 'AppInlineAlertType.info');
        expect(
          AppInlineAlertType.success.toString(),
          'AppInlineAlertType.success',
        );
        expect(
          AppInlineAlertType.warning.toString(),
          'AppInlineAlertType.warning',
        );
        expect(AppInlineAlertType.error.toString(), 'AppInlineAlertType.error');
      });

      test('enum values are unique', () {
        const values = AppInlineAlertType.values;
        final uniqueValues = values.toSet();
        expect(values.length, uniqueValues.length);
      });

      test('info is first value', () {
        expect(AppInlineAlertType.values.first, AppInlineAlertType.info);
      });

      test('error is last value', () {
        expect(AppInlineAlertType.values.last, AppInlineAlertType.error);
      });

      test('has expected priority order', () {
        final expectedOrder = [
          AppInlineAlertType.info,
          AppInlineAlertType.success,
          AppInlineAlertType.warning,
          AppInlineAlertType.error,
        ];
        expect(AppInlineAlertType.values, expectedOrder);
      });
    });
  });
}
