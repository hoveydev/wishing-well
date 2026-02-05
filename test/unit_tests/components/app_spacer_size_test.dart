import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/components/throbber/app_throbber_size.dart';

import '../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppSpacerSize', () {
    group(TestGroups.initialState, () {
      test('has correct xsmall size value', () {
        expect(AppSpacerSize.xsmall, 4.0);
      });

      test('has correct small size value', () {
        expect(AppSpacerSize.small, 8.0);
      });

      test('has correct medium size value', () {
        expect(AppSpacerSize.medium, 16.0);
      });

      test('has correct large size value', () {
        expect(AppSpacerSize.large, 24.0);
      });

      test('has correct xlarge size value', () {
        expect(AppSpacerSize.xlarge, 48.0);
      });
    });

    group(TestGroups.validation, () {
      test('sizes follow consistent doubling pattern', () {
        expect(AppSpacerSize.small, AppSpacerSize.xsmall * 2);
        expect(AppSpacerSize.medium, AppSpacerSize.small * 2);
        expect(AppSpacerSize.large, AppSpacerSize.medium * 1.5);
        expect(AppSpacerSize.xlarge, AppSpacerSize.large * 2);
      });

      test('all sizes are positive values', () {
        expect(AppSpacerSize.xsmall, greaterThan(0));
        expect(AppSpacerSize.small, greaterThan(0));
        expect(AppSpacerSize.medium, greaterThan(0));
        expect(AppSpacerSize.large, greaterThan(0));
        expect(AppSpacerSize.xlarge, greaterThan(0));
      });

      test('sizes are in ascending order', () {
        expect(AppSpacerSize.xsmall, lessThan(AppSpacerSize.small));
        expect(AppSpacerSize.small, lessThan(AppSpacerSize.medium));
        expect(AppSpacerSize.medium, lessThan(AppSpacerSize.large));
        expect(AppSpacerSize.large, lessThan(AppSpacerSize.xlarge));
      });

      test('matches AppThrobberSize values for consistency', () {
        expect(AppSpacerSize.xsmall, AppThrobberSize.xsmall);
        expect(AppSpacerSize.small, AppThrobberSize.small);
        expect(AppSpacerSize.medium, AppThrobberSize.medium);
        expect(AppSpacerSize.large, AppThrobberSize.large);
        expect(AppSpacerSize.xlarge, AppThrobberSize.xlarge);
      });
    });
  });
}
