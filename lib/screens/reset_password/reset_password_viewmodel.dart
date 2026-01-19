import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/input_validators.dart';
import 'package:wishing_well/utils/loading_controller.dart';
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
  }) : _authRepository = authRepository;
  final AuthRepository _authRepository;
  final String email;
  final String token;

  String _passwordOne = '';
  String _passwordTwo = '';

  @override
  void updatePasswordOneField(String password) {
    if (_passwordOne != password) {
      clearError();
    }
    _passwordOne = password;
    _checkPasswordRequirements(password);
  }

  @override
  void updatePasswordTwoField(String password) {
    if (_passwordTwo != password) {
      clearError();
    }
    _passwordTwo = password;
    _checkPasswordsMatch(_passwordOne, _passwordTwo);
  }

  @override
  Set<ResetPasswordRequirements> get metPasswordRequirements =>
      _metPasswordRequirements;

  final Set<ResetPasswordRequirements> _metPasswordRequirements = {};
  set _addMetPasswordRequirement(ResetPasswordRequirements requirement) {
    _metPasswordRequirements.add(requirement);
    notifyListeners();
  }

  set _removeMetPasswordRequirement(ResetPasswordRequirements requirement) {
    _metPasswordRequirements.remove(requirement);
    notifyListeners();
  }

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
    _setAuthError = const UIAuthError(ResetPasswordErrorType.none);
  }

  void _checkPasswordRequirements(String password) {
    if (InputValidators.hasAdequateLength(password)) {
      _addMetPasswordRequirement = ResetPasswordRequirements.adequateLength;
    } else {
      _removeMetPasswordRequirement = ResetPasswordRequirements.adequateLength;
    }
    if (InputValidators.hasUppercase(password)) {
      _addMetPasswordRequirement = ResetPasswordRequirements.containsUppercase;
    } else {
      _removeMetPasswordRequirement =
          ResetPasswordRequirements.containsUppercase;
    }
    if (InputValidators.hasLowercase(password)) {
      _addMetPasswordRequirement = ResetPasswordRequirements.containsLowercase;
    } else {
      _removeMetPasswordRequirement =
          ResetPasswordRequirements.containsLowercase;
    }
    if (InputValidators.hasDigit(password)) {
      _addMetPasswordRequirement = ResetPasswordRequirements.containsDigit;
    } else {
      _removeMetPasswordRequirement = ResetPasswordRequirements.containsDigit;
    }
    if (InputValidators.hasSpecialCharacter(password)) {
      _addMetPasswordRequirement = ResetPasswordRequirements.containsSpecial;
    } else {
      _removeMetPasswordRequirement = ResetPasswordRequirements.containsSpecial;
    }
  }

  void _checkPasswordsMatch(String passwordOne, String passwordTwo) {
    if (InputValidators.passwordsMatch(passwordOne, passwordTwo)) {
      _addMetPasswordRequirement = ResetPasswordRequirements.matching;
    } else {
      _removeMetPasswordRequirement = ResetPasswordRequirements.matching;
    }
  }

  bool _passwordIsValid() {
    _setAuthError = const UIAuthError(
      ResetPasswordErrorType.passwordRequirementsNotMet,
    );
    return metPasswordRequirements.containsAll(
      ResetPasswordRequirements.values,
    );
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
    if (!_passwordIsValid()) {
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
          _setAuthError = SupabaseAuthError(error.message);
        } else {
          _setAuthError = const UIAuthError(ResetPasswordErrorType.unknown);
        }
        loading.hide();
    }
  }
}
