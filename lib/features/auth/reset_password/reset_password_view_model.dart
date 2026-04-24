import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/features/shared/screen_view_model_contract.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/input_validators.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';
import 'package:wishing_well/utils/password_validator.dart';
import 'package:wishing_well/utils/result.dart';

abstract class ResetPasswordViewModelContract
    implements ScreenViewModelContract {
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

class ResetPasswordViewModel extends ChangeNotifier
    implements ResetPasswordViewModelContract {
  ResetPasswordViewModel({
    required AuthRepository authRepository,
    required this.email,
  }) : _authRepository = authRepository,
       _passwordValidator = PasswordValidator<ResetPasswordRequirements>(),
       _cachedMetRequirements = null {
    // Listen to PasswordValidator changes and forward to ViewModel
    _passwordValidator.addListener(_onPasswordValidatorChanged);
  }
  final AuthRepository _authRepository;
  final PasswordValidator<ResetPasswordRequirements> _passwordValidator;
  final String email;

  String _passwordOne = '';
  String _passwordTwo = '';

  // Cache metPasswordRequirements Set to provide a stable reference
  // for ListenableBuilder. Without this, the getter returns a new Set
  // reference each time, which prevents UI rebuilds.
  Set<ResetPasswordRequirements>? _cachedMetRequirements;

  // Called when PasswordValidator notifies listeners
  void _onPasswordValidatorChanged() {
    // Invalidate cache so the getter returns the updated requirements
    _cachedMetRequirements = null;
    // Forward the notification to this ViewModel's listeners (UI)
    notifyListeners();
  }

  @override
  void dispose() {
    _passwordValidator.removeListener(_onPasswordValidatorChanged);
    super.dispose();
  }

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
  Set<ResetPasswordRequirements> get metPasswordRequirements {
    _cachedMetRequirements ??= _passwordValidator.metRequirements;
    return _cachedMetRequirements!;
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
    AppLogger.debug(
      'Navigating to login screen',
      context: 'ResetPasswordViewModel.tapCloseButton',
    );
    context.goNamed(Routes.login.name);
  }

  @override
  Future<void> tapResetPasswordButton(BuildContext context) async {
    final loading = context.read<StatusOverlayController>();
    if (!_isFormValid()) {
      AppLogger.warning(
        'Password reset failed: $_authError',
        context: 'ResetPasswordViewModel.tapResetPasswordButton',
      );
      return;
    }

    loading.show();

    final response = await _authRepository.resetUserPassword(
      email: email,
      newPassword: _passwordOne,
    );

    switch (response) {
      case Ok():
        AppLogger.info(
          'Password reset successful',
          context: 'ResetPasswordViewModel.tapResetPasswordButton',
        );
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          loading.showSuccess(
            l10n.resetPasswordConfirmationMessage,
            onOk: () {
              AppLogger.debug(
                'Navigating to login screen',
                context: 'ResetPasswordViewModel.tapResetPasswordButton',
              );
              context.goNamed(Routes.login.name);
            },
          );
        }
      case Error(:final Exception error):
        AppLogger.error(
          'Password reset failed',
          context: 'ResetPasswordViewModel.tapResetPasswordButton',
          error: error,
        );
        if (!context.mounted) return;
        final l10n = AppLocalizations.of(context)!;
        if (error is AuthApiException) {
          _apiError = SupabaseAuthError(error.message);
          _updateCombinedError();
          loading.showError(error.message);
        } else {
          _apiError = const UIAuthError(ResetPasswordErrorType.unknown);
          _updateCombinedError();
          loading.showError(l10n.errorUnknown);
        }
    }
  }
}
