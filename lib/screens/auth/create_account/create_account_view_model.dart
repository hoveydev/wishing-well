import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/input_validators.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/password_validator.dart';
import 'package:wishing_well/utils/result.dart';
import 'package:wishing_well/routing/routes.dart';

abstract class CreateAccountViewModelContract {
  void updateEmailField(String email);
  void updatePasswordOneField(String password);
  void updatePasswordTwoField(String password);
  bool get hasAlert;
  AuthError<CreateAccountErrorType> get authError;
  void clearError();
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

class CreateAccountViewModel extends ChangeNotifier
    implements CreateAccountViewModelContract {
  CreateAccountViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository,
      _passwordValidator =
          PasswordValidator<CreateAccountPasswordRequirements>() {
    // Listen to PasswordValidator changes and forward to Viewmodel
    _passwordValidator.addListener(_onPasswordValidatorChanged);
  }

  final AuthRepository _authRepository;
  final PasswordValidator<CreateAccountPasswordRequirements> _passwordValidator;

  String _email = '';
  String _passwordOne = '';
  String _passwordTwo = '';

  // Cache metPasswordRequirements Set to provide a stable reference
  // for ListenableBuilder. Without this, the getter returns a new Set
  // reference each time, which prevents UI rebuilds.
  Set<CreateAccountPasswordRequirements>? _cachedMetRequirements;

  // Called when PasswordValidator notifies listeners
  void _onPasswordValidatorChanged() {
    // Invalidate cache so the getter returns the updated requirements
    _cachedMetRequirements = null;
    // Forward the notification to this Viewmodel's listeners (UI)
    notifyListeners();
  }

  @override
  void dispose() {
    _passwordValidator.removeListener(_onPasswordValidatorChanged);
    super.dispose();
  }

  AuthError<CreateAccountErrorType> _emailError = const UIAuthError(
    CreateAccountErrorType.none,
  );
  AuthError<CreateAccountErrorType> _passwordError = const UIAuthError(
    CreateAccountErrorType.none,
  );
  AuthError<CreateAccountErrorType>? _apiError;

  @override
  void updateEmailField(String email) {
    _email = email;
    _clearApiError();
    _validateEmail();
    _updateCombinedError();
  }

  @override
  void updatePasswordOneField(String password) {
    _passwordOne = password;
    _clearApiError();
    _checkPasswordRequirements(password);
    _checkPasswordsMatch(_passwordOne, _passwordTwo);
    _validatePassword();
    _updateCombinedError();
  }

  @override
  void updatePasswordTwoField(String password) {
    _passwordTwo = password;
    _clearApiError();
    _checkPasswordsMatch(_passwordOne, _passwordTwo);
    _validatePassword();
    _updateCombinedError();
  }

  @override
  Set<CreateAccountPasswordRequirements> get metPasswordRequirements {
    _cachedMetRequirements ??= _passwordValidator.metRequirements;
    return _cachedMetRequirements!;
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

  @override
  void clearError() {
    _emailError = const UIAuthError(CreateAccountErrorType.none);
    _passwordError = const UIAuthError(CreateAccountErrorType.none);
    _apiError = null;
    _updateCombinedError();
  }

  void _clearApiError() {
    _apiError = null;
  }

  void _validateEmail() {
    if (InputValidators.isEmailEmpty(_email)) {
      _emailError = const UIAuthError(CreateAccountErrorType.noEmail);
      return;
    }
    if (!InputValidators.isEmailValid(_email)) {
      _emailError = const UIAuthError(CreateAccountErrorType.badEmail);
      return;
    }
    _emailError = const UIAuthError(CreateAccountErrorType.none);
  }

  void _validatePassword() {
    if (!_passwordIsValid()) {
      _passwordError = const UIAuthError(
        CreateAccountErrorType.passwordRequirementsNotMet,
      );
    } else {
      _passwordError = const UIAuthError(CreateAccountErrorType.none);
    }
  }

  void _updateCombinedError() {
    AuthError<CreateAccountErrorType> error;
    if (_apiError != null) {
      error = _apiError!;
    } else if (_emailError != const UIAuthError(CreateAccountErrorType.none)) {
      error = _emailError;
    } else if (_passwordError !=
        const UIAuthError(CreateAccountErrorType.none)) {
      error = _passwordError;
    } else {
      error = const UIAuthError(CreateAccountErrorType.none);
    }
    if (error != _authError) {
      _setAuthError = error;
    }
  }

  void _checkPasswordRequirements(String password) {
    final requirements = {
      CreateAccountPasswordRequirements.adequateLength:
          InputValidators.hasAdequateLength,
      CreateAccountPasswordRequirements.containsUppercase:
          InputValidators.hasUppercase,
      CreateAccountPasswordRequirements.containsLowercase:
          InputValidators.hasLowercase,
      CreateAccountPasswordRequirements.containsDigit: InputValidators.hasDigit,
      CreateAccountPasswordRequirements.containsSpecial:
          InputValidators.hasSpecialCharacter,
    };
    _passwordValidator.checkRequirements(password, requirements);
  }

  void _checkPasswordsMatch(String passwordOne, String passwordTwo) {
    _passwordValidator.checkPasswordsMatch(
      passwordOne,
      passwordTwo,
      CreateAccountPasswordRequirements.matching,
    );
  }

  bool _passwordIsValid() => metPasswordRequirements.containsAll(
    CreateAccountPasswordRequirements.values,
  );

  bool _isFormValid() {
    _validateEmail();
    _validatePassword();
    _updateCombinedError();
    return _apiError == null &&
        _emailError == const UIAuthError(CreateAccountErrorType.none) &&
        _passwordError == const UIAuthError(CreateAccountErrorType.none);
  }

  @override
  Future<void> tapCreateAccountButton(BuildContext context) async {
    final loading = context.read<LoadingController>();
    if (!_isFormValid()) {
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
          _apiError = SupabaseAuthError(error.message);
          _updateCombinedError();
        } else {
          _apiError = const UIAuthError(CreateAccountErrorType.unknown);
          _updateCombinedError();
        }
        loading.hide();
    }
  }
}
