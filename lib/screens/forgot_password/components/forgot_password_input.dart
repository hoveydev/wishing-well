import 'package:flutter/material.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_spacing.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_view_model.dart';
import 'package:wishing_well/utils/auth_error.dart';

class ForgotPasswordInput extends StatelessWidget {
  const ForgotPasswordInput({required this.viewModel, super.key});
  final ForgotPasswordViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppInput(
          placeholder: l10n.authEmail,
          type: AppInputType.email,
          onChanged: (String val) => viewModel.updateEmailField(val),
        ),
        ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) => Visibility(
            visible: viewModel.hasAlert,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Padding(
              padding: AppInlineAlertSpacing.inputPadding,
              child: AppInlineAlert(
                message: _validationMessage(l10n),
                type: AppInlineAlertType.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _validationMessage(AppLocalizations l10n) =>
      switch (viewModel.authError) {
        UIAuthError(:final type) => switch (type) {
          ForgotPasswordErrorType.noEmail => l10n.errorEmailRequired,
          ForgotPasswordErrorType.badEmail => l10n.errorInvalidEmail,
          ForgotPasswordErrorType.unknown => l10n.errorUnknown,
          ForgotPasswordErrorType.none => '',
        },
        SupabaseAuthError(:final message) => message,
      };
}
