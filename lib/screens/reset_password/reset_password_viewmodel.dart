import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/loading_controller.dart';

abstract class ResetPasswordViewmodelContract {
  void updatePasswordOneField(String password);
  void updatePasswordTwoField(String password);
  bool get hasAlert;
  ResetPasswordErrorType get validationMessage;
  Future<void> tapResetPasswordButton(BuildContext context);
  void tapCloseButton(BuildContext context);
}

enum ResetPasswordErrorType {
  none,
  noPassword,
  passwordTooShort,
  passwordNoUppercase,
  passwordNoLowercase,
  passwordNoDigit,
  passwordNoSpecial,
  passwordsDontMatch,
  // unknownError, TODO: add back in when service is complete
}

class ResetPasswordViewmodel extends ChangeNotifier
    implements ResetPasswordViewmodelContract {
  final AuthRepository _authRepository;

  ResetPasswordViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  String _passwordOne = '';
  String _passwordTwo = '';

  @override
  void updatePasswordOneField(String password) {
    _passwordOne = password;
  }

  @override
  void updatePasswordTwoField(String password) {
    _passwordTwo = password;
  }

  @override
  ResetPasswordErrorType get validationMessage => _validationMessage;

  ResetPasswordErrorType _validationMessage = ResetPasswordErrorType.none;
  set _setValidationMessage(ResetPasswordErrorType message) {
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
  bool _passwordIsNotValid(String passwordOne, String passwordTwo) {
    if (passwordOne.isEmpty) {
      _setHasAlert = true;
      _setValidationMessage = ResetPasswordErrorType.noPassword;
      return true;
    }
    if (passwordOne.length < 12) {
      _setHasAlert = true;
      _setValidationMessage = ResetPasswordErrorType.passwordTooShort;
      return true;
    }
    if (!passwordOne.contains(RegExp(r'[A-Z]'))) {
      _setHasAlert = true;
      _setValidationMessage = ResetPasswordErrorType.passwordNoUppercase;
      return true;
    }
    if (!passwordOne.contains(RegExp(r'[a-z]'))) {
      _setHasAlert = true;
      _setValidationMessage = ResetPasswordErrorType.passwordNoLowercase;
      return true;
    }
    if (!passwordOne.contains(RegExp(r'[0-9]'))) {
      _setHasAlert = true;
      _setValidationMessage = ResetPasswordErrorType.passwordNoDigit;
      return true;
    }
    if (!passwordOne.contains(RegExp(r'[^a-zA-Z0-9]'))) {
      _setHasAlert = true;
      _setValidationMessage = ResetPasswordErrorType.passwordNoSpecial;
      return true;
    }
    if (passwordOne != passwordTwo) {
      _setHasAlert = true;
      _setValidationMessage = ResetPasswordErrorType.passwordsDontMatch;
      return true;
    }
    _setHasAlert = false;
    _setValidationMessage = ResetPasswordErrorType.none;
    return false;
  }

  @override
  void tapCloseButton(BuildContext context) {
    // TODO: open modal
    // might not be on context
    context.goNamed(Routes.login);
  }

  @override
  Future<void> tapResetPasswordButton(BuildContext context) async {
    final loading = context.read<LoadingController>();
    if (_passwordIsNotValid(_passwordOne, _passwordTwo)) {
      log('Sign up failed: $_validationMessage');
      return;
    }

    loading.show();

    log(_authRepository.toString());

    // if (context.mounted) {
    //   unawaited(context.pushNamed(Routes.resetPasswordConfirmation));
    //   loading.hide();
    // }

    // final response = await _authRepository.createAccount(
    //   email: _email,
    //   password: _passwordOne,
    // );

    // switch (response) {
    //   case Ok():
    //     if (context.mounted) {
    //       unawaited(context.pushNamed(Routes.createAccountConfirm));
    //     }
    //     loading.hide();
    //   case Error():
    //     _setValidationMessage = CreateAccountErrorType.unknownError;
    //     _setHasAlert = true;
    //     loading.hide();
    // }
  }
}
