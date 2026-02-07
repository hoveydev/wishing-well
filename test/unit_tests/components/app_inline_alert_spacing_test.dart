import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_spacing.dart';

import '../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppInlineAlertSpacing', () {
    group(TestGroups.initialState, () {
      test('has correct input padding value', () {
        expect(
          AppInlineAlertSpacing.inputPadding,
          const EdgeInsets.only(left: 12),
        );
      });
    });

    group(TestGroups.validation, () {
      test('input padding is EdgeInsetsGeometry type', () {
        expect(AppInlineAlertSpacing.inputPadding, isA<EdgeInsetsGeometry>());
      });

      test('input padding resolves correctly for LTR', () {
        final resolved = AppInlineAlertSpacing.inputPadding.resolve(
          TextDirection.ltr,
        );
        expect(resolved.left, 12.0);
        expect(resolved.top, 0.0);
        expect(resolved.right, 0.0);
        expect(resolved.bottom, 0.0);
      });

      test('input padding resolves correctly for RTL', () {
        final resolved = AppInlineAlertSpacing.inputPadding.resolve(
          TextDirection.rtl,
        );
        expect(resolved.left, 12.0);
        expect(resolved.top, 0.0);
        expect(resolved.right, 0.0);
        expect(resolved.bottom, 0.0);
      });

      test('input padding has non-zero horizontal value', () {
        final resolved = AppInlineAlertSpacing.inputPadding.resolve(
          TextDirection.ltr,
        );
        expect(resolved.horizontal, 12.0);
      });

      test('input padding has zero vertical value', () {
        final resolved = AppInlineAlertSpacing.inputPadding.resolve(
          TextDirection.ltr,
        );
        expect(resolved.vertical, 0.0);
      });
    });
  });
}
