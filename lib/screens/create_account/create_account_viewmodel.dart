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
  Set<CreateAccountPasswordRequirements> get metPasswordRequirements;
  Future<void> tapCreateAccountButton(BuildContext context);
}

enum CreateAccountErrorType {
  none,
  noEmail,
  badEmail,
  passwordRequirementsNotMet,
  unknownError,
}

enum CreateAccountPasswordRequirements {
  adequateLength,
  containsUppercase,
  containsLowercase,
  containsDigit,
  containsSpecial,
  matching,
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
    _checkPasswordRequirements(password);
  }

  @override
  void updatePasswordTwoField(String password) {
    _passwordTwo = password;
    _checkPasswordsMatch(_passwordOne, _passwordTwo);
  }

  @override
  Set<CreateAccountPasswordRequirements> get metPasswordRequirements =>
      _metPasswordRequirements;

  final Set<CreateAccountPasswordRequirements> _metPasswordRequirements = {};
  set _addMetPasswordRequirement(
    CreateAccountPasswordRequirements requirement,
  ) {
    _metPasswordRequirements.add(requirement);
    notifyListeners();
  }

  set _removeMetPasswordRequirement(
    CreateAccountPasswordRequirements requirement,
  ) {
    _metPasswordRequirements.remove(requirement);
    notifyListeners();
  }

  @override
  CreateAccountErrorType get validationMessage => _validationMessage;

  CreateAccountErrorType _validationMessage = CreateAccountErrorType.none;
  set _setValidationMessage(CreateAccountErrorType message) {
    _validationMessage = message;
    notifyListeners();
  }

  @override
  bool get hasAlert => _validationMessage != CreateAccountErrorType.none;

  void _checkPasswordRequirements(String password) {
    if (password.length >= 12) {
      _addMetPasswordRequirement =
          CreateAccountPasswordRequirements.adequateLength;
    } else {
      _removeMetPasswordRequirement =
          CreateAccountPasswordRequirements.adequateLength;
    }
    if (password.contains(RegExp(r'[A-Z]'))) {
      _addMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsUppercase;
    } else {
      _removeMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsUppercase;
    }
    if (password.contains(RegExp(r'[a-z]'))) {
      _addMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsLowercase;
    } else {
      _removeMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsLowercase;
    }
    if (password.contains(RegExp(r'[0-9]'))) {
      _addMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsDigit;
    } else {
      _removeMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsDigit;
    }
    if (password.contains(RegExp(r'[^a-zA-Z0-9]'))) {
      _addMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsSpecial;
    } else {
      _removeMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsSpecial;
    }
  }

  void _checkPasswordsMatch(String passwordOne, String passwordTwo) {
    if (passwordOne == passwordTwo) {
      _addMetPasswordRequirement = CreateAccountPasswordRequirements.matching;
    } else {
      _removeMetPasswordRequirement =
          CreateAccountPasswordRequirements.matching;
    }
  }

  bool _passwordIsValid() => metPasswordRequirements.containsAll(
    CreateAccountPasswordRequirements.values,
  );

  bool _isFormValid(String email, String passwordOne, String passwordTwo) {
    if (email.isEmpty) {
      _setValidationMessage = CreateAccountErrorType.noEmail;
      return false;
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    );
    if (!emailRegex.hasMatch(email)) {
      _setValidationMessage = CreateAccountErrorType.badEmail;
      return false;
    }
    if (!_passwordIsValid()) {
      _setValidationMessage = CreateAccountErrorType.passwordRequirementsNotMet;
      return false;
    }
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
          unawaited(context.pushNamed(Routes.createAccountConfirm.name));
        }
        loading.hide();
      case Error():
        _setValidationMessage = CreateAccountErrorType.unknownError;
        loading.hide();
    }
  }
}
