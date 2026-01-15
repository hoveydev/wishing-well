import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/create_account/create_account_inputs.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';

class CreateAccountHeader extends StatelessWidget {
  const CreateAccountHeader({required this.viewModel, super.key});
  final CreateAccountViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.createAccountScreenHeader,
          style: textTheme.headlineLarge,
          textAlign: TextAlign.center,
          semanticsLabel: l10n.createAccountScreenHeader,
        ),
        Text(
          l10n.loginScreenSubtext,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
          semanticsLabel: l10n.loginScreenSubtext,
        ),
        const AppSpacer.large(),
        CreateAccountInputs(viewModel: viewModel),
      ],
    );
  }
}
