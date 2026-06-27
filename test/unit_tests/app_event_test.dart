import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/app_event.dart';
import 'package:wishing_well/utils/deep_links/deep_link_handler.dart';

void main() {
  group('AppEvent', () {
    test('should create an instance of ShowDeepLinkError', () {
      final error = ShowDeepLinkError(DeepLinkErrorType.invalid);
      expect(error, isA<ShowDeepLinkError>());
    });
  });
}
