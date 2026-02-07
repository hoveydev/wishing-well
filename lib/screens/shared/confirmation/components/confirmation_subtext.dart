import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/shared/confirmation/confirmation_screen.dart';

class ConfirmationSubtext extends StatelessWidget {
  const ConfirmationSubtext({required this.flavor, super.key});
  final ConfirmationScreenFlavor flavor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final subtext = _getSubtext(flavor, l10n);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacerSize.large),
      child: Text(
        subtext,
        style: textTheme.bodyLarge,
        textAlign: TextAlign.center,
        semanticsLabel: subtext,
      ),
    );
  }

  String _getSubtext(ConfirmationScreenFlavor flavor, AppLocalizations l10n) {
    switch (flavor) {
      case ConfirmationScreenFlavor.account:
        return l10n.accountConfirmationMessage;
      case ConfirmationScreenFlavor.createAccount:
        return l10n.createAccountConfirmationMessage;
      case ConfirmationScreenFlavor.forgotPassword:
        return l10n.forgotPasswordConfirmationMessage;
      case ConfirmationScreenFlavor.resetPassword:
        return l10n.resetPasswordConfirmationMessage;
    }
  }
}
