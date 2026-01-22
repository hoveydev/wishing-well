import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/input_validators.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/password_validator.dart';
import 'package:wishing_well/utils/result.dart';

abstract class ResetPasswordViewmodelContract {
  void updatePasswordOneField(String password);
  void updatePasswordTwoField(String password);
  bool get hasAlert;
  AuthError<ResetPasswordErrorType> get authError;
  void clearError();
  Set<ResetPasswordRequirements> get metPasswordRequirements;
  Future<void> tapResetPasswordButton(BuildContext context);
  void tapCloseButton(BuildContext context);
}

enum ResetPasswordRequirements {
  adequateLength,
  containsUppercase,
  containsLowercase,
  containsDigit,
  containsSpecial,
  matching,
}

class ResetPasswordViewmodel extends ChangeNotifier
    implements ResetPasswordViewmodelContract {
  ResetPasswordViewmodel({
    required AuthRepository authRepository,
    required this.email,
    required this.token,
  }) : _authRepository = authRepository,
       _passwordValidator = PasswordValidator<ResetPasswordRequirements>();
  final AuthRepository _authRepository;
  final PasswordValidator<ResetPasswordRequirements> _passwordValidator;
  final String email;
  final String token;

  String _passwordOne = '';
  String _passwordTwo = '';

  AuthError<ResetPasswordErrorType> _passwordError = const UIAuthError(
    ResetPasswordErrorType.none,
  );
  AuthError<ResetPasswordErrorType>? _apiError;

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
  Set<ResetPasswordRequirements> get metPasswordRequirements =>
      _passwordValidator.metRequirements;

  @override
  AuthError<ResetPasswordErrorType> get authError => _authError;

  AuthError<ResetPasswordErrorType> _authError = const UIAuthError(
    ResetPasswordErrorType.none,
  );
  set _setAuthError(AuthError<ResetPasswordErrorType> error) {
    _authError = error;
    notifyListeners();
  }

  @override
  bool get hasAlert =>
      _authError != const UIAuthError(ResetPasswordErrorType.none);

  @override
  void clearError() {
    _passwordError = const UIAuthError(ResetPasswordErrorType.none);
    _apiError = null;
    _updateCombinedError();
  }

  void _clearApiError() {
    _apiError = null;
  }

  void _validatePassword() {
    if (!_passwordIsValid()) {
      _passwordError = const UIAuthError(
        ResetPasswordErrorType.passwordRequirementsNotMet,
      );
    } else {
      _passwordError = const UIAuthError(ResetPasswordErrorType.none);
    }
  }

  void _updateCombinedError() {
    AuthError<ResetPasswordErrorType> error;
    if (_apiError != null) {
      error = _apiError!;
    } else if (_passwordError !=
        const UIAuthError(ResetPasswordErrorType.none)) {
      error = _passwordError;
    } else {
      error = const UIAuthError(ResetPasswordErrorType.none);
    }
    if (error != _authError) {
      _setAuthError = error;
    }
  }

  void _checkPasswordRequirements(String password) {
    final requirements = {
      ResetPasswordRequirements.adequateLength:
          InputValidators.hasAdequateLength,
      ResetPasswordRequirements.containsUppercase: InputValidators.hasUppercase,
      ResetPasswordRequirements.containsLowercase: InputValidators.hasLowercase,
      ResetPasswordRequirements.containsDigit: InputValidators.hasDigit,
      ResetPasswordRequirements.containsSpecial:
          InputValidators.hasSpecialCharacter,
    };
    _passwordValidator.checkRequirements(password, requirements);
  }

  void _checkPasswordsMatch(String passwordOne, String passwordTwo) {
    _passwordValidator.checkPasswordsMatch(
      passwordOne,
      passwordTwo,
      ResetPasswordRequirements.matching,
    );
  }

  bool _passwordIsValid() =>
      metPasswordRequirements.containsAll(ResetPasswordRequirements.values);

  bool _isFormValid() {
    _validatePassword();
    _updateCombinedError();
    return _apiError == null &&
        _passwordError == const UIAuthError(ResetPasswordErrorType.none);
  }

  @override
  void tapCloseButton(BuildContext context) {
    // TODO: open modal
    // might not be on context
    context.goNamed(Routes.login.name);
  }

  @override
  Future<void> tapResetPasswordButton(BuildContext context) async {
    final loading = context.read<LoadingController>();
    if (!_isFormValid()) {
      log('Sign up failed: $_authError');
      return;
    }

    loading.show();

    final response = await _authRepository.resetUserPassword(
      email: email,
      newPassword: _passwordOne,
      token: token,
    );

    switch (response) {
      case Ok():
        if (context.mounted) {
          unawaited(context.pushNamed(Routes.resetPasswordConfirmation.name));
        }
        loading.hide();
      case Error(:final Exception error):
        log(error.toString());
        if (error is AuthApiException) {
          _apiError = SupabaseAuthError(error.message);
          _updateCombinedError();
        } else {
          _apiError = const UIAuthError(ResetPasswordErrorType.unknown);
          _updateCombinedError();
        }
        loading.hide();
    }
  }
}
