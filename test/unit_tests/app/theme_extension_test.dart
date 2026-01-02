import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';

void main() {
  group('color theme extension', () {
    group('ColorSchemeExtension.copyWith', () {
      test('overrides provided values', () {
        const original = ColorSchemeExtension(
          success: Color(0xFF00FF00),
          onSuccess: Color(0xFFFFFFFF),
        );

        final updated = original.copyWith(success: const Color(0xFF0000FF));

        expect(updated.success, const Color(0xFF0000FF));
        expect(updated.onSuccess, const Color(0xFFFFFFFF));
      });

      test('keeps original values when null', () {
        const original = ColorSchemeExtension(
          success: Color(0xFF00FF00),
          onSuccess: Color(0xFFFFFFFF),
        );

        final updated = original.copyWith();

        expect(updated.success, original.success);
        expect(updated.onSuccess, original.onSuccess);
      });
    });

    group('ColorSchemeExtension.lerp', () {
      const a = ColorSchemeExtension(
        success: Color(0xFF000000),
        onSuccess: Color(0xFFFFFFFF),
      );

      const b = ColorSchemeExtension(
        success: Color(0xFFFFFFFF),
        onSuccess: Color(0xFF000000),
      );

      test('returns start when t = 0', () {
        final result = a.lerp(b, 0.0);
        expect(result.success, a.success);
        expect(result.onSuccess, a.onSuccess);
      });

      test('returns end when t = 1', () {
        final result = a.lerp(b, 1.0);
        expect(result.success, b.success);
        expect(result.onSuccess, b.onSuccess);
      });

      test('returns this when other is different type', () {
        final result = a.lerp(null, 0.5);
        expect(result, a);
      });
    });
  });
}
