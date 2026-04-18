import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository_impl.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/shared/screen_view_model_contract.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/utils/app_config.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';

abstract class EditWisherViewModelContract implements ScreenViewModelContract {
  Wisher? get wisher;
  bool get isLoading;
  File? get imageFile;
  String? get existingImageUrl;
  bool get hasAlert;
  EditWisherError get error;
  bool get isFormValid;
  void updateFirstName(String firstName);
  void updateLastName(String lastName);
  void updateImage(File? imageFile);
  void clearImage();
  void clearError();
  Future<void> tapSaveButton(BuildContext context);
  void tapBackButton(BuildContext context);
}

enum EditWisherErrorType {
  none,
  firstNameRequired,
  lastNameRequired,
  bothNamesRequired,
  invalidImage,
  unknown,
  noChanges,
}

class EditWisherError {
  const EditWisherError(this.type);
  final EditWisherErrorType type;
}

class EditWisherViewModel extends ChangeNotifier
    implements EditWisherViewModelContract {
  EditWisherViewModel({
    required WisherRepository wisherRepository,
    required ImageRepository imageRepository,
    required String wisherId,
  }) : _wisherRepository = wisherRepository,
       _imageRepository = imageRepository,
       _wisherId = wisherId {
    _wisherRepository.addListener(_onRepositoryChanged);
    _loadWisher();
  }

  final WisherRepository _wisherRepository;
  final ImageRepository _imageRepository;
  final String _wisherId;

  Wisher? _wisher;
  bool _isLoading = true;
  bool _isDisposed = false;

  String _firstName = '';
  String _lastName = '';
  File? _imageFile;
  String? _existingImageUrl;
  Future<File?>? _compressionFuture;

  String _originalFirstName = '';
  String _originalLastName = '';
  String? _originalImageUrl;

  EditWisherError _error = const EditWisherError(EditWisherErrorType.none);

  @override
  Wisher? get wisher => _wisher;

  @override
  bool get isLoading => _isLoading;

  @override
  File? get imageFile => _imageFile;

  @override
  String? get existingImageUrl => _existingImageUrl;

  @override
  EditWisherError get error => _error;

  @override
  bool get hasAlert => _error.type != EditWisherErrorType.none;

  @override
  bool get isFormValid => true;

  @override
  void updateFirstName(String firstName) {
    _firstName = firstName.trim();
    _validateForm();
  }

  @override
  void updateLastName(String lastName) {
    _lastName = lastName.trim();
    _validateForm();
  }

  @override
  void updateImage(File? imageFile) {
    _cleanupFutureFile(_compressionFuture);
    _imageFile = imageFile;
    _compressionFuture = imageFile != null
        ? _imageRepository.compressImage(imageFile.path)
        : null;
    notifyListeners();
  }

  @override
  void clearImage() {
    _cleanupFutureFile(_compressionFuture);
    _imageFile = null;
    _existingImageUrl = null;
    _compressionFuture = null;
    notifyListeners();
  }

  // Attaches a fire-and-forget delete callback to a compression future so
  // orphaned temp files are removed even if the result is never awaited.
  void _cleanupFutureFile(Future<File?>? future) {
    future
        ?.then((file) {
          try {
            file?.deleteSync();
          } catch (_) {}
        })
        .catchError((_) {});
  }

  @override
  void clearError() {
    _error = const EditWisherError(EditWisherErrorType.none);
    notifyListeners();
  }

  @override
  void tapBackButton(BuildContext context) {
    context.pop();
  }

  @override
  Future<void> tapSaveButton(BuildContext context) async {
    final loading = context.read<LoadingController>();
    final l10n = AppLocalizations.of(context)!;

    // Validate at save time: at least one name must be non-empty
    if (_firstName.isEmpty && _lastName.isEmpty) {
      _error = const EditWisherError(EditWisherErrorType.bothNamesRequired);
      notifyListeners();
      AppLogger.warning(
        'Wisher update failed: $_error',
        context: 'EditWisherViewModel.tapSaveButton',
      );
      return;
    }

    if (!_hasChanges()) {
      _error = const EditWisherError(EditWisherErrorType.noChanges);
      notifyListeners();
      return;
    }

    loading.show();

    try {
      final userId = _wisher?.userId;
      if (userId == null) {
        AppLogger.error(
          'Wisher update failed: No userId on wisher',
          context: 'EditWisherViewModel.tapSaveButton',
        );
        _error = const EditWisherError(EditWisherErrorType.unknown);
        loading.showError(l10n.errorUnknown, onOk: clearError);
        return;
      }

      String? profilePictureUrl = _existingImageUrl;

      if (_imageFile != null) {
        AppLogger.debug(
          'Uploading updated profile picture...',
          context: 'EditWisherViewModel.tapSaveButton',
        );
        File? precompressed;
        try {
          precompressed = _compressionFuture != null
              ? await _compressionFuture
              : null;
          final uploadedProfilePictureUrl = await _imageRepository.uploadImage(
            filePath: _imageFile!.path,
            bucketName: AppConfig.profilePicturesBucket,
            folder: userId,
            precompressedFile: precompressed,
          );

          if (uploadedProfilePictureUrl == null) {
            AppLogger.warning(
              'Failed to upload profile picture, continuing without it',
              context: 'EditWisherViewModel.tapSaveButton',
            );
          } else {
            profilePictureUrl = uploadedProfilePictureUrl;
          }
        } on ImageValidationException catch (e) {
          AppLogger.warning(
            'Invalid image file: ${e.message}',
            context: 'EditWisherViewModel.tapSaveButton',
          );
          _error = const EditWisherError(EditWisherErrorType.invalidImage);
          loading.showError(e.message, onOk: clearError);
          return;
        } finally {
          if (precompressed != null) {
            try {
              precompressed.deleteSync();
            } catch (_) {}
          }
        }
      }

      final updatedWisher = Wisher(
        id: _wisher!.id,
        userId: userId,
        firstName: _firstName,
        lastName: _lastName,
        profilePicture: profilePictureUrl,
        createdAt: _wisher!.createdAt,
        updatedAt: DateTime.now(),
      );

      final response = await _wisherRepository.updateWisher(updatedWisher);

      switch (response) {
        case Ok(:final value):
          AppLogger.info(
            'Wisher updated successfully: ${value.id}',
            context: 'EditWisherViewModel.tapSaveButton',
          );

          if (profilePictureUrl != null) {
            await _imageRepository.preloadImages([profilePictureUrl]);
          }

          loading.showSuccess(
            l10n.wisherUpdatedSuccess(value.name),
            name: value.name,
            imageUrl: profilePictureUrl,
            localImageFile: _imageFile,
            onOk: () {
              if (context.mounted) {
                context.pop();
              }
            },
          );
        case Error(:final error):
          AppLogger.error(
            'Wisher update failed',
            context: 'EditWisherViewModel.tapSaveButton',
            error: error,
          );
          _error = const EditWisherError(EditWisherErrorType.unknown);
          loading.showError(l10n.errorUnknown, onOk: clearError);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error during wisher update',
        context: 'EditWisherViewModel.tapSaveButton',
        error: e,
        stackTrace: stackTrace,
      );
      _error = const EditWisherError(EditWisherErrorType.unknown);
      loading.showError(l10n.errorUnknown, onOk: clearError);
    }
  }

  void _onRepositoryChanged() {
    final wishers = _wisherRepository.wishers;
    final updated = wishers.where((w) => w.id == _wisherId).firstOrNull;
    if (updated != null) {
      _wisher = updated;
      notifyListeners();
    }
  }

  void _loadWisher() {
    _isLoading = true;
    notifyListeners();

    final wishers = _wisherRepository.wishers;
    _wisher = wishers.where((w) => w.id == _wisherId).firstOrNull;

    if (_wisher != null) {
      _firstName = _wisher!.firstName;
      _lastName = _wisher!.lastName;
      _existingImageUrl = _wisher!.profilePicture;
      _originalFirstName = _wisher!.firstName;
      _originalLastName = _wisher!.lastName;
      _originalImageUrl = _wisher!.profilePicture;
    }

    _isLoading = false;
    notifyListeners();
  }

  bool _hasChanges() =>
      _firstName != _originalFirstName ||
      _lastName != _originalLastName ||
      _imageFile != null ||
      _existingImageUrl != _originalImageUrl;

  void _validateForm() {
    final previousError = _error;
    _error = const EditWisherError(EditWisherErrorType.none);

    if (previousError.type != _error.type) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _cleanupFutureFile(_compressionFuture);
    _wisherRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
