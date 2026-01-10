import 'package:flutter/material.dart';
import 'package:wishing_well/components/shape/dotted_border.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';

class HomeComingUp extends StatelessWidget {
  const HomeComingUp({super.key});
  // will need final var for card data

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colorScheme = context.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.comingUpTitle,
          style: textTheme.titleMedium,
          textAlign: TextAlign.left,
        ),
        _comingUpCards(textTheme, colorScheme),
      ],
    );
  }

  Widget _comingUpCards(
    TextTheme textTheme,
    ColorSchemeExtension colorScheme,
  ) => SizedBox(
    width: double.infinity,
    child: Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: DottedBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: colorScheme.borderGray!,
      ),
      color: colorScheme.surfaceGray,
      child: Padding(
        padding: const EdgeInsetsGeometry.all(AppSpacerSize.small),
        // will change to a calendar component
        child: Text('Nothing yet :)', style: textTheme.bodySmall),
      ),
    ),
  );
}
