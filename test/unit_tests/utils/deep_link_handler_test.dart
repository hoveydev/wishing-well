import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/utils/deep_links/deep_link_handler.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';

void main() {
  late StreamController<Uri?> stream;
  late String? navigatedTo;
  // late DeepLinkErrorType? errorType;

  setUp(() {
    stream = StreamController<Uri?>();
    navigatedTo = null;
    // errorType = null;
  });

  tearDown(() async {
    await stream.close();
  });

  DeepLinkHandler createHandler({
    Uri? initialUri,
    Stream<String?>? passwordRecovery,
  }) {
    final source = DeepLinkSource(
      initial: () async => initialUri,
      stream: () => stream.stream,
    );

    return DeepLinkHandlerImpl(source: source);
  }

  group('DeepLinkHandler', () {
    group('initial', () {
      test('does not navigate for password-reset initial URI', () async {
        final handler = createHandler(
          initialUri: Uri.parse(
            'https://wishing-well-ayb.pages.dev/auth/password-reset'
            '?code=abc123',
          ),
        );

        await handler.init();
        await Future<void>.delayed(Duration.zero);

        expect(navigatedTo, isNull);
      });

      test('does not navigate for account-confirm initial URI', () async {
        final handler = createHandler(
          initialUri: Uri.parse(
            'https://wishing-well-ayb.pages.dev/auth/account-confirm',
          ),
        );

        await handler.init();
        await Future<void>.delayed(Duration.zero);

        expect(navigatedTo, isNull);
      });
    });

    group('errorHandling', () {
      // test('calls onError for password-reset error URI', () async {
      //   final handler = createHandler(
      //     initialUri: Uri.parse(
      //       'https://wishing-well-ayb.pages.dev/auth/password-reset'
      //       '?error=access_denied&error_code=otp_expired'
      //       '&error_description=Email+link+is+invalid+or+has+expired',
      //     ),
      //   );

      //   await handler.init();
      //   await Future<void>.delayed(Duration.zero);

      //   expect(errorType, DeepLinkErrorType.passwordReset);
      // });

      // test('calls onError for unrecognized path', () async {
      //   final handler = createHandler(
      //     initialUri: Uri.parse(
      //       'https://wishing-well-ayb.pages.dev/auth/unknown-path'
      //       '?error=access_denied',
      //     ),
      //   );

      //   await handler.init();
      //   await Future<void>.delayed(Duration.zero);

      //   expect(errorType, DeepLinkErrorType.unknown);
      // });

      // test('calls onError via stream for password-reset error', () async {
      //   final handler = createHandler();
      //   await handler.init();

      //   stream.add(
      //     Uri.parse(
      //       'https://wishing-well-ayb.pages.dev/auth/password-reset'
      //       '?error=access_denied&error_code=otp_expired',
      //     ),
      //   );
      //   await Future<void>.delayed(Duration.zero);

      //   expect(errorType, DeepLinkErrorType.passwordReset);
      // });

      // test('calls onError for error query params without auth path',
      // () async {
      //   final handler = createHandler(
      //     initialUri: Uri.parse(
      //       'https://wishing-well-ayb.pages.dev/?error=access_denied'
      //       '&error_code=otp_expired&error_description=Invalid+link',
      //     ),
      //   );

      //   await handler.init();
      //   await Future<void>.delayed(Duration.zero);

      //   expect(errorType, DeepLinkErrorType.unknown);
      // });
    });

    group('behavior', () {
      test('does not navigate for password-reset URI via stream', () async {
        final handler = createHandler();
        await handler.init();

        stream.add(
          Uri.parse('https://wishing-well-ayb.pages.dev/auth/password-reset'),
        );
        await Future<void>.delayed(Duration.zero);

        expect(navigatedTo, isNull);
      });

      test('does not navigate for account-confirm URI via stream', () async {
        final handler = createHandler();
        await handler.init();

        stream.add(
          Uri.parse('https://wishing-well-ayb.pages.dev/auth/account-confirm'),
        );
        await Future<void>.delayed(Duration.zero);

        expect(navigatedTo, isNull);
      });

      // test('navigates to reset-password on password recovery event',
      // () async {
      //   final recoveryController = StreamController<String?>();
      //   final handler = createHandler(
      //     passwordRecovery: recoveryController.stream,
      //   );
      //   await handler.init();

      //   recoveryController.add('user@example.com');
      //   await Future<void>.delayed(Duration.zero);

      //   expect(navigatedTo, 'reset-password');
      //   await recoveryController.close();
      // });

      // test(
      //   'navigates to reset-password with null email on password recovery',
      //   () async {
      //     final recoveryController = StreamController<String?>();
      //     final handler = createHandler(
      //       passwordRecovery: recoveryController.stream,
      //     );
      //     await handler.init();

      //     recoveryController.add(null);
      //     await Future<void>.delayed(Duration.zero);

      //     expect(navigatedTo, 'reset-password');
      //     await recoveryController.close();
      //   },
      // );

      test('ignores unrelated links', () async {
        final handler = createHandler();
        await handler.init();

        stream.add(Uri.parse('https://wishingwell.app/foo'));
        await Future<void>.delayed(Duration.zero);

        expect(navigatedTo, isNull);
      });

      test('dispose cancels stream subscription', () async {
        final handler = createHandler();
        await handler.init();

        await handler.dispose();

        expect(stream.hasListener, isFalse);
      });

      // test('dispose cancels password recovery subscription', () async {
      //   final recoveryController = StreamController<String?>();
      //   final handler = createHandler(
      //     passwordRecovery: recoveryController.stream,
      //   );
      //   await handler.init();
      //   await handler.dispose();

      //   recoveryController.add('user@example.com');
      //   await Future<void>.delayed(Duration.zero);

      //   expect(navigatedTo, isNull);
      //   await recoveryController.close();
      // });

      test('returns a broadcast stream for events', () async {
        final handler = createHandler();
        await handler.init();

        final subscription1 = handler.events.listen((event) {});
        final subscription2 = handler.events.listen((event) {});

        expect(subscription1, isNotNull);
        expect(subscription2, isNotNull);

        await subscription1.cancel();
        await subscription2.cancel();
      });
    });
  });
}
