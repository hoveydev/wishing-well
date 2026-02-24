import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';

abstract class AddWisherDetailsViewModelContract {
  void updateFirstName(String firstName);
  void updateLastName(String lastName);
  bool get hasAlert;
  AddWisherDetailsError? get error;
  void clearError();
  bool get isFormValid;
  Future<void> tapSaveButton(BuildContext context);
}

enum AddWisherDetailsErrorType {
  none,
  firstNameRequired,
  lastNameRequired,
  bothNamesRequired,
  unknown,
}

class AddWisherDetailsError {
  const AddWisherDetailsError(this.type);
  final AddWisherDetailsErrorType type;
}

class AddWisherDetailsViewModel extends ChangeNotifier
    implements AddWisherDetailsViewModelContract {
  AddWisherDetailsViewModel({required WisherRepository wisherRepository})
    : _wisherRepository = wisherRepository;

  final WisherRepository _wisherRepository;

  String _firstName = '';
  String _lastName = '';

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
  Future<void> tapSaveButton(BuildContext context) async {
    final loading = context.read<LoadingController>();

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

    // Get the current user's ID from Supabase
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      AppLogger.error(
        'Wisher creation failed: No authenticated user',
        context: 'AddWisherDetailsViewModel.tapSaveButton',
      );
      _error = const AddWisherDetailsError(AddWisherDetailsErrorType.unknown);
      notifyListeners();
      loading.hide();
      return;
    }

    final response = await _wisherRepository.createWisher(
      userId: userId,
      firstName: _firstName,
      lastName: _lastName,
    );

    switch (response) {
      case Ok(:final value):
        AppLogger.info(
          'Wisher created successfully: ${value.id}',
          context: 'AddWisherDetailsViewModel.tapSaveButton',
        );
        if (context.mounted) {
          AppLogger.debug(
            'Navigating back to home',
            context: 'AddWisherDetailsViewModel.tapSaveButton',
          );
          context.pop();
        }
        loading.hide();
      case Error(:final error):
        AppLogger.error(
          'Wisher creation failed',
          context: 'AddWisherDetailsViewModel.tapSaveButton',
          error: error,
        );
        _error = const AddWisherDetailsError(AddWisherDetailsErrorType.unknown);
        notifyListeners();
        loading.hide();
    }
  }
}
