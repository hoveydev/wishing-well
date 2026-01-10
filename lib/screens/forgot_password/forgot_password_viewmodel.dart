import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/input_validators.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';
import 'package:wishing_well/routing/routes.dart';

abstract class ForgotViewModelContract {
  void updateEmailField(String email);
  bool get hasAlert;
  AuthError<ForgotPasswordErrorType> get authError;
  Future<void> tapSendResetLinkButton(BuildContext context);
}

class ForgotPasswordViewModel extends ChangeNotifier
    implements ForgotViewModelContract {
  ForgotPasswordViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  String _email = '';

  @override
  void updateEmailField(String email) {
    _email = email;
  }

  @override
  AuthError<ForgotPasswordErrorType> get authError => _authError;

  AuthError<ForgotPasswordErrorType> _authError = const UIAuthError(
    ForgotPasswordErrorType.none,
  );
  set _setAuthError(AuthError<ForgotPasswordErrorType> error) {
    _authError = error;
    notifyListeners();
  }

  @override
  bool get hasAlert =>
      _authError != const UIAuthError(ForgotPasswordErrorType.none);

  bool _isEmailValid(String email) {
    if (InputValidators.isEmailEmpty(email)) {
      _setAuthError = const UIAuthError(ForgotPasswordErrorType.noEmail);
      return false;
    }
    if (!InputValidators.isEmailValid(email)) {
      _setAuthError = const UIAuthError(ForgotPasswordErrorType.badEmail);
      return false;
    }
    _setAuthError = const UIAuthError(ForgotPasswordErrorType.none);
    return true;
  }

  @override
  Future<void> tapSendResetLinkButton(BuildContext context) async {
    final loading = context.read<LoadingController>();
    if (!_isEmailValid(_email)) {
      log('Email validation failed: $_authError');
      return;
    }

    loading.show();

    final response = await _authRepository.sendPasswordResetRequest(
      email: _email,
    );

    switch (response) {
      case Ok():
        if (context.mounted) {
          unawaited(context.pushNamed(Routes.forgotPasswordConfirm.name));
        }
        loading.hide();
      case Error(:final error):
        log(error.toString());
        if (error is AuthApiException) {
          _setAuthError = SupabaseAuthError(error.message);
        } else {
          _setAuthError = const UIAuthError(ForgotPasswordErrorType.unknown);
        }
        loading.hide();
    }
  }
}
