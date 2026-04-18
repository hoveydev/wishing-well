import 'package:flutter/material.dart';
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
import 'package:wishing_well/utils/result.dart';

abstract class ForgotPasswordViewModelContract
    implements ScreenViewModelContract {
  void updateEmailField(String email);
  bool get hasAlert;
  AuthError<ForgotPasswordErrorType> get authError;
  void clearError();
  Future<void> tapSendResetLinkButton(BuildContext context);
  void tapDismissButton(BuildContext context);
}

class ForgotPasswordViewModel extends ChangeNotifier
    implements ForgotPasswordViewModelContract {
  ForgotPasswordViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  String _email = '';

  AuthError<ForgotPasswordErrorType> _emailError = const UIAuthError(
    ForgotPasswordErrorType.none,
  );
  AuthError<ForgotPasswordErrorType>? _apiError;

  @override
  void updateEmailField(String email) {
    _email = email;
    _clearApiError();
    _validateEmail();
    _updateCombinedError();
  }

  @override
  AuthError<ForgotPasswordErrorType> get authError => _authError;

  AuthError<ForgotPasswordErrorType> _authError = const UIAuthError(
    ForgotPasswordErrorType.none,
  );
  set _setAuthError(AuthError<ForgotPasswordErrorType> error) {
    _authError = error;
    notifyListeners();
  }

  @override
  bool get hasAlert =>
      _authError != const UIAuthError(ForgotPasswordErrorType.none);

  @override
  void clearError() {
    _emailError = const UIAuthError(ForgotPasswordErrorType.none);
    _apiError = null;
    _updateCombinedError();
  }

  void _clearApiError() {
    _apiError = null;
  }

  void _validateEmail() {
    if (InputValidators.isEmailEmpty(_email)) {
      _emailError = const UIAuthError(ForgotPasswordErrorType.noEmail);
      return;
    }
    if (!InputValidators.isEmailValid(_email)) {
      _emailError = const UIAuthError(ForgotPasswordErrorType.badEmail);
      return;
    }
    _emailError = const UIAuthError(ForgotPasswordErrorType.none);
  }

  void _updateCombinedError() {
    AuthError<ForgotPasswordErrorType> error;
    if (_apiError != null) {
      error = _apiError!;
    } else if (_emailError != const UIAuthError(ForgotPasswordErrorType.none)) {
      error = _emailError;
    } else {
      error = const UIAuthError(ForgotPasswordErrorType.none);
    }
    if (error != _authError) {
      _setAuthError = error;
    }
  }

  bool _isEmailValid() {
    _validateEmail();
    _updateCombinedError();
    return _apiError == null &&
        _emailError == const UIAuthError(ForgotPasswordErrorType.none);
  }

  @override
  Future<void> tapSendResetLinkButton(BuildContext context) async {
    final loading = context.read<StatusOverlayController>();
    if (!_isEmailValid()) {
      AppLogger.warning(
        'Email validation failed: $_authError',
        context: 'ForgotPasswordViewModel.tapSendResetLinkButton',
      );
      return;
    }

    loading.show();

    final response = await _authRepository.sendPasswordResetRequest(
      email: _email,
    );

    switch (response) {
      case Ok():
        AppLogger.info(
          'Password reset email sent',
          context: 'ForgotPasswordViewModel.tapSendResetLinkButton',
        );
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          loading.showSuccess(
            l10n.forgotPasswordConfirmationMessage,
            onOk: () {
              AppLogger.debug(
                'Navigating to login screen',
                context: 'ForgotPasswordViewModel.tapSendResetLinkButton',
              );
              context.goNamed(Routes.login.name);
            },
          );
        }
      case Error(:final error):
        AppLogger.error(
          'Failed to send password reset email',
          context: 'ForgotPasswordViewModel.tapSendResetLinkButton',
          error: error,
        );
        if (!context.mounted) return;
        final l10n = AppLocalizations.of(context)!;
        if (error is AuthApiException) {
          _apiError = SupabaseAuthError(error.message);
          _updateCombinedError();
          loading.showError(error.message);
        } else {
          _apiError = const UIAuthError(ForgotPasswordErrorType.unknown);
          _updateCombinedError();
          loading.showError(l10n.errorUnknown);
        }
    }
  }

  @override
  void tapDismissButton(BuildContext context) {
    context.pop();
  }
}
