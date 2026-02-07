import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:wishing_well/components/dotted_border_config.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class HomeComingUp extends StatelessWidget {
  const HomeComingUp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colorScheme = context.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeComingUp,
            style: textTheme.titleMedium,
            textAlign: TextAlign.left,
          ),
          _comingUpCards(textTheme, colorScheme),
        ],
      ),
    );
  }

  Widget _comingUpCards(TextTheme textTheme, AppColorScheme colorScheme) =>
      SizedBox(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: colorScheme.surfaceGray,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: DottedBorder(
            options: DottedBorderConfig.standard(
              color: colorScheme.borderGray!,
            ),
            child: Padding(
              padding: const EdgeInsetsGeometry.all(AppSpacerSize.small),
              // will change to a calendar component
              child: Text('Nothing yet :)', style: textTheme.bodySmall),
            ),
          ),
        ),
      );
}
