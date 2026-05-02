import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository_impl.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/features/shared/screen_view_model_contract.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/utils/app_config.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';
import 'package:wishing_well/utils/result.dart';

abstract class AddWisherDetailsViewModelContract
    implements ScreenViewModelContract {
  // Getters
  File? get imageFile;
  bool get hasAlert;
  AddWisherDetailsError get error;
  bool get isFormValid;
  DateTime? get birthday;
  List<String> get giftOccasions;
  List<String> get giftInterests;

  // Basic info updates
  void updateFirstName(String firstName);
  void updateLastName(String lastName);
  void updateImage(File? imageFile);

  // Gift field updates
  void updateBirthday(DateTime? birthday);
  void updateGiftOccasions(List<String> occasions);
  void updateGiftInterests(List<String> interests);

  // UI actions
  void clearError();
  Future<void> tapSaveButton(BuildContext context);
  void tapBackButton(BuildContext context);
}

enum AddWisherDetailsErrorType {
  none,
  firstNameRequired,
  lastNameRequired,
  bothNamesRequired,
  invalidImage,
  unknown,
}

class AddWisherDetailsError {
  const AddWisherDetailsError(this.type);
  final AddWisherDetailsErrorType type;
}

class AddWisherDetailsViewModel extends ChangeNotifier
    implements AddWisherDetailsViewModelContract {
  AddWisherDetailsViewModel({
    required WisherRepository wisherRepository,
    required AuthRepository authRepository,
    required ImageRepository imageRepository,
  }) : _wisherRepository = wisherRepository,
       _authRepository = authRepository,
       _imageRepository = imageRepository;

  final WisherRepository _wisherRepository;
  final AuthRepository _authRepository;
  final ImageRepository _imageRepository;

  String _firstName = '';
  String _lastName = '';
  File? _imageFile;
  Future<File?>? _compressionFuture;
  DateTime? _birthday;
  List<String> _giftOccasions = [];
  List<String> _giftInterests = [];

  AddWisherDetailsError _error = const AddWisherDetailsError(
    AddWisherDetailsErrorType.none,
  );

  // Getters
  @override
  AddWisherDetailsError get error => _error;

  @override
  bool get hasAlert => _error.type != AddWisherDetailsErrorType.none;

  @override
  File? get imageFile => _imageFile;

  @override
  DateTime? get birthday => _birthday;

  @override
  List<String> get giftOccasions => _giftOccasions;

  @override
  List<String> get giftInterests => _giftInterests;

  @override
  bool get isFormValid => true;

  // Basic info updates
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

  // Gift field updates
  @override
  void updateBirthday(DateTime? birthday) {
    _birthday = birthday;
    notifyListeners();
  }

  @override
  void updateGiftOccasions(List<String> occasions) {
    _giftOccasions = occasions;
    notifyListeners();
  }

  @override
  void updateGiftInterests(List<String> interests) {
    _giftInterests = interests;
    notifyListeners();
  }

  // Helper method: Attaches a fire-and-forget delete callback to a
  // compression future so orphaned temp files are removed even if the result
  // is never awaited.
  void _cleanupFutureFile(Future<File?>? future) {
    future
        ?.then((file) {
          try {
            file?.deleteSync();
          } catch (_) {}
        })
        .catchError((_) {});
  }

  // Validation and UI actions
  void _validateForm() {
    final previousError = _error;
    _error = const AddWisherDetailsError(AddWisherDetailsErrorType.none);

    if (previousError.type != _error.type) {
      notifyListeners();
    }
  }

  @override
  void clearError() {
    _error = const AddWisherDetailsError(AddWisherDetailsErrorType.none);
    notifyListeners();
  }

  @override
  void tapBackButton(BuildContext context) {
    context.pop();
  }

  @override
  Future<void> tapSaveButton(BuildContext context) async {
    final loading = context.read<StatusOverlayController>();
    final l10n = AppLocalizations.of(context)!;

    // Validate at save time: at least one name must be non-empty
    if (_firstName.isEmpty && _lastName.isEmpty) {
      _error = const AddWisherDetailsError(
        AddWisherDetailsErrorType.bothNamesRequired,
      );
      notifyListeners();
      AppLogger.warning(
        'Wisher creation failed: $_error',
        context: 'AddWisherDetailsViewModel.tapSaveButton',
      );
      return;
    }

    // Try auth repository first, then fall back to Supabase
    final userId =
        _authRepository.currentUserId ??
        Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      AppLogger.error(
        'Wisher creation failed: No authenticated user',
        context: 'AddWisherDetailsViewModel.tapSaveButton',
      );
      _error = const AddWisherDetailsError(AddWisherDetailsErrorType.unknown);
      loading.showError(l10n.errorUnknown, onOk: clearError);
      return;
    }

    final duplicateWisher = _findDuplicateWisher();
    if (duplicateWisher != null &&
        !await _confirmDuplicateSave(
          loading: loading,
          l10n: l10n,
          duplicateName: duplicateWisher.name,
        )) {
      return;
    }

    loading.show();

    // Upload the profile picture to Supabase Storage if an image was selected
    String? profilePictureUrl;
    if (_imageFile != null) {
      AppLogger.debug(
        'Uploading profile picture...',
        context: 'AddWisherDetailsViewModel.tapSaveButton',
      );

      File? precompressed;
      try {
        precompressed = _compressionFuture != null
            ? await _compressionFuture
            : null;
        profilePictureUrl = await _imageRepository.uploadImage(
          filePath: _imageFile!.path,
          bucketName: AppConfig.profilePicturesBucket,
          folder: userId,
          precompressedFile: precompressed,
        );

        if (profilePictureUrl == null) {
          AppLogger.warning(
            'Failed to upload profile picture, continuing without it',
            context: 'AddWisherDetailsViewModel.tapSaveButton',
          );
        }
      } on ImageValidationException catch (e) {
        AppLogger.warning(
          'Invalid image file: ${e.message}',
          context: 'AddWisherDetailsViewModel.tapSaveButton',
        );
        _error = const AddWisherDetailsError(
          AddWisherDetailsErrorType.invalidImage,
        );
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

    final response = await _wisherRepository.createWisher(
      userId: userId,
      firstName: _firstName,
      lastName: _lastName,
      profilePicture: profilePictureUrl,
      birthday: _birthday,
      giftOccasions: _giftOccasions,
      giftInterests: _giftInterests,
    );

    switch (response) {
      case Ok(:final value):
        AppLogger.info(
          'Wisher created successfully: ${value.id}',
          context: 'AddWisherDetailsViewModel.tapSaveButton',
        );

        // Preload the new image for instant display on home screen
        if (profilePictureUrl != null) {
          await _imageRepository.preloadImages([profilePictureUrl]);
        }

        // Show success message with wisher's name and optional photo
        loading.showSuccess(
          l10n.wisherCreatedSuccess(value.name),
          name: value.name,
          localImageFile: _imageFile,
          onOk: () {
            // Navigate back on success acknowledgment
            if (context.mounted) {
              context.pop();
            }
          },
        );
      case Error(:final error):
        AppLogger.error(
          'Wisher creation failed',
          context: 'AddWisherDetailsViewModel.tapSaveButton',
          error: error,
        );
        _error = const AddWisherDetailsError(AddWisherDetailsErrorType.unknown);
        loading.showError(l10n.errorUnknown, onOk: clearError);
    }
  }

  Wisher? _findDuplicateWisher() {
    final normalizedName = AddWisherContactNormalizedFullName.maybeFromParts(
      firstName: _firstName,
      lastName: _lastName,
    );
    if (normalizedName == null) return null;

    for (final wisher in _wisherRepository.wishers) {
      if (AddWisherContactNormalizedFullName.maybeFromWisher(wisher) ==
          normalizedName) {
        return wisher;
      }
    }

    return null;
  }

  Future<bool> _confirmDuplicateSave({
    required StatusOverlayController loading,
    required AppLocalizations l10n,
    required String duplicateName,
  }) {
    final decision = Completer<bool>();

    loading.showWarning(
      l10n.contactImportDuplicateWarningSingle(duplicateName),
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

  @override
  void dispose() {
    _cleanupFutureFile(_compressionFuture);
    super.dispose();
  }
}
