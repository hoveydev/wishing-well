import 'package:uni_links/uni_links.dart';

typedef InitialLinkProvider = Future<Uri?> Function();
typedef LinkStreamProvider = Stream<Uri?> Function();

class DeepLinkSource {
  final InitialLinkProvider initial;
  final LinkStreamProvider stream;

  const DeepLinkSource({required this.initial, required this.stream});

  // coverage:ignore-start
  factory DeepLinkSource.platform() =>
      DeepLinkSource(initial: getInitialUri, stream: () => uriLinkStream);
  // coverage:ignore-end
}
