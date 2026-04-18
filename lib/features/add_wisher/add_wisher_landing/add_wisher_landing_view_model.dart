import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_access.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_batch_importer.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/features/shared/screen_view_model_contract.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

abstract class AddWisherLandingViewModelContract
    implements ScreenViewModelContract {
  void tapCloseButton(BuildContext context);
  void tapAddManuallyButton(BuildContext context);
  Future<void> tapAddFromContactsButton(BuildContext context);
}

class AddWisherLandingViewModel extends ChangeNotifier
    implements AddWisherLandingViewModelContract {
  AddWisherLandingViewModel({
    required AddWisherContactAccess contactAccess,
    required AddWisherContactBatchImporter contactBatchImporter,
    AddWisherContactPhotoFileBridge? photoFileBridge,
  }) : _contactAccess = contactAccess,
       _contactBatchImporter = contactBatchImporter,
       _photoFileBridge = photoFileBridge ?? AddWisherContactPhotoFileBridge();

  final AddWisherContactAccess _contactAccess;
  final AddWisherContactBatchImporter _contactBatchImporter;
  final AddWisherContactPhotoFileBridge _photoFileBridge;

  @override
  void tapAddManuallyButton(BuildContext context) {
    context.pushNamed(Routes.addWisherDetails.name);
  }

  @override
  Future<void> tapAddFromContactsButton(BuildContext context) async {
    const logContext = 'AddWisherLandingViewModel.tapAddFromContactsButton';
    final loading = context.read<StatusOverlayController>();
    final l10n = AppLocalizations.of(context)!;

    loading.show();

    try {
      final accessResult = await _contactAccess.selectContacts();
      if (!context.mounted) {
        loading.hide();
        return;
      }

      switch (accessResult) {
        case AddWisherContactAccessPermissionDenied():
          loading.showError(l10n.contactImportPermissionDenied);
        case AddWisherContactAccessCancelled():
          loading.hide();
        case AddWisherContactAccessSelection(:final drafts):
          final duplicateReport = _contactBatchImporter.detectDuplicates(
            drafts,
          );
          if (duplicateReport.hasDuplicates &&
              !await _confirmDuplicateImport(
                loading: loading,
                l10n: l10n,
                duplicateReport: duplicateReport,
              )) {
            return;
          }

          loading.show();
          final importResult = await _contactBatchImporter.importDrafts(drafts);
          if (!context.mounted) return;

          if (importResult.isFullSuccess) {
            await _showFullSuccess(
              context: context,
              loading: loading,
              l10n: l10n,
              result: importResult,
            );
            return;
          }

          if (importResult.isPartialSuccess) {
            loading.showSuccess(
              l10n.contactImportPartialSuccess(
                importResult.importedCount,
                importResult.failedCount,
              ),
              onOk: () {
                if (context.mounted) {
                  context.pop();
                }
              },
            );
            return;
          }

          loading.showError(_failureMessage(l10n, importResult.totalCount));
      }
    } on AddWisherContactAccessException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to select contacts.',
        context: logContext,
        error: error,
        stackTrace: stackTrace,
      );
      loading.showError(l10n.contactImportUnexpectedFailure);
    } on Exception catch (error, stackTrace) {
      AppLogger.error(
        'Failed to import selected contacts.',
        context: logContext,
        error: error,
        stackTrace: stackTrace,
      );
      loading.showError(l10n.contactImportUnexpectedFailure);
    }
  }

  Future<bool> _confirmDuplicateImport({
    required StatusOverlayController loading,
    required AppLocalizations l10n,
    required AddWisherContactDuplicateReport duplicateReport,
  }) {
    final decision = Completer<bool>();

    loading.showWarning(
      _duplicateWarningMessage(l10n, duplicateReport),
      primaryActionLabel: l10n.continueAction,
      secondaryActionLabel: l10n.cancel,
      onPrimaryAction: () {
        if (!decision.isCompleted) {
          decision.complete(true);
        }
      },
      onSecondaryAction: () {
        if (!decision.isCompleted) {
          decision.complete(false);
        }
      },
    );

    return decision.future;
  }

  String _duplicateWarningMessage(
    AppLocalizations l10n,
    AddWisherContactDuplicateReport duplicateReport,
  ) {
    if (duplicateReport.duplicateCount == 1) {
      return l10n.contactImportDuplicateWarningSingle(
        duplicateReport.duplicates.single.draft.summaryLabel,
      );
    }

    return l10n.contactImportDuplicateWarningMultiple(
      duplicateReport.duplicateCount,
    );
  }

  String _fullSuccessMessage(
    AppLocalizations l10n,
    AddWisherContactImportResult result,
  ) {
    if (result.importedCount == 1) {
      return l10n.contactImportSuccessNamed(
        result.importedEntries.single.draft.summaryLabel,
      );
    }

    return l10n.contactImportSuccessMultiple(result.importedCount);
  }

  Future<void> _showFullSuccess({
    required BuildContext context,
    required StatusOverlayController loading,
    required AppLocalizations l10n,
    required AddWisherContactImportResult result,
  }) async {
    if (result.importedCount == 1) {
      final importedEntry = result.importedEntries.single;
      final importedName = importedEntry.draft.summaryLabel;
      final overlayImageFile = await _createOverlayImageFile(importedEntry);

      loading.showSuccess(
        l10n.contactImportSuccessNamed(importedName),
        name: importedName,
        localImageFile: overlayImageFile,
        onHide: () {
          unawaited(_photoFileBridge.deleteTemporaryFile(overlayImageFile));
        },
        onOk: () {
          if (context.mounted) {
            context.pop();
          }
        },
      );
      return;
    }

    loading.showSuccess(
      _fullSuccessMessage(l10n, result),
      onOk: () {
        if (context.mounted) {
          context.pop();
        }
      },
    );
  }

  Future<File?> _createOverlayImageFile(
    AddWisherContactImportResultEntry importedEntry,
  ) async {
    final imageReference = importedEntry.draft.imageReference;
    if (imageReference == null) return null;

    try {
      return await _photoFileBridge.createTemporaryFile(imageReference);
    } on Exception catch (error, stackTrace) {
      AppLogger.error(
        'Failed to prepare imported contact photo for success overlay.',
        context: 'AddWisherLandingViewModel._createOverlayImageFile',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  String _failureMessage(AppLocalizations l10n, int totalCount) {
    if (totalCount == 1) {
      return l10n.contactImportFailureSingle;
    }

    return l10n.contactImportFailureMultiple;
  }

  @override
  void tapCloseButton(BuildContext context) {
    context.pop();
  }
}
