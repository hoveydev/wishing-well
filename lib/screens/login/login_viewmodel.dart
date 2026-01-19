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

abstract class LoginViewModelContract {
  void updateEmailField(String email);
  TextEditingController get emailInputController;
  void updatePasswordField(String password);
  TextEditingController get passwordInputController;
  bool get hasAlert;
  AuthError<LoginErrorType> get authError;
  void clearError();
  void tapForgotPasswordButton(BuildContext context);
  Future<void> tapLoginButton(BuildContext context);
  void tapCreateAccountButton(BuildContext context);
}

class LoginViewModel extends ChangeNotifier implements LoginViewModelContract {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  String _email = '';
  String _password = '';

  @override
  void updateEmailField(String email) {
    if (_email != email) {
      clearError();
    }
    _email = email;
  }

  @override
  TextEditingController get emailInputController => _emailInputController;
  final TextEditingController _emailInputController = TextEditingController();

  @override
  void updatePasswordField(String password) {
    if (_password != password) {
      clearError();
    }
    _password = password;
  }

  @override
  TextEditingController get passwordInputController => _passwordInputController;
  final TextEditingController _passwordInputController =
      TextEditingController();

  @override
  AuthError<LoginErrorType> get authError => _authError;

  AuthError<LoginErrorType> _authError = const UIAuthError(LoginErrorType.none);
  set _setAuthError(AuthError<LoginErrorType> error) {
    _authError = error;
    notifyListeners();
  }

  @override
  bool get hasAlert => _authError != const UIAuthError(LoginErrorType.none);

  @override
  void clearError() {
    _setAuthError = const UIAuthError(LoginErrorType.none);
  }

  bool _isFormValid(String email, String password) {
    if (InputValidators.isEmailEmpty(email) &&
        InputValidators.isPasswordEmpty(password)) {
      _setAuthError = const UIAuthError(LoginErrorType.noPasswordNoEmail);
      return false;
    }
    if (InputValidators.isEmailEmpty(email)) {
      _setAuthError = const UIAuthError(LoginErrorType.noEmail);
      return false;
    }
    if (InputValidators.isPasswordEmpty(password)) {
      _setAuthError = const UIAuthError(LoginErrorType.noPassword);
      return false;
    }
    if (!InputValidators.isEmailValid(email)) {
      _setAuthError = const UIAuthError(LoginErrorType.badEmail);
      return false;
    }
    _setAuthError = const UIAuthError(LoginErrorType.none);
    return true;
  }

  @override
  void tapForgotPasswordButton(BuildContext context) {
    _emailInputController.clear();
    _passwordInputController.clear();
    context.pushNamed(Routes.forgotPassword.name);
  }

  @override
  Future<void> tapLoginButton(BuildContext context) async {
    final loading = context.read<LoadingController>();

    if (!_isFormValid(_email, _password)) {
      log('Login failed: $_authError');
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
          unawaited(context.pushNamed(Routes.home.name));
        }
        loading.hide();
      case Error(:final Exception error):
        log(error.toString());
        if (error is AuthApiException) {
          _setAuthError = SupabaseAuthError(error.message);
        } else {
          _setAuthError = const UIAuthError(LoginErrorType.unknown);
        }
        loading.hide();
    }
  }

  @override
  void tapCreateAccountButton(BuildContext context) {
    _emailInputController.clear();
    _passwordInputController.clear();
    context.pushNamed(Routes.createAccount.name);
  }

  @override
  void dispose() {
    _emailInputController.dispose();
    _passwordInputController.dispose();
    super.dispose();
  }
}
