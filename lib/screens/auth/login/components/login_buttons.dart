import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/auth/login/login_view_model.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({required this.viewModel, super.key});
  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.label(
          label: l10n.authSignIn,
          onPressed: () => viewModel.tapLoginButton(context),
          type: AppButtonType.primary,
        ),
        AppButton.label(
          label: l10n.authCreateAccount,
          onPressed: () => viewModel.tapCreateAccountButton(context),
          type: AppButtonType.secondary,
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacerSize.small),
          child: AppButton.label(
            label: l10n.authForgotPassword,
            onPressed: () => viewModel.tapForgotPasswordButton(context),
            type: AppButtonType.tertiary,
          ),
        ),
      ],
    );
  }
}
