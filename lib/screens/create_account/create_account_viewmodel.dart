import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/input_validators.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';
import 'package:wishing_well/routing/routes.dart';

abstract class CreateAccountViewmodelContract {
  void updateEmailField(String email);
  void updatePasswordOneField(String password);
  void updatePasswordTwoField(String password);
  bool get hasAlert;
  AuthError<CreateAccountErrorType> get authError;
  Set<CreateAccountPasswordRequirements> get metPasswordRequirements;
  Future<void> tapCreateAccountButton(BuildContext context);
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
  AuthError<CreateAccountErrorType> get authError => _authError;

  AuthError<CreateAccountErrorType> _authError = const UIAuthError(
    CreateAccountErrorType.none,
  );
  set _setAuthError(AuthError<CreateAccountErrorType> error) {
    _authError = error;
    notifyListeners();
  }

  @override
  bool get hasAlert =>
      _authError != const UIAuthError(CreateAccountErrorType.none);

  void _checkPasswordRequirements(String password) {
    if (InputValidators.hasAdequateLength(password)) {
      _addMetPasswordRequirement =
          CreateAccountPasswordRequirements.adequateLength;
    } else {
      _removeMetPasswordRequirement =
          CreateAccountPasswordRequirements.adequateLength;
    }
    if (InputValidators.hasUppercase(password)) {
      _addMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsUppercase;
    } else {
      _removeMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsUppercase;
    }
    if (InputValidators.hasLowercase(password)) {
      _addMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsLowercase;
    } else {
      _removeMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsLowercase;
    }
    if (InputValidators.hasDigit(password)) {
      _addMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsDigit;
    } else {
      _removeMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsDigit;
    }
    if (InputValidators.hasSpecialCharacter(password)) {
      _addMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsSpecial;
    } else {
      _removeMetPasswordRequirement =
          CreateAccountPasswordRequirements.containsSpecial;
    }
  }

  void _checkPasswordsMatch(String passwordOne, String passwordTwo) {
    if (InputValidators.passwordsMatch(passwordOne, passwordTwo)) {
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
    if (InputValidators.isEmailEmpty(email)) {
      _setAuthError = const UIAuthError(CreateAccountErrorType.noEmail);
      return false;
    }
    if (!InputValidators.isEmailValid(email)) {
      _setAuthError = const UIAuthError(CreateAccountErrorType.badEmail);
      return false;
    }
    if (!_passwordIsValid()) {
      _setAuthError = const UIAuthError(
        CreateAccountErrorType.passwordRequirementsNotMet,
      );
      return false;
    }
    _setAuthError = const UIAuthError(CreateAccountErrorType.none);
    return true;
  }

  @override
  Future<void> tapCreateAccountButton(BuildContext context) async {
    final loading = context.read<LoadingController>();
    if (!_isFormValid(_email, _passwordOne, _passwordTwo)) {
      log('Sign up failed: $_authError');
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
      case Error(:final error):
        log(error.toString());
        if (error is AuthApiException) {
          _setAuthError = SupabaseAuthError(error.message);
        } else {
          _setAuthError = const UIAuthError(CreateAccountErrorType.unknown);
        }
        loading.hide();
    }
  }
}
