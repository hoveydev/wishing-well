import 'package:flutter/material.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class AddWisherHeader extends StatelessWidget {
  const AddWisherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Text(
      l10n.addWisherScreenHeader,
      style: textTheme.headlineSmall,
      semanticsLabel: l10n.addWisherScreenHeader,
    );
  }
}
