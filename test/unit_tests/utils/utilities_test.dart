import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/utils/utilities.dart';

void main() {
  group('Utilities', () {
    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });

    group('Platform Detection', () {
      test('isIOS returns true when platform is iOS', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        expect(isIOS, true);
        expect(isAndroid, false);
        expect(isMobile, true);
      });

      test('isAndroid returns true when platform is Android', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;

        expect(isAndroid, true);
        expect(isIOS, false);
        expect(isMobile, true);
      });

      test('all return false for web platform', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

        expect(isIOS, false);
        expect(isAndroid, false);
        expect(isMobile, false);
      });
    });
  });
}
