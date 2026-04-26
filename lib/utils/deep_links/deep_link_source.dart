import 'package:app_links/app_links.dart';

typedef InitialLinkProvider = Future<Uri?> Function();
typedef LinkStreamProvider = Stream<Uri?> Function();

class DeepLinkSource {
  const DeepLinkSource({required this.initial, required this.stream});

  factory DeepLinkSource.platform() => DeepLinkSource(
    initial: () async => await AppLinks().getInitialLink(),
    stream: () => AppLinks().uriLinkStream.cast<Uri?>(),
  );
  final InitialLinkProvider initial;
  final LinkStreamProvider stream;
}
