import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_input.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_view_model.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({required this.viewModel, super.key});
  final ForgotPasswordViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.forgotPasswordScreenHeader,
          style: textTheme.headlineLarge,
          textAlign: TextAlign.center,
          semanticsLabel: l10n.forgotPasswordScreenHeader,
        ),
        Text(
          l10n.forgotPasswordScreenSubtext,
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
          semanticsLabel: l10n.forgotPasswordScreenSubtext,
        ),
        const AppSpacer.large(),
        ForgotPasswordInput(viewModel: viewModel),
      ],
    );
  }
}
