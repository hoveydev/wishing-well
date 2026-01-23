import 'package:flutter/material.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/reset_password/reset_password_view_model.dart';
import 'package:wishing_well/utils/auth_error.dart';

class ResetPasswordInlineError extends StatelessWidget {
  const ResetPasswordInlineError({required this.viewModel, super.key});
  final ResetPasswordViewModel viewModel;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: viewModel,
    builder: (context, _) => Visibility(
      visible: viewModel.hasAlert,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: AppInlineAlert(
        message: _validationMessage(context),
        type: AppInlineAlertType.error,
      ),
    ),
  );

  String _validationMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return switch (viewModel.authError) {
      UIAuthError(:final type) => switch (type) {
        ResetPasswordErrorType.passwordRequirementsNotMet =>
          l10n.errorPasswordRequirements,
        ResetPasswordErrorType.unknown => l10n.errorUnknown,
        ResetPasswordErrorType.none => '',
      },
      SupabaseAuthError(:final message) => message,
    };
  }
}
