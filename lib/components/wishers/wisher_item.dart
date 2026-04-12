import 'package:flutter/material.dart';
import 'package:wishing_well/components/profile_image/profile_image.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:wishing_well/data/models/wisher.dart';

/// Wisher avatar component that displays profile pictures.
///
/// Shows initial letter as placeholder.
/// On image load error, cleanly shows the initial.
class WisherItem extends StatelessWidget {
  const WisherItem(this.wisher, this.padding, {required this.onTap, super.key});
  final Wisher wisher;
  final EdgeInsets padding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding,
      child: Column(
        children: [
          TouchFeedbackOpacity(
            onTap: onTap,
            child: ProfileAvatar(
              imageUrl: wisher.profilePicture,
              firstName: wisher.firstName,
              lastName: wisher.lastName,
            ),
          ),
          const AppSpacer.xsmall(),
          Text(wisher.firstName, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
