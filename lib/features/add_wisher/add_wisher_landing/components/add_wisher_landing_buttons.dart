import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class AddWisherLandingButtons extends StatelessWidget {
  const AddWisherLandingButtons({
    required this.onAddFromContacts,
    required this.onAddManually,
    super.key,
  });

  final VoidCallback onAddFromContacts;
  final VoidCallback onAddManually;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      children: [
        AppButton.label(
          label: l10n.addFromContacts,
          onPressed: onAddFromContacts,
          type: AppButtonType.primary,
        ),
        AppButton.label(
          label: l10n.addManually,
          onPressed: onAddManually,
          type: AppButtonType.secondary,
        ),
      ],
    );
  }
}
