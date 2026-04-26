import 'package:app_links/app_links.dart';

typedef InitialLinkProvider = Future<Uri?> Function();
typedef LinkStreamProvider = Stream<Uri?> Function();

class DeepLinkSource {
  const DeepLinkSource({required this.initial, required this.stream});

  factory DeepLinkSource.platform() {
    final appLinks = AppLinks();
    return DeepLinkSource(
      initial: () async => await appLinks.getInitialLink(),
      stream: () => appLinks.uriLinkStream.cast<Uri?>(),
    );
  }
  final InitialLinkProvider initial;
  final LinkStreamProvider stream;
}
