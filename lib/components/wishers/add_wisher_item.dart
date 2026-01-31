import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:wishing_well/components/dotted_border_config.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_icon_size.dart';
import 'package:wishing_well/theme/app_theme.dart';

class AddWisherItem extends StatelessWidget {
  const AddWisherItem(this.padding, this.onTap, {super.key});
  final EdgeInsets padding;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colorScheme = context.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: padding,
      child: Column(
        children: [
          TouchFeedbackOpacity(
            onTap: onTap,
            child: DottedBorder(
              options: DottedBorderConfig.circularAvatar(
                color: colorScheme.primary!,
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: colorScheme.background,
                child: Icon(
                  Icons.add,
                  size: const AppIconSize().large,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const AppSpacer.xsmall(),
          Text(l10n.add, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
