import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/types/primary_button.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class WisherDetailsDeleteButton extends StatelessWidget {
  const WisherDetailsDeleteButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => PrimaryButton.label(
    label: AppLocalizations.of(context)!.deleteWisher,
    onPressed: onPressed,
    backgroundColor: Theme.of(context).colorScheme.error,
  );
}
