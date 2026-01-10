import 'package:flutter/material.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/reset_password/reset_password_viewmodel.dart';

class ResetPasswordInputs extends StatelessWidget {
  const ResetPasswordInputs({required this.viewmodel, super.key});
  final ResetPasswordViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppInput(
          placeholder: l10n.authPassword,
          type: AppInputType.password,
          onChanged: (String password) =>
              viewmodel.updatePasswordOneField(password),
        ),
        AppInput(
          placeholder: l10n.authConfirmPassword,
          type: AppInputType.password,
          onChanged: (String password) =>
              viewmodel.updatePasswordTwoField(password),
        ),
      ],
    );
  }
}
