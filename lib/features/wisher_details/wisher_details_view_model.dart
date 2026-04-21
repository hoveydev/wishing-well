import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/app_alert/app_alert.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/shared/screen_view_model_contract.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';
import 'package:wishing_well/utils/result.dart';

abstract class WisherDetailsViewModelContract
    implements ScreenViewModelContract {
  Wisher? get wisher;
  bool get isLoading;
  void tapCloseButton(BuildContext context);
  void tapEditWisher(BuildContext context);
  Future<void> tapDeleteWisher(BuildContext context);
}

class WisherDetailsViewModel extends ChangeNotifier
    implements WisherDetailsViewModelContract {
  WisherDetailsViewModel({
    required WisherRepository wisherRepository,
    required String wisherId,
  }) : _wisherRepository = wisherRepository,
       _wisherId = wisherId {
    _wisherRepository.addListener(_onRepositoryChanged);
    _loadWisher();
  }

  final WisherRepository _wisherRepository;
  final String _wisherId;

  Wisher? _wisher;
  bool _isLoading = true;
  bool _isDisposed = false;

  @override
  Wisher? get wisher => _wisher;

  @override
  bool get isLoading => _isLoading;

  @override
  void tapCloseButton(BuildContext context) {
    context.pop();
  }

  @override
  void tapEditWisher(BuildContext context) {
    // Use the stored wisherId to avoid crashes if _wisher is null.
    context.push(Routes.editWisher.buildPath(id: _wisherId));
  }

  @override
  Future<void> tapDeleteWisher(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final wisherName = _wisher?.name ?? '';

    final confirmed = await AppAlert.show(
      context: context,
      title: l10n.wisherDeleteConfirmTitle,
      message: l10n.wisherDeleteConfirmMessage(wisherName),
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      isDestructive: true,
    );

    if (confirmed != true || !context.mounted) return;

    final loading = context.read<StatusOverlayController>();
    loading.show();

    final result = await _wisherRepository.deleteWisher(_wisherId);

    if (!context.mounted) return;

    switch (result) {
      case Ok():
        AppLogger.info(
          'Wisher deleted: $_wisherId',
          context: 'WisherDetailsViewModel.tapDeleteWisher',
        );
        loading.hide();
        context.pop();
      case Error(:final error):
        AppLogger.error(
          'Failed to delete wisher',
          context: 'WisherDetailsViewModel.tapDeleteWisher',
          error: error,
        );
        loading.showError(l10n.errorUnknown, onOk: () {});
    }
  }

  void _onRepositoryChanged() {
    final wishers = _wisherRepository.wishers;
    final updated = wishers.where((w) => w.id == _wisherId).firstOrNull;
    if (updated == null) {
      return;
    }

    _wisher = updated;
    notifyListeners();
  }

  void _loadWisher() {
    _isLoading = true;
    notifyListeners();

    final wishers = _wisherRepository.wishers;
    _wisher = wishers.where((w) => w.id == _wisherId).firstOrNull;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _wisherRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
