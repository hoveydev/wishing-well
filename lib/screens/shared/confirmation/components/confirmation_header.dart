import 'package:flutter/material.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/shared/confirmation/confirmation_screen.dart';

class ConfirmationHeader extends StatelessWidget {
  const ConfirmationHeader({required this.flavor, super.key});
  final ConfirmationScreenFlavor flavor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final headerText = _getHeaderText(flavor, l10n);

    return Text(
      headerText,
      style: textTheme.headlineLarge,
      textAlign: TextAlign.center,
      semanticsLabel: headerText,
    );
  }

  String _getHeaderText(
    ConfirmationScreenFlavor flavor,
    AppLocalizations l10n,
  ) {
    switch (flavor) {
      case ConfirmationScreenFlavor.account:
        return l10n.accountConfirmationHeader;
      case ConfirmationScreenFlavor.createAccount:
        return l10n.createAccountConfirmationHeader;
      case ConfirmationScreenFlavor.forgotPassword:
        return l10n.forgotPasswordConfirmationHeader;
      case ConfirmationScreenFlavor.resetPassword:
        return l10n.resetPasswordConfirmationHeader;
    }
  }
}
