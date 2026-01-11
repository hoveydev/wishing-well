import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/create_account/create_account_inline_error.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';
import 'package:wishing_well/theme/app_theme.dart';

class CreateAccountPasswordChecklist extends StatelessWidget {
  const CreateAccountPasswordChecklist({required this.viewModel, super.key});
  final CreateAccountViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = context.colorScheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (_, _) {
        final bool minimumCharsSatisfied = viewModel.metPasswordRequirements
            .contains(CreateAccountPasswordRequirements.adequateLength);
        final bool uppercaseSatisfied = viewModel.metPasswordRequirements
            .contains(CreateAccountPasswordRequirements.containsUppercase);
        final bool lowercaseSatisfied = viewModel.metPasswordRequirements
            .contains(CreateAccountPasswordRequirements.containsLowercase);
        final bool digitSatisfied = viewModel.metPasswordRequirements.contains(
          CreateAccountPasswordRequirements.containsDigit,
        );
        final bool specialCharSatisfied = viewModel.metPasswordRequirements
            .contains(CreateAccountPasswordRequirements.containsSpecial);
        final bool passwordsMatchSatisfied = viewModel.metPasswordRequirements
            .contains(CreateAccountPasswordRequirements.matching);
        final textTheme = Theme.of(context).textTheme;

        return Column(
          children: [
            Row(
              children: [
                Text(
                  l10n.passwordRequirementsHeader,
                  style: textTheme.titleMedium,
                ),
              ],
            ),
            const AppSpacer.medium(),
            buildChecklistItem(
              context,
              l10n.passwordRequirementsMinChars,
              minimumCharsSatisfied,
            ),
            const AppSpacer.xsmall(),
            buildChecklistItem(
              context,
              l10n.passwordRequirementsUppercase,
              uppercaseSatisfied,
            ),
            const AppSpacer.xsmall(),
            buildChecklistItem(
              context,
              l10n.passwordRequirementsLowercase,
              lowercaseSatisfied,
            ),
            const AppSpacer.xsmall(),
            buildChecklistItem(
              context,
              l10n.passwordRequirementsDigit,
              digitSatisfied,
            ),
            const AppSpacer.xsmall(),
            buildChecklistItem(
              context,
              l10n.passwordRequirementsSpecialChar,
              specialCharSatisfied,
            ),
            const AppSpacer.xsmall(),
            buildChecklistItem(
              context,
              l10n.passwordRequirementsMatching,
              passwordsMatchSatisfied,
            ),
            Divider(color: colorScheme.primary, thickness: 0.5),
            CreateAccountInlineError(viewModel: viewModel),
            const AppSpacer.large(),
          ],
        );
      },
    );
  }

  Widget buildChecklistItem(
    BuildContext context,
    String text,
    bool passwordRequirement,
  ) {
    final colorScheme = context.colorScheme;

    return Row(
      children: [
        if (passwordRequirement)
          Icon(Icons.check, color: colorScheme.success)
        else
          Icon(Icons.circle_outlined, color: colorScheme.primary),
        const AppSpacer.small(),
        Text(text),
      ],
    );
  }
}
