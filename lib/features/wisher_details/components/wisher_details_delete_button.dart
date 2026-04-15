import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/types/primary_button.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';

class WisherDetailsDeleteButton extends StatelessWidget {
  const WisherDetailsDeleteButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Map primary -> error temporarily so the PrimaryButton's built-in
    // feedback animation (which uses colorScheme.primary) yields an
    // error-colored button with the expected pressed opacity.
    final appColors = context.colorScheme;
    final override = appColors.copyWith(
      primary: appColors.error,
      onPrimary: appColors.onPrimary,
    );

    return Theme(
      data: Theme.of(
        context,
      ).copyWith(extensions: <ThemeExtension<dynamic>>[override]),
      child: PrimaryButton.label(
        label: AppLocalizations.of(context)!.deleteWisher,
        onPressed: onPressed,
      ),
    );
  }
}
