import 'dart:developer';

import 'package:flutter/material.dart';

abstract class ForgotViewModelContract {
  void updateEmailField(String email);
  bool get hasAlert;
  ForgotErrorType get validationMessage;
  void tapSendResetLinkButton();
}

enum ForgotErrorType { none, noEmail, badEmail }

class ForgotPasswordViewModel extends ChangeNotifier
    implements ForgotViewModelContract {
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
  void tapSendResetLinkButton() {
    if (_isEmailValid(_email)) {
      log('Sent reset link to $_email');
    } else {
      log('Email validation failed: $_validationMessage');
    }
  }
}
