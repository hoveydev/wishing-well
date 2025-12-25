import 'package:flutter/material.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class AccountConfirmationHeader extends StatelessWidget {
  const AccountConfirmationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Text(
      l10n.accountConfirmationHeader,
      style: textTheme.headlineLarge,
      textAlign: TextAlign.center,
    );
  }
}
