import 'package:flutter/material.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_spacing.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/reset_password/reset_password_viewmodel.dart';

class ResetPasswordInputs extends StatelessWidget {
  final ResetPasswordViewmodel viewmodel;

  const ResetPasswordInputs({required this.viewmodel, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppInput(
          placeholder: l10n.password,
          type: AppInputType.password,
          onChanged: (String password) =>
              viewmodel.updatePasswordOneField(password),
        ),
        AppInput(
          placeholder: l10n.confirmPassword,
          type: AppInputType.password,
          onChanged: (String password) =>
              viewmodel.updatePasswordTwoField(password),
        ),
        ListenableBuilder(
          listenable: viewmodel,
          builder: (context, _) => Visibility(
            visible: viewmodel.hasAlert,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Padding(
              padding: AppInlineAlertSpacing.inputPadding,
              child: AppInlineAlert(
                message: _validationMessage(context, l10n),
                type: AppInlineAlertType.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _validationMessage(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    switch (viewmodel.validationMessage) {
      case ResetPasswordErrorType.noPassword:
        return localizations.resetPasswordErrorNoPassword;
      case ResetPasswordErrorType.passwordNoDigit:
        return localizations.resetPasswordErrorPasswordNoDigit;
      case ResetPasswordErrorType.passwordNoLowercase:
        return localizations.resetPasswordErrorPasswordNoLowercase;
      case ResetPasswordErrorType.passwordNoSpecial:
        return localizations.resetPasswordErrorPasswordNoSpecial;
      case ResetPasswordErrorType.passwordNoUppercase:
        return localizations.resetPasswordErrorPasswordNoUppercase;
      case ResetPasswordErrorType.passwordTooShort:
        return localizations.resetPasswordErrorPasswordTooShort;
      case ResetPasswordErrorType.passwordsDontMatch:
        return localizations.resetPasswordErrorPasswordsDontMatch;
      case ResetPasswordErrorType.unknownError:
        return localizations.resetPasswordErrorUnknown;
      case ResetPasswordErrorType.none:
        return '';
    }
  }
}
