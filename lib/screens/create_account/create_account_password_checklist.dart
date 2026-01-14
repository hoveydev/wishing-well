import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/create_account/create_account_inline_error.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:wishing_well/theme/app_icon_size.dart';
import 'package:wishing_well/theme/app_theme.dart';

class CreateAccountPasswordChecklist extends StatelessWidget {
  const CreateAccountPasswordChecklist({required this.viewModel, super.key});
  final CreateAccountViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (_, _) {
        final requirements = [
          _PasswordRequirement(
            label: l10n.passwordRequirementsMinChars,
            isSatisfied: viewModel.metPasswordRequirements.contains(
              CreateAccountPasswordRequirements.adequateLength,
            ),
          ),
          _PasswordRequirement(
            label: l10n.passwordRequirementsUppercase,
            isSatisfied: viewModel.metPasswordRequirements.contains(
              CreateAccountPasswordRequirements.containsUppercase,
            ),
          ),
          _PasswordRequirement(
            label: l10n.passwordRequirementsLowercase,
            isSatisfied: viewModel.metPasswordRequirements.contains(
              CreateAccountPasswordRequirements.containsLowercase,
            ),
          ),
          _PasswordRequirement(
            label: l10n.passwordRequirementsDigit,
            isSatisfied: viewModel.metPasswordRequirements.contains(
              CreateAccountPasswordRequirements.containsDigit,
            ),
          ),
          _PasswordRequirement(
            label: l10n.passwordRequirementsSpecialChar,
            isSatisfied: viewModel.metPasswordRequirements.contains(
              CreateAccountPasswordRequirements.containsSpecial,
            ),
          ),
          _PasswordRequirement(
            label: l10n.passwordRequirementsMatching,
            isSatisfied: viewModel.metPasswordRequirements.contains(
              CreateAccountPasswordRequirements.matching,
            ),
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSpacer.medium(),
            Text(l10n.passwordRequirementsHeader, style: textTheme.titleMedium),
            const AppSpacer.small(),
            Container(
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
                    _buildRequirementItem(context, requirements[i]),
                    if (i < requirements.length - 1) const AppSpacer.xsmall(),
                  ],
                ],
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

  Widget _buildRequirementItem(
    BuildContext context,
    _PasswordRequirement requirement,
  ) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSatisfied = requirement.isSatisfied;
    final bgColor = isSatisfied
        ? colorScheme.success!
        : colorScheme.background!;
    final borderColor = isSatisfied
        ? colorScheme.success!
        : colorScheme.borderGray!;
    final fontWeight = isSatisfied ? FontWeight.w500 : FontWeight.w400;

    return Semantics(
      label: requirement.label,
      checked: isSatisfied,
      child: Row(
        children: [
          _RequirementIcon(
            iconColor: AppColors.background,
            bgColor: bgColor,
            borderColor: borderColor,
            icon: isSatisfied ? Icons.check : null,
          ),
          const AppSpacer.small(),
          Expanded(
            child: Text(
              requirement.label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary!,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordRequirement {
  const _PasswordRequirement({required this.label, required this.isSatisfied});

  final String label;
  final bool isSatisfied;
}

class _RequirementIcon extends StatelessWidget {
  const _RequirementIcon({
    required this.iconColor,
    required this.bgColor,
    required this.borderColor,
    this.icon,
  });

  final Color iconColor;
  final Color bgColor;
  final Color borderColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: bgColor,
      border: Border.all(color: borderColor),
    ),
    child: Center(
      child: Icon(icon, size: const AppIconSize().medium, color: iconColor),
    ),
  );
}
