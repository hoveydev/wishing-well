import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/app_event.dart';
import 'package:wishing_well/utils/deep_links/deep_link_handler.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';

void main() {
  group('DeepLinkHandler', () {
    group('initial', () {
      test(
        'init emits NavigateToResetPassword for password reset link',
        () async {
          final controller = StreamController<Uri?>();
          final deepLinkHandler = DeepLinkHandlerImpl(
            source: DeepLinkSource(
              initial: () async => Uri.parse(
                'https://wishing-well-ayb.pages.dev/auth/password-reset?code=abc123',
              ),
              stream: () => controller.stream,
            ),
          );

          final futureEvent = deepLinkHandler.events.first;
          await deepLinkHandler.init();
          final event = await futureEvent;

          expect(event, isA<NavigateToResetPassword>());

          await controller.close();
          await deepLinkHandler.dispose();
        },
      );

      test(
        'init emits ShowAccountConfirmation for account confirmation link',
        () async {
          final controller = StreamController<Uri?>();
          final deepLinkHandler = DeepLinkHandlerImpl(
            source: DeepLinkSource(
              initial: () async => Uri.parse(
                'https://wishing-well-ayb.pages.dev/auth/account-confirm',
              ),
              stream: () => controller.stream,
            ),
          );

          final futureEvent = deepLinkHandler.events.first;
          await deepLinkHandler.init();
          final event = await futureEvent;

          expect(event, isA<ShowAccountConfirmation>());

          await controller.close();
          await deepLinkHandler.dispose();
        },
      );

      test('init emits nothing for no link', () async {
        final controller = StreamController<Uri?>();
        final deepLinkHandler = DeepLinkHandlerImpl(
          source: DeepLinkSource(
            initial: () async => null,
            stream: () => controller.stream,
          ),
        );

        final futureEvents = deepLinkHandler.events;
        await deepLinkHandler.init();

        expect(futureEvents, emitsInOrder([]));

        await controller.close();
        await deepLinkHandler.dispose();
      });
    });

    group('errorHandling', () {
      test('init emits ShowDeepLinkError for unrecognized path', () async {
        final controller = StreamController<Uri?>();
        final deepLinkHandler = DeepLinkHandlerImpl(
          source: DeepLinkSource(
            initial: () async => Uri.parse(
              'https://wishing-well-ayb.pages.dev/auth/unknown-path',
            ),
            stream: () => controller.stream,
          ),
        );

        final futureEvent = deepLinkHandler.events.first;
        await deepLinkHandler.init();
        final event = await futureEvent;

        expect(event, isA<ShowDeepLinkError>());
        expect((event as ShowDeepLinkError).type, DeepLinkErrorType.unknown);

        await controller.close();
        await deepLinkHandler.dispose();
      });

      test(
        'init emits ShowDeepLinkError for password-reset error link',
        () async {
          final controller = StreamController<Uri?>();
          final deepLinkHandler = DeepLinkHandlerImpl(
            source: DeepLinkSource(
              initial: () async => Uri.parse(
                'https://wishing-well-ayb.pages.dev/auth/password-reset'
                '?error=access_denied&error_code=otp_expired'
                '&error_description=Email+link+is+invalid+or+has+expired',
              ),
              stream: () => controller.stream,
            ),
          );

          final futureEvent = deepLinkHandler.events.first;
          await deepLinkHandler.init();
          final event = await futureEvent;

          expect(event, isA<ShowDeepLinkError>());
          expect(
            (event as ShowDeepLinkError).type,
            DeepLinkErrorType.accessDenied,
          );

          await controller.close();
          await deepLinkHandler.dispose();
        },
      );

      test(
        'init emits ShowDeepLinkError for unrecognized error type',
        () async {
          final controller = StreamController<Uri?>();
          final deepLinkHandler = DeepLinkHandlerImpl(
            source: DeepLinkSource(
              initial: () async => Uri.parse(
                'https://wishing-well-ayb.pages.dev/auth/password-reset'
                '?error=unrecognized_error&error_code=unknown'
                '&error_description=Unknown+error+occurred',
              ),
              stream: () => controller.stream,
            ),
          );

          final futureEvent = deepLinkHandler.events.first;
          await deepLinkHandler.init();
          final event = await futureEvent;

          expect(event, isA<ShowDeepLinkError>());
          expect((event as ShowDeepLinkError).type, DeepLinkErrorType.generic);

          await controller.close();
          await deepLinkHandler.dispose();
        },
      );

      test(
        'init emits ShowDeepLinkError for error query params without auth path',
        () async {
          final controller = StreamController<Uri?>();
          final deepLinkHandler = DeepLinkHandlerImpl(
            source: DeepLinkSource(
              initial: () async =>
                  Uri.parse('https://wishing-well-ayb.pages.dev/test'),
              stream: () => controller.stream,
            ),
          );

          final futureEvent = deepLinkHandler.events.first;
          await deepLinkHandler.init();
          final event = await futureEvent;

          expect(event, isA<ShowDeepLinkError>());
          expect((event as ShowDeepLinkError).type, DeepLinkErrorType.unknown);

          await controller.close();
          await deepLinkHandler.dispose();
        },
      );
    });
  });
}
