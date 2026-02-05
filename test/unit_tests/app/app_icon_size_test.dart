import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/theme/app_icon_size.dart';
import '../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppIconSize', () {
    group(TestGroups.behavior, () {
      group('fixed sizes', () {
        test('xsmall returns correct value', () {
          const iconSize = AppIconSize();
          expect(iconSize.xsmall, 10.0);
        });

        test('small returns correct value', () {
          const iconSize = AppIconSize();
          expect(iconSize.small, 14.0);
        });

        test('medium returns correct value', () {
          const iconSize = AppIconSize();
          expect(iconSize.medium, 18.0);
        });
      });

      group('large without sectionHeight', () {
        test('large returns default value when sectionHeight is null', () {
          const iconSize = AppIconSize();
          expect(iconSize.xlarge, 60.0);
        });
      });

      group('large with sectionHeight', () {
        test('large calculates based on sectionHeight', () {
          const iconSize = AppIconSize(sectionHeight: 1000);
          expect(iconSize.xlarge, 120.0);
        });

        test('large calculates correctly for different heights', () {
          const iconSize500 = AppIconSize(sectionHeight: 500);
          expect(iconSize500.xlarge, 60.0);

          const iconSize1000 = AppIconSize(sectionHeight: 1000);
          expect(iconSize1000.xlarge, 120.0);

          const iconSize2000 = AppIconSize(sectionHeight: 2000);
          expect(iconSize2000.xlarge, 240.0);
        });

        test('large uses 0.12 ratio for calculation', () {
          const iconSize = AppIconSize(sectionHeight: 833.33);
          expect(iconSize.xlarge, closeTo(100.0, 0.1));
        });
      });

      group('fixed sizes remain constant', () {
        test('xsmall does not change with sectionHeight', () {
          const iconSize = AppIconSize(sectionHeight: 1000);
          expect(iconSize.xsmall, 10.0);
        });

        test('small does not change with sectionHeight', () {
          const iconSize = AppIconSize(sectionHeight: 1000);
          expect(iconSize.small, 14.0);
        });

        test('medium does not change with sectionHeight', () {
          const iconSize = AppIconSize(sectionHeight: 1000);
          expect(iconSize.medium, 18.0);
        });
      });
    });
  });
}
