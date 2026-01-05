import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/reset_password/reset_password_viewmodel.dart';
import 'package:wishing_well/theme/app_theme.dart';

class ResetPasswordChecklist extends StatelessWidget {
  const ResetPasswordChecklist({required this.viewModel, super.key});
  final ResetPasswordViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = context.colorScheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (_, _) {
        final bool minimumCharsSatisfied = viewModel.metPasswordRequirements
            .contains(ResetPasswordRequirements.adequateLength);
        final bool uppercaseSatisfied = viewModel.metPasswordRequirements
            .contains(ResetPasswordRequirements.containsUppercase);
        final bool lowercaseSatisfied = viewModel.metPasswordRequirements
            .contains(ResetPasswordRequirements.containsLowercase);
        final bool digitSatisfied = viewModel.metPasswordRequirements.contains(
          ResetPasswordRequirements.containsDigit,
        );
        final bool specialCharSatisfied = viewModel.metPasswordRequirements
            .contains(ResetPasswordRequirements.containsSpecial);
        final bool passwordsMatchSatisfied = viewModel.metPasswordRequirements
            .contains(ResetPasswordRequirements.matching);
        final textTheme = Theme.of(context).textTheme;

        return Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            horizontal: AppSpacerSize.xsmall,
          ),
          child: Column(
            children: [
              const AppSpacer.medium(),
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
                l10n.passwordRequirementsMinimumChars,
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
              const AppSpacer.medium(),
              Divider(color: colorScheme.primary, thickness: 0.5),
            ],
          ),
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
