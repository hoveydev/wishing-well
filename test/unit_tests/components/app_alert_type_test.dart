import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_alert/app_alert_type.dart';

import '../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppAlertType', () {
    group(TestGroups.initialState, () {
      test('has four enum values', () {
        expect(AppAlertType.values.length, 4);
      });

      test('contains error value', () {
        expect(AppAlertType.values.contains(AppAlertType.error), isTrue);
      });

      test('contains warning value', () {
        expect(AppAlertType.values.contains(AppAlertType.warning), isTrue);
      });

      test('contains success value', () {
        expect(AppAlertType.values.contains(AppAlertType.success), isTrue);
      });

      test('contains info value', () {
        expect(AppAlertType.values.contains(AppAlertType.info), isTrue);
      });
    });

    group(TestGroups.validation, () {
      test('enum values have correct string representation', () {
        expect(AppAlertType.error.toString(), 'AppAlertType.error');
        expect(AppAlertType.warning.toString(), 'AppAlertType.warning');
        expect(AppAlertType.success.toString(), 'AppAlertType.success');
        expect(AppAlertType.info.toString(), 'AppAlertType.info');
      });

      test('enum values are unique', () {
        const values = AppAlertType.values;
        final uniqueValues = values.toSet();
        expect(values.length, uniqueValues.length);
      });

      test('error is first value', () {
        expect(AppAlertType.values.first, AppAlertType.error);
      });

      test('info is last value', () {
        expect(AppAlertType.values.last, AppAlertType.info);
      });

      test('has expected severity order', () {
        final expectedOrder = [
          AppAlertType.error,
          AppAlertType.warning,
          AppAlertType.success,
          AppAlertType.info,
        ];
        expect(AppAlertType.values, expectedOrder);
      });
    });
  });
}
