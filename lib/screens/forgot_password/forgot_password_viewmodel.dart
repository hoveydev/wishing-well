import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';
import 'package:wishing_well/routing/routes.dart';

abstract class ForgotViewModelContract {
  void updateEmailField(String email);
  bool get hasAlert;
  ForgotErrorType get validationMessage;
  Future<void> tapSendResetLinkButton(BuildContext context);
}

enum ForgotErrorType { none, noEmail, badEmail, unknownError }

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
  ForgotErrorType get validationMessage => _validationMessage;

  ForgotErrorType _validationMessage = ForgotErrorType.none;
  set _setValidationMessage(ForgotErrorType message) {
    _validationMessage = message;
    notifyListeners();
  }

  @override
  bool get hasAlert => _hasAlert;

  bool _hasAlert = false;
  set _setHasAlert(bool value) {
    _hasAlert = value;
    notifyListeners();
  }

  bool _isEmailValid(String email) {
    if (email.isEmpty) {
      _setHasAlert = true;
      _setValidationMessage = ForgotErrorType.noEmail;
      return false;
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    );
    if (!emailRegex.hasMatch(email)) {
      _setHasAlert = true;
      _setValidationMessage = ForgotErrorType.badEmail;
      return false;
    }
    _setHasAlert = false;
    _setValidationMessage = ForgotErrorType.none;
    return true;
  }

  @override
  Future<void> tapSendResetLinkButton(BuildContext context) async {
    final loading = context.read<LoadingController>();
    if (!_isEmailValid(_email)) {
      log('Email validation failed: $_validationMessage');
      return;
    }

    loading.show();

    final response = await _authRepository.sendPasswordResetRequest(
      email: _email,
    );

    switch (response) {
      case Ok():
        if (context.mounted) {
          unawaited(context.pushNamed(Routes.forgotPasswordConfirm));
        }
        loading.hide();
      case Error():
        _setValidationMessage = ForgotErrorType.unknownError;
        _setHasAlert = true;
        loading.hide();
    }
  }
}
