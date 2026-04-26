import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/utils/deep_links/deep_link_handler.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

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

  DeepLinkHandler createHandler({
    Uri? initialUri,
    Stream<String?>? passwordRecovery,
  }) {
    final source = DeepLinkSource(
      initial: () async => initialUri,
      stream: () => stream.stream,
    );

    return DeepLinkHandler(
      (routeName, queryParams) => navigatedTo = routeName,
      source: source,
      passwordRecovery: passwordRecovery,
    );
  }

  group('DeepLinkHandler', () {
    group(TestGroups.initialState, () {
      test(
        'navigates to login with accountConfirmed param for signup',
        () async {
          final handler = createHandler(
            initialUri: Uri.parse(
              'https://wishing-well-ayb.pages.dev/auth/account-confirm'
              '?type=signup',
            ),
          );

          handler.init();
          await Future<void>.delayed(Duration.zero);

          expect(navigatedTo, 'login');
        },
      );

      test('does not navigate for unrecognized account-confirm type', () async {
        final handler = createHandler(
          initialUri: Uri.parse(
            'https://wishing-well-ayb.pages.dev/auth/account-confirm',
          ),
        );

        handler.init();
        await Future<void>.delayed(Duration.zero);

        expect(navigatedTo, isNull);
      });

      test('does not navigate for password-reset initial URI', () async {
        final handler = createHandler(
          initialUri: Uri.parse(
            'https://wishing-well-ayb.pages.dev/auth/password-reset'
            '?code=abc123',
          ),
        );

        handler.init();
        await Future<void>.delayed(Duration.zero);

        expect(navigatedTo, isNull);
      });
    });

    group(TestGroups.behavior, () {
      test('does not navigate for password-reset URI via stream', () async {
        final handler = createHandler();
        handler.init();

        stream.add(
          Uri.parse('https://wishing-well-ayb.pages.dev/auth/password-reset'),
        );
        await Future<void>.delayed(Duration.zero);

        expect(navigatedTo, isNull);
      });

      test('navigates to reset-password on password recovery event', () async {
        final recoveryController = StreamController<String?>();
        final handler = createHandler(
          passwordRecovery: recoveryController.stream,
        );
        handler.init();

        recoveryController.add('user@example.com');
        await Future<void>.delayed(Duration.zero);

        expect(navigatedTo, 'reset-password');
        await recoveryController.close();
      });

      test(
        'navigates to reset-password with null email on password recovery',
        () async {
          final recoveryController = StreamController<String?>();
          final handler = createHandler(
            passwordRecovery: recoveryController.stream,
          );
          handler.init();

          recoveryController.add(null);
          await Future<void>.delayed(Duration.zero);

          expect(navigatedTo, 'reset-password');
          await recoveryController.close();
        },
      );

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

      test('dispose cancels password recovery subscription', () async {
        final recoveryController = StreamController<String?>();
        final handler = createHandler(
          passwordRecovery: recoveryController.stream,
        );
        handler.init();
        handler.dispose();

        recoveryController.add('user@example.com');
        await Future<void>.delayed(Duration.zero);

        expect(navigatedTo, isNull);
        await recoveryController.close();
      });
    });
  });
}
