import 'package:flutter/material.dart';

abstract class LoginViewModelContract {
  void updateEmailField(String email);
  void updatePasswordField(String password);
  // late String email;
  // late String password;
  bool get hasAlert;
  String get validationMessage;
  void tapLoginButton();
  void tapForgotPasswordButton();
  void tapCreateAccountButton();
}

class LoginViewModel extends ChangeNotifier implements LoginViewModelContract {
  String _email = "";
  String _password = "";

  @override
  void updateEmailField(String email) { 
    _email = email;
  }

  @override
  void updatePasswordField(String password) { 
    _password = password;
  }

  @override
  String get validationMessage => _validationMessage;

  String _validationMessage = "";
  set _setValidationMessage(String message) {
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
    if (email.isEmpty || password.isEmpty) {
      _setHasAlert = true;
      _setValidationMessage = "Email and password cannot be empty.";
      return false;
    }
    _setHasAlert = false;
    _setValidationMessage = "";
    return true;
    // include all validation messages here
  }

  @override
  void tapLoginButton() {
    if (_isFormValid(_email, _password)) {
      print("Login successful with email: $_email");
      // Proceed with login logic
    } else {
      print("Login failed: $_validationMessage");
    }
    // Implement login button tap logic here
  }

  @override
  void tapForgotPasswordButton() {
    // Implement forgot password button tap logic here
  }

  @override
  void tapCreateAccountButton() {
    // Implement create account button tap logic here
  }
}