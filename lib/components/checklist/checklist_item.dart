import 'package:flutter/material.dart';
import 'package:wishing_well/components/checklist/checklist_icon.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:wishing_well/theme/app_theme.dart';

class ChecklistItem extends StatelessWidget {
  const ChecklistItem({
    required this.label,
    required this.isSatisfied,
    super.key,
  });

  final String label;
  final bool isSatisfied;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconColor = isSatisfied ? AppColors.background : colorScheme.primary!;
    final bgColor = isSatisfied
        ? colorScheme.success!
        : colorScheme.background!;
    final borderColor = isSatisfied
        ? colorScheme.success!
        : colorScheme.borderGray!;
    final fontWeight = isSatisfied ? FontWeight.w500 : FontWeight.w400;

    return Semantics(
      label: label,
      checked: isSatisfied,
      child: Row(
        children: [
          ChecklistIcon(
            iconColor: iconColor,
            bgColor: bgColor,
            borderColor: borderColor,
            icon: isSatisfied ? Icons.check : null,
          ),
          const AppSpacer.small(),
          Expanded(
            child: Text(
              label,
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
