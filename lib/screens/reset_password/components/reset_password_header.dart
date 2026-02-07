import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/reset_password/components/reset_password_inputs.dart';
import 'package:wishing_well/screens/reset_password/reset_password_view_model.dart';

class ResetPasswordHeader extends StatelessWidget {
  const ResetPasswordHeader({required this.viewModel, super.key});
  final ResetPasswordViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.authResetPassword,
          style: textTheme.headlineLarge,
          textAlign: TextAlign.center,
          semanticsLabel: l10n.authResetPassword,
        ),
        Text(
          l10n.resetPasswordScreenSubtext,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
          semanticsLabel: l10n.resetPasswordScreenSubtext,
        ),
        const AppSpacer.large(),
        ResetPasswordInputs(viewModel: viewModel),
      ],
    );
  }
}
