import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/input/app_input_type.dart';

import '../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppInputType', () {
    group(TestGroups.initialState, () {
      test('has four enum values', () {
        expect(AppInputType.values.length, 4);
      });

      test('contains text value', () {
        expect(AppInputType.values.contains(AppInputType.text), isTrue);
      });

      test('contains email value', () {
        expect(AppInputType.values.contains(AppInputType.email), isTrue);
      });

      test('contains password value', () {
        expect(AppInputType.values.contains(AppInputType.password), isTrue);
      });

      test('contains phone value', () {
        expect(AppInputType.values.contains(AppInputType.phone), isTrue);
      });
    });

    group(TestGroups.validation, () {
      test('enum values have correct string representation', () {
        expect(AppInputType.text.toString(), 'AppInputType.text');
        expect(AppInputType.email.toString(), 'AppInputType.email');
        expect(AppInputType.password.toString(), 'AppInputType.password');
        expect(AppInputType.phone.toString(), 'AppInputType.phone');
      });

      test('enum values are unique', () {
        const values = AppInputType.values;
        final uniqueValues = values.toSet();
        expect(values.length, uniqueValues.length);
      });

      test('text is first value', () {
        expect(AppInputType.values.first, AppInputType.text);
      });

      test('phone is last value', () {
        expect(AppInputType.values.last, AppInputType.phone);
      });

      test('has expected order for form inputs', () {
        final expectedOrder = [
          AppInputType.text,
          AppInputType.email,
          AppInputType.password,
          AppInputType.phone,
        ];
        expect(AppInputType.values, expectedOrder);
      });
    });
  });
}
