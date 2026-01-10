import 'package:flutter/material.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.firstName});
  final String? firstName;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    return Text(
      _welcomeHeaderText(firstName, l10n),
      style: textTheme.titleLarge,
    );
  }

  String _welcomeHeaderText(String? firstName, AppLocalizations l10n) =>
      switch (firstName) {
        null => l10n.homeWelcome,
        _ => l10n.homeWelcomeWithName(firstName),
      };
}
