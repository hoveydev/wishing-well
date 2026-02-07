import 'package:flutter/material.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class AddWisherLandingDescription extends StatelessWidget {
  const AddWisherLandingDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Text(
      l10n.addWisherScreenDescription,
      style: textTheme.bodyMedium,
      semanticsLabel: l10n.addWisherScreenDescription,
    );
  }
}
