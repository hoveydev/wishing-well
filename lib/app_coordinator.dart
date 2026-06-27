import 'package:go_router/go_router.dart';
import 'package:wishing_well/app_event.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/deep_links/deep_link_handler.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

class AppCoordinator {
  AppCoordinator({
    required this.router,
    required this.overlay,
    required this.l10n,
  });
  final GoRouter router;
  final StatusOverlayController overlay;
  final AppLocalizations l10n;

  // Handles app events, such as deep link navigation and error handling.
  void handle(AppEvent event) {
    AppLogger.info('Handling app event: $event', context: 'AppCoordinator');
    switch (event) {
      case ShowAccountConfirmation():
        overlay.showSuccess(l10n.accountConfirmationMessage);

      case ShowDeepLinkError(type: final type):
        overlay.showError(_messageForError(type));

      case NavigateToResetPassword():
        router.pushNamed(Routes.resetPassword.name);
    }
  }

  String _messageForError(DeepLinkErrorType type) {
    switch (type) {
      // eventually change the text for these
      case DeepLinkErrorType.invalid:
        return l10n.deepLinkError;

      case DeepLinkErrorType.passwordReset:
        return l10n.deepLinkError;

      case DeepLinkErrorType.unknown:
        return l10n.deepLinkError;
    }
  }
}
