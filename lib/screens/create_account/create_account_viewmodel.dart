import 'dart:developer';

import 'package:flutter/cupertino.dart';

abstract class CreateAccountViewmodelContract {
  void updateEmailField(String email);
  void updatePasswordOneField(String password);
  void updatePasswordTwoField(String password);
  bool get hasAlert;
  CreateAccountErrorType get validationMessage;
  void tapCreateAccountButton();
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
}

class CreateAccountViewmodel extends ChangeNotifier
    implements CreateAccountViewmodelContract {
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
  void tapCreateAccountButton() {
    if (_isFormValid(_email, _passwordOne, _passwordTwo)) {
      log('Account created for $_email');
    } else {
      log('Email validation failed: $_validationMessage');
    }
  }
}
