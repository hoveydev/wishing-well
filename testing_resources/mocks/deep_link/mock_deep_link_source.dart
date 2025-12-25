import 'dart:async';

import 'package:wishing_well/utils/deep_links/deep_link_source.dart';

class MockDeepLinkSource extends DeepLinkSource {
  final StreamController<Uri?> _controller = StreamController<Uri?>.broadcast();
  final Uri? _initialUri;

  MockDeepLinkSource({Uri? initialUri})
    : _initialUri = initialUri,
      super(
        initial: () async => initialUri,
        stream: () => const Stream.empty(),
      );

  @override
  Future<Uri?> Function() get initial =>
      () async => _initialUri;

  @override
  Stream<Uri?> Function() get stream =>
      () => _controller.stream;

  /// Push a deep link while the app is running
  void emit(Uri uri) {
    _controller.add(uri);
  }

  void dispose() {
    _controller.close();
  }
}
