import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';
import 'package:wishing_well/routing/routes.dart';

abstract class CreateAccountViewmodelContract {
  void updateEmailField(String email);
  void updatePasswordOneField(String password);
  void updatePasswordTwoField(String password);
  bool get hasAlert;
  CreateAccountErrorType get validationMessage;
  Future<void> tapCreateAccountButton(BuildContext context);
}

enum CreateAccountErrorType {
  none,
  noPasswordNoEmail,
  noEmail,
  badEmail,
  noPassword,
  passwordTooShort,
  passwordNoUppercase,
  passwordNoLowercase,
  passwordNoDigit,
  passwordNoSpecial,
  passwordsDontMatch,
  unknownError,
}

class CreateAccountViewmodel extends ChangeNotifier
    implements CreateAccountViewmodelContract {
  CreateAccountViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  String _email = '';
  String _passwordOne = '';
  String _passwordTwo = '';

  @override
  void updateEmailField(String email) {
    _email = email;
  }

  @override
  void updatePasswordOneField(String password) {
    _passwordOne = password;
  }

  @override
  void updatePasswordTwoField(String password) {
    _passwordTwo = password;
  }

  @override
  CreateAccountErrorType get validationMessage => _validationMessage;

  CreateAccountErrorType _validationMessage = CreateAccountErrorType.none;
  set _setValidationMessage(CreateAccountErrorType message) {
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

  // TODO: Update so more than one error can be dislpayed - might want to create a list on the screen itself
  bool _passwordIsNotValid(String password) {
    if (password.length < 12) {
      _hasAlert = true;
      _setValidationMessage = CreateAccountErrorType.passwordTooShort;
      return true;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      _hasAlert = true;
      _setValidationMessage = CreateAccountErrorType.passwordNoUppercase;
      return true;
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      _hasAlert = true;
      _setValidationMessage = CreateAccountErrorType.passwordNoLowercase;
      return true;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      _hasAlert = true;
      _setValidationMessage = CreateAccountErrorType.passwordNoDigit;
      return true;
    }
    if (!password.contains(RegExp(r'[^a-zA-Z0-9]'))) {
      _hasAlert = true;
      _setValidationMessage = CreateAccountErrorType.passwordNoSpecial;
      return true;
    }
    return false;
  }

  bool _isFormValid(String email, String passwordOne, String passwordTwo) {
    if (email.isEmpty && passwordOne.isEmpty) {
      _setHasAlert = true;
      _setValidationMessage = CreateAccountErrorType.noPasswordNoEmail;
      return false;
    }
    if (email.isEmpty) {
      _setHasAlert = true;
      _setValidationMessage = CreateAccountErrorType.noEmail;
      return false;
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    );
    if (!emailRegex.hasMatch(email)) {
      _setHasAlert = true;
      _setValidationMessage = CreateAccountErrorType.badEmail;
      return false;
    }
    if (passwordOne.isEmpty) {
      _setHasAlert = true;
      _setValidationMessage = CreateAccountErrorType.noPassword;
      return false;
    }
    if (_passwordIsNotValid(passwordOne)) {
      return false;
    }
    if (passwordOne != passwordTwo) {
      _setHasAlert = true;
      _setValidationMessage = CreateAccountErrorType.passwordsDontMatch;
      return false;
    }
    _setHasAlert = false;
    _setValidationMessage = CreateAccountErrorType.none;
    return true;
  }

  @override
  Future<void> tapCreateAccountButton(BuildContext context) async {
    final loading = context.read<LoadingController>();
    if (!_isFormValid(_email, _passwordOne, _passwordTwo)) {
      log('Sign up failed: $_validationMessage');
      return;
    }

    loading.show();

    final response = await _authRepository.createAccount(
      email: _email,
      password: _passwordOne,
    );

    switch (response) {
      case Ok():
        if (context.mounted) {
          unawaited(context.pushNamed(Routes.createAccountConfirm));
        }
        loading.hide();
      case Error():
        _setValidationMessage = CreateAccountErrorType.unknownError;
        _setHasAlert = true;
        loading.hide();
    }
  }
}
