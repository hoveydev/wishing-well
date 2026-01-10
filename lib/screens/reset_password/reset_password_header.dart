import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class ResetPasswordHeader extends StatelessWidget {
  const ResetPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.resetPasswordScreenHeader,
          style: textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        Text(
          l10n.resetPasswordScreenSubtext,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
