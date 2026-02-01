import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/add_wisher/components/add_wisher_description.dart';

class AddWisherHeader extends StatelessWidget {
  const AddWisherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSpacer.small(),
        Text(
          l10n.addWisherScreenHeader,
          style: textTheme.headlineSmall,
          semanticsLabel: l10n.addWisherScreenHeader,
        ),
        const AppSpacer.large(),
        const AddWisherDescription(),
      ],
    );
  }
}
