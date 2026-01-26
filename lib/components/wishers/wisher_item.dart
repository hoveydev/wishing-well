import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/theme/app_theme.dart';

class WisherItem extends StatelessWidget {
  const WisherItem(this.wisher, this.padding, {super.key});
  final Wisher wisher;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colorScheme = context.colorScheme;
    return Padding(
      padding: padding,
      child: Column(
        children: [
          TouchFeedbackOpacity(
            onTap: () => debugPrint('${wisher.name} tapped'),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: colorScheme.primary,
              child: Text(
                wisher.name[0],
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const AppSpacer.xsmall(),
          Text(wisher.name, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
