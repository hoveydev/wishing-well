import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppSpacing {
  static const double appBarHeight = 48.0;
  static const double screenPaddingStandard = 24.0;
  static const double wisherSpacing = 16.0;
  static const double appBarTitleSpacing = 8.0;
  static const double wisherListItemHeight = 80.0;
  static const double wisherAvatarDiameter = 60.0;
  static const double wisherLabelTopSpacing = 4.0;

  static double wisherListItemHeightFor(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodySmall = textTheme.bodySmall;
    final bodySmallFontSize = bodySmall?.fontSize ?? 12.0;
    final scaledBodySmallFontSize = MediaQuery.textScalerOf(
      context,
    ).scale(bodySmallFontSize);
    final labelHeight = scaledBodySmallFontSize * (bodySmall?.height ?? 1.33);

    return math.max(
      wisherListItemHeight,
      (wisherAvatarDiameter + wisherLabelTopSpacing + labelHeight)
          .ceilToDouble(),
    );
  }
}
