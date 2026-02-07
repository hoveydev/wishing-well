import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';

import '../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppMenuBarType', () {
    group(TestGroups.initialState, () {
      test('has three enum values', () {
        expect(AppMenuBarType.values.length, 3);
      });

      test('contains main value', () {
        expect(AppMenuBarType.values.contains(AppMenuBarType.main), isTrue);
      });

      test('contains close value', () {
        expect(AppMenuBarType.values.contains(AppMenuBarType.close), isTrue);
      });

      test('contains dismiss value', () {
        expect(AppMenuBarType.values.contains(AppMenuBarType.dismiss), isTrue);
      });
    });

    group(TestGroups.validation, () {
      test('enum values have correct string representation', () {
        expect(AppMenuBarType.main.toString(), 'AppMenuBarType.main');
        expect(AppMenuBarType.close.toString(), 'AppMenuBarType.close');
        expect(AppMenuBarType.dismiss.toString(), 'AppMenuBarType.dismiss');
      });

      test('enum values are unique', () {
        const values = AppMenuBarType.values;
        final uniqueValues = values.toSet();
        expect(values.length, uniqueValues.length);
      });

      test('main is first value', () {
        expect(AppMenuBarType.values.first, AppMenuBarType.main);
      });

      test('dismiss is last value', () {
        expect(AppMenuBarType.values.last, AppMenuBarType.dismiss);
      });

      test('has expected order for menu bar types', () {
        final expectedOrder = [
          AppMenuBarType.main,
          AppMenuBarType.close,
          AppMenuBarType.dismiss,
        ];
        expect(AppMenuBarType.values, expectedOrder);
      });
    });
  });
}
