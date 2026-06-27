import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/app_coordinator.dart';
import 'package:wishing_well/app_event.dart';
import 'package:wishing_well/l10n/app_localizations_en.dart';
import 'package:wishing_well/test_helpers/mocks/routing/mock_router.dart';
import 'package:wishing_well/utils/deep_links/deep_link_handler.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

void main() {
  final coordinator = AppCoordinator(
    router: createMockRouter(),
    overlay: StatusOverlayController(),
    l10n: AppLocalizationsEn(),
  );

  setUp(() {
    coordinator.overlay.hide();
  });
  group('AppCoordinator', () {
    test('should handle ShowAccountConfirmation event', () {
      final event = ShowAccountConfirmation();
      expect(coordinator.overlay.isIdle, true);
      coordinator.handle(event);
      expect(coordinator.overlay.isSuccess, true);
      expect(coordinator.overlay.isIdle, false);
      expect(coordinator.overlay.isError, false);
      expect(coordinator.overlay.isWarning, false);
      expect(coordinator.overlay.isLoading, false);
      expect(
        coordinator.overlay.message,
        'You may now securely log in to WishingWell',
      );
    });

    test('should handle ShowDeepLinkError event - generic', () {
      final event = ShowDeepLinkError(DeepLinkErrorType.generic);
      expect(coordinator.overlay.isIdle, true);
      coordinator.handle(event);
      expect(coordinator.overlay.isError, true);
      expect(coordinator.overlay.isIdle, false);
      expect(coordinator.overlay.isSuccess, false);
      expect(coordinator.overlay.isWarning, false);
      expect(coordinator.overlay.isLoading, false);
      expect(
        coordinator.overlay.message,
        'An error occurred while processing the link. Please try again later.',
      );
    });

    test('should handle ShowDeepLinkError event - access denied', () {
      final event = ShowDeepLinkError(DeepLinkErrorType.accessDenied);
      expect(coordinator.overlay.isIdle, true);
      coordinator.handle(event);
      expect(coordinator.overlay.isError, true);
      expect(coordinator.overlay.isIdle, false);
      expect(coordinator.overlay.isSuccess, false);
      expect(coordinator.overlay.isWarning, false);
      expect(coordinator.overlay.isLoading, false);
      expect(
        coordinator.overlay.message,
        'This link has expired or is no longer valid. '
        'Please resubmit for a new link.',
      );
    });

    test('should handle ShowDeepLinkError event - unknown', () {
      final event = ShowDeepLinkError(DeepLinkErrorType.unknown);
      expect(coordinator.overlay.isIdle, true);
      coordinator.handle(event);
      expect(coordinator.overlay.isError, true);
      expect(coordinator.overlay.isIdle, false);
      expect(coordinator.overlay.isSuccess, false);
      expect(coordinator.overlay.isWarning, false);
      expect(coordinator.overlay.isLoading, false);
      expect(
        coordinator.overlay.message,
        'This link is not recognized. Please check the link and try again.',
      );
    });

    test('should handle NavigateToResetPassword event', () {
      final event = NavigateToResetPassword();
      expect(
        coordinator.router.routeInformationProvider.value.uri.toString(),
        '/login',
      );
      coordinator.handle(event);
      expect(
        coordinator.router.routeInformationProvider.value.uri.toString(),
        '/forgot-password/reset',
      );
    });
  });
}
