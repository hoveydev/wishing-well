import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';

abstract class ProfileViewmodelContract {
  Future<void> tapLogoutButton(BuildContext context);
  AuthError<ProfileErrorType> get authError;
  bool get hasAlert;
  void clearError();
}

class ProfileViewModel extends ChangeNotifier
    implements ProfileViewmodelContract {
  ProfileViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  AuthError<ProfileErrorType> get authError => _authError;

  @override
  bool get hasAlert => _authError != const UIAuthError(ProfileErrorType.none);

  AuthError<ProfileErrorType> _authError = const UIAuthError(
    ProfileErrorType.none,
  );
  set _setAuthError(AuthError<ProfileErrorType> error) {
    _authError = error;
    notifyListeners();
  }

  @override
  void clearError() {
    _setAuthError = const UIAuthError(ProfileErrorType.none);
  }

  @override
  Future<void> tapLogoutButton(BuildContext context) async {
    final loading = context.read<LoadingController>();

    loading.show();

    final result = await _authRepository.logout();

    switch (result) {
      case Ok():
        if (context.mounted) {
          context.goNamed(Routes.login.name);
        }
        loading.hide();
      case Error(:final Exception error):
        log(error.toString());
        if (error is AuthApiException) {
          _setAuthError = SupabaseAuthError(error.message);
        } else {
          _setAuthError = const UIAuthError(ProfileErrorType.unknown);
        }
        loading.hide();
    }
  }
}
