import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/theme/app_spacer_size.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

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
        expect(AppSpacerSize.medium, 12.0);
      });

      test('has correct large size value', () {
        expect(AppSpacerSize.large, 16.0);
      });

      test('has correct xlarge size value', () {
        expect(AppSpacerSize.xlarge, 20.0);
      });

      test('has correct xxlarge size value', () {
        expect(AppSpacerSize.xxlarge, 24.0);
      });

      test('has correct xxxlarge size value', () {
        expect(AppSpacerSize.xxxlarge, 32.0);
      });

      test('has correct huge size value', () {
        expect(AppSpacerSize.huge, 48.0);
      });
    });

    group(TestGroups.validation, () {
      test('all sizes are positive values', () {
        expect(AppSpacerSize.xsmall, greaterThan(0));
        expect(AppSpacerSize.small, greaterThan(0));
        expect(AppSpacerSize.medium, greaterThan(0));
        expect(AppSpacerSize.large, greaterThan(0));
        expect(AppSpacerSize.xlarge, greaterThan(0));
        expect(AppSpacerSize.xxlarge, greaterThan(0));
        expect(AppSpacerSize.xxxlarge, greaterThan(0));
        expect(AppSpacerSize.huge, greaterThan(0));
      });

      test('sizes are in ascending order', () {
        expect(AppSpacerSize.xsmall, lessThan(AppSpacerSize.small));
        expect(AppSpacerSize.small, lessThan(AppSpacerSize.medium));
        expect(AppSpacerSize.medium, lessThan(AppSpacerSize.large));
        expect(AppSpacerSize.large, lessThan(AppSpacerSize.xlarge));
        expect(AppSpacerSize.xlarge, lessThan(AppSpacerSize.xxlarge));
        expect(AppSpacerSize.xxlarge, lessThan(AppSpacerSize.xxxlarge));
        expect(AppSpacerSize.xxxlarge, lessThan(AppSpacerSize.huge));
      });
    });
  });
}
