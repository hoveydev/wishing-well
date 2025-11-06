import 'package:flutter/material.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_spacing.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/login/login_viewmodel.dart';

class LoginInputs extends StatelessWidget {

  final LoginViewModel viewModel;

  const LoginInputs({
    super.key,
    required this.viewModel
  });

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
          onChanged: (String val) => viewModel.updateEmailField(val),
        ),
        AppInput(
          placeholder: l10n.password,
          type: AppInputType.password,
          onChanged: (String val) => viewModel.updatePasswordField(val),
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
              )
            )
          )
        )
      ],
    );
  }

  String _validationMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (viewModel.validationMessage) {
      case LoginErrorType.noPasswordNoEmail:
        return l10n.loginErrorNoPasswordNoEmail;
      case LoginErrorType.noEmail:
        return l10n.loginErrorNoEmnail;
      case LoginErrorType.noPassword:
        return l10n.loginErrorNoPassword;
      case LoginErrorType.badEmail:
        return l10n.loginErrorBadEmail;
      case LoginErrorType.none:
        return "";
    }
  }
}