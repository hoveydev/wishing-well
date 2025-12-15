import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/loading_controller.dart';
import 'package:wishing_well/result.dart';
import 'package:wishing_well/routing/routes.dart';

abstract class LoginViewModelContract {
  void updateEmailField(String email);
  void updatePasswordField(String password);
  bool get hasAlert;
  LoginErrorType get validationMessage;
  Future<void> tapLoginButton(BuildContext context);
}

enum LoginErrorType {
  none,
  noPasswordNoEmail,
  noEmail,
  noPassword,
  badEmail,
  unknownError,
}

class LoginViewModel extends ChangeNotifier implements LoginViewModelContract {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  String _email = '';
  String _password = '';

  @override
  void updateEmailField(String email) {
    _email = email;
  }

  @override
  void updatePasswordField(String password) {
    _password = password;
  }

  @override
  LoginErrorType get validationMessage => _validationMessage;

  LoginErrorType _validationMessage = LoginErrorType.none;
  set _setValidationMessage(LoginErrorType message) {
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

  bool _isFormValid(String email, String password) {
    if (email.isEmpty && password.isEmpty) {
      _setHasAlert = true;
      _setValidationMessage = LoginErrorType.noPasswordNoEmail;
      return false;
    }
    if (email.isEmpty) {
      _setHasAlert = true;
      _setValidationMessage = LoginErrorType.noEmail;
      return false;
    }
    if (password.isEmpty) {
      _setHasAlert = true;
      _setValidationMessage = LoginErrorType.noPassword;
      return false;
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    );
    if (!emailRegex.hasMatch(email)) {
      _setHasAlert = true;
      _setValidationMessage = LoginErrorType.badEmail;
      return false;
    }
    _setHasAlert = false;
    _setValidationMessage = LoginErrorType.none;
    return true;
  }

  @override
  Future<void> tapLoginButton(BuildContext context) async {
    final loading = context.read<LoadingController>();

    if (!_isFormValid(_email, _password)) {
      log('Login failed: $_validationMessage');
      return;
    }

    loading.show();

    final response = await _authRepository.login(
      email: _email,
      password: _password,
    );
    switch (response) {
      case Ok():
        if (context.mounted) {
          unawaited(context.push(Routes.home));
        }
        loading.hide();
      case Error():
        _setValidationMessage = LoginErrorType.unknownError;
        _setHasAlert = true;
        loading.hide();
    }
  }
}
