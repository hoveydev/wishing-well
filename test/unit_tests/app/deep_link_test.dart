import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/utils/deep_links/deep_link_handler.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';

void main() {
  late StreamController<Uri?> stream;
  late String? navigatedTo;

  setUp(() {
    stream = StreamController<Uri?>();
    navigatedTo = null;
  });

  tearDown(() async {
    await stream.close();
  });

  DeepLinkHandler createHandler({Uri? initialUri}) {
    final source = DeepLinkSource(
      initial: () async => initialUri,
      stream: () => stream.stream,
    );

    return DeepLinkHandler(
      (routeName) => navigatedTo = routeName,
      source: source,
    );
  }

  group('deep link tests', () {
    test('navigates to create-account/confirm for signup', () async {
      final handler = createHandler(
        initialUri: Uri.parse(
          'https://wishing-well-ayb.pages.dev/auth/account-confirm?type=signup',
        ),
      );

      handler.init();
      await Future<void>.delayed(Duration.zero);

      expect(navigatedTo, 'account-confirm');
    });

    test('navigates to forgot-password/confirm for non-signup', () async {
      final handler = createHandler(
        initialUri: Uri.parse(
          'https://wishing-well-ayb.pages.dev/auth/account-confirm',
        ),
      );

      handler.init();
      await Future<void>.delayed(Duration.zero);

      expect(navigatedTo, 'forgot-password-confirm');
    });

    test('navigates to forgot-password on reset link', () async {
      final handler = createHandler();
      handler.init();

      stream.add(
        Uri.parse('https://wishing-well-ayb.pages.dev/auth/password-reset'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(navigatedTo, 'reset-password');
    });

    test('ignores unrelated links', () async {
      final handler = createHandler();
      handler.init();

      stream.add(Uri.parse('https://wishingwell.app/foo'));
      await Future<void>.delayed(Duration.zero);

      expect(navigatedTo, isNull);
    });

    test('dispose cancels stream subscription', () {
      final handler = createHandler();
      handler.init();

      handler.dispose();

      expect(stream.hasListener, isFalse);
    });
  });
}
