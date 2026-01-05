import 'package:flutter/material.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';

class CreateAccountInputs extends StatelessWidget {
  const CreateAccountInputs({required this.viewModel, super.key});
  final CreateAccountViewmodel viewModel;

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
      ],
    );
  }
}
