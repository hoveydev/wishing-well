import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/reset_password/reset_password_viewmodel.dart';

class ResetPasswordButton extends StatelessWidget {
  final ResetPasswordViewmodel viewmodel;

  const ResetPasswordButton({required this.viewmodel, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton.label(
          label: l10n.resetPasswordButtonLabel,
          onPressed: () => viewmodel.tapResetPasswordButton(context),
          type: AppButtonType.primary,
        ),
      ],
    );
  }
}
