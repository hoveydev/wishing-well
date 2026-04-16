import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository_impl.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/shared/screen_view_model_contract.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/utils/app_config.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';

abstract class AddWisherDetailsViewModelContract
    implements ScreenViewModelContract {
  void updateFirstName(String firstName);
  void updateLastName(String lastName);
  void updateImage(File? imageFile);
  File? get imageFile;
  bool get hasAlert;
  AddWisherDetailsError get error;
  void clearError();
  bool get isFormValid;
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

  AddWisherDetailsError _error = const AddWisherDetailsError(
    AddWisherDetailsErrorType.none,
  );

  @override
  AddWisherDetailsError get error => _error;

  @override
  bool get hasAlert => _error.type != AddWisherDetailsErrorType.none;

  @override
  void clearError() {
    _error = const AddWisherDetailsError(AddWisherDetailsErrorType.none);
    notifyListeners();
  }

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
    _imageFile = imageFile;
    notifyListeners();
  }

  /// Getter for the selected image file
  @override
  File? get imageFile => _imageFile;

  void _validateForm() {
    final previousError = _error;
    if (_firstName.isEmpty && _lastName.isEmpty) {
      _error = const AddWisherDetailsError(
        AddWisherDetailsErrorType.bothNamesRequired,
      );
    } else if (_firstName.isEmpty) {
      _error = const AddWisherDetailsError(
        AddWisherDetailsErrorType.firstNameRequired,
      );
    } else if (_lastName.isEmpty) {
      _error = const AddWisherDetailsError(
        AddWisherDetailsErrorType.lastNameRequired,
      );
    } else {
      _error = const AddWisherDetailsError(AddWisherDetailsErrorType.none);
    }

    if (previousError.type != _error.type) {
      notifyListeners();
    }
  }

  @override
  bool get isFormValid => _firstName.isNotEmpty && _lastName.isNotEmpty;

  @override
  void tapBackButton(BuildContext context) {
    context.pop();
  }

  @override
  Future<void> tapSaveButton(BuildContext context) async {
    final loading = context.read<LoadingController>();
    final l10n = AppLocalizations.of(context)!;

    // Validate form before proceeding
    _validateForm();
    if (!isFormValid) {
      AppLogger.warning(
        'Wisher creation failed: $_error',
        context: 'AddWisherDetailsViewModel.tapSaveButton',
      );
      return;
    }

    loading.show();

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

    // Upload the profile picture to Supabase Storage if an image was selected
    String? profilePictureUrl;
    if (_imageFile != null) {
      AppLogger.debug(
        'Uploading profile picture...',
        context: 'AddWisherDetailsViewModel.tapSaveButton',
      );

      try {
        profilePictureUrl = await _imageRepository.uploadImage(
          filePath: _imageFile!.path,
          bucketName: AppConfig.profilePicturesBucket,
          folder: userId,
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
      }
    }

    final response = await _wisherRepository.createWisher(
      userId: userId,
      firstName: _firstName,
      lastName: _lastName,
      profilePicture: profilePictureUrl,
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
}
