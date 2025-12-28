import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class ResetPasswordConfirmationInfoMessage extends StatelessWidget {
  const ResetPasswordConfirmationInfoMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacerSize.large),
      child: Text(
        l10n.resetPasswordConfirmationInfoMessage,
        style: textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
