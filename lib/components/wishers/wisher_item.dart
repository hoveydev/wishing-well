import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/app_logger.dart';

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
            onTap: () =>
                AppLogger.debug('${wisher.name} tapped', context: 'WisherItem'),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: colorScheme.primary,
              backgroundImage: wisher.profilePicture != null
                  ? NetworkImage(wisher.profilePicture!)
                  : null,
              child: wisher.profilePicture == null
                  ? Text(
                      wisher.initial,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : null,
            ),
          ),
          const AppSpacer.xsmall(),
          Text(wisher.firstName, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
