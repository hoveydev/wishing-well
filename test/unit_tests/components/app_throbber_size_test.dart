import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/throbber/app_throbber_size.dart';

import '../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppThrobberSize', () {
    group(TestGroups.initialState, () {
      test('has correct xsmall size value', () {
        expect(AppThrobberSize.xsmall, 4.0);
      });

      test('has correct small size value', () {
        expect(AppThrobberSize.small, 8.0);
      });

      test('has correct medium size value', () {
        expect(AppThrobberSize.medium, 16.0);
      });

      test('has correct large size value', () {
        expect(AppThrobberSize.large, 24.0);
      });

      test('has correct xlarge size value', () {
        expect(AppThrobberSize.xlarge, 48.0);
      });
    });

    group(TestGroups.validation, () {
      test('sizes follow consistent doubling pattern', () {
        expect(AppThrobberSize.small, AppThrobberSize.xsmall * 2);
        expect(AppThrobberSize.medium, AppThrobberSize.small * 2);
        expect(AppThrobberSize.large, AppThrobberSize.medium * 1.5);
        expect(AppThrobberSize.xlarge, AppThrobberSize.large * 2);
      });

      test('all sizes are positive values', () {
        expect(AppThrobberSize.xsmall, greaterThan(0));
        expect(AppThrobberSize.small, greaterThan(0));
        expect(AppThrobberSize.medium, greaterThan(0));
        expect(AppThrobberSize.large, greaterThan(0));
        expect(AppThrobberSize.xlarge, greaterThan(0));
      });

      test('sizes are in ascending order', () {
        expect(AppThrobberSize.xsmall, lessThan(AppThrobberSize.small));
        expect(AppThrobberSize.small, lessThan(AppThrobberSize.medium));
        expect(AppThrobberSize.medium, lessThan(AppThrobberSize.large));
        expect(AppThrobberSize.large, lessThan(AppThrobberSize.xlarge));
      });
    });
  });
}
