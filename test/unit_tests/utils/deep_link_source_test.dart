import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';

void main() {
  group('DeepLinkSource', () {
    test('should create an instance of DeepLinkSource', () async {
      final source = DeepLinkSource(
        initial: () => Future.value(Uri.parse('https://exampleFuture.com')),
        stream: () => Stream.value(Uri.parse('https://exampleStream.com')),
      );
      expect(source, isA<DeepLinkSource>());

      await source.initial().then((uri) {
        expect(uri, isA<Uri>());
      });

      await for (final uri in source.stream()) {
        expect(uri, isA<Uri>());
      }
    });
  });
}
