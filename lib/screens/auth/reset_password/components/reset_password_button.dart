import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/auth/reset_password/reset_password_view_model.dart';

class ResetPasswordButton extends StatelessWidget {
  const ResetPasswordButton({required this.viewModel, super.key});
  final ResetPasswordViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton.label(
          label: l10n.authResetPassword,
          onPressed: () => viewModel.tapResetPasswordButton(context),
          type: AppButtonType.primary,
        ),
      ],
    );
  }
}
