import 'package:flutter/material.dart';
import 'package:wishing_well/components/checklist/checklist_item.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/auth/create_account/components/create_account_inline_error.dart';
import 'package:wishing_well/screens/auth/create_account/create_account_view_model.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_theme.dart';

class CreateAccountPasswordChecklist extends StatelessWidget {
  const CreateAccountPasswordChecklist({required this.viewModel, super.key});
  final CreateAccountViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (_, _) {
        final requirementLabels = <CreateAccountPasswordRequirements, String>{
          CreateAccountPasswordRequirements.adequateLength:
              l10n.passwordRequirementsMinChars,
          CreateAccountPasswordRequirements.containsUppercase:
              l10n.passwordRequirementsUppercase,
          CreateAccountPasswordRequirements.containsLowercase:
              l10n.passwordRequirementsLowercase,
          CreateAccountPasswordRequirements.containsDigit:
              l10n.passwordRequirementsDigit,
          CreateAccountPasswordRequirements.containsSpecial:
              l10n.passwordRequirementsSpecialChar,
          CreateAccountPasswordRequirements.matching:
              l10n.passwordRequirementsMatching,
        };

        final requirements = CreateAccountPasswordRequirements.values
            .map(
              (requirement) => ChecklistRequirement(
                label: requirementLabels[requirement]!,
                isSatisfied: viewModel.metPasswordRequirements.contains(
                  requirement,
                ),
              ),
            )
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSpacer.medium(),
            Text(l10n.passwordRequirementsHeader, style: textTheme.titleMedium),
            const AppSpacer.small(),
            Semantics(
              container: true,
              child: Container(
                padding: const EdgeInsets.all(AppSpacerSize.medium),
                decoration: BoxDecoration(
                  color: colorScheme.background!,
                  borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                  border: Border.all(color: colorScheme.borderGray!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < requirements.length; i++) ...[
                      ChecklistItem(
                        label: requirements[i].label,
                        isSatisfied: requirements[i].isSatisfied,
                      ),
                      if (i < requirements.length - 1) const AppSpacer.xsmall(),
                    ],
                  ],
                ),
              ),
            ),
            const AppSpacer.small(),
            CreateAccountInlineError(viewModel: viewModel),
            const AppSpacer.large(),
          ],
        );
      },
    );
  }
}

class ChecklistRequirement {
  const ChecklistRequirement({required this.label, required this.isSatisfied});

  final String label;
  final bool isSatisfied;
}
