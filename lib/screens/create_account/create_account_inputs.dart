import 'package:flutter/material.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_spacing.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';

class CreateAccountInputs extends StatelessWidget {
  final CreateAccountViewmodel viewModel;

  const CreateAccountInputs({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppInput(
          placeholder: l10n.email,
          type: AppInputType.email,
          onChanged: (String email) => viewModel.updateEmailField(email),
        ),
        const AppSpacer.large(),
        AppInput(
          placeholder: l10n.password,
          type: AppInputType.password,
          onChanged: (String password) =>
              viewModel.updatePasswordOneField(password),
        ),
        AppInput(
          placeholder: l10n.confirmPassword,
          type: AppInputType.password,
          onChanged: (String password) =>
              viewModel.updatePasswordTwoField(password),
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
                message: _validationMessage(context),
                type: AppInlineAlertType.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _validationMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (viewModel.validationMessage) {
      case CreateAccountErrorType.badEmail:
        return l10n.createAccountErrorBadEmail;
      case CreateAccountErrorType.noEmail:
        return l10n.createAccountErrorNoEmail;
      case CreateAccountErrorType.noPassword:
        return l10n.createAccountErrorNoPassword;
      case CreateAccountErrorType.noPasswordNoEmail:
        return l10n.createAccountErrorNoPasswordNoEmail;
      case CreateAccountErrorType.passwordTooShort:
        return l10n.createAccountErrorPasswordTooShort;
      case CreateAccountErrorType.passwordNoUppercase:
        return l10n.createAccountErrorPasswordNoUppercase;
      case CreateAccountErrorType.passwordNoLowercase:
        return l10n.createAccountErrorPasswordNoLowercase;
      case CreateAccountErrorType.passwordNoDigit:
        return l10n.createAccountErrorPasswordNoDigit;
      case CreateAccountErrorType.passwordNoSpecial:
        return l10n.createAccountErrorPasswordNoSpecial;
      case CreateAccountErrorType.passwordsDontMatch:
        return l10n.createAccountErrorPasswordsDontMatch;
      case CreateAccountErrorType.none:
        return '';
    }
  }
}
