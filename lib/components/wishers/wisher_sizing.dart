import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Sizing constants specific to the wisher list and wisher item components.
class WisherSizing {
  /// Spacing between wisher items in the list (vertical gap).
  static const double itemSpacing = 16.0;

  /// Height of a wisher list item row (minimum).
  static const double listItemHeight = 80.0;

  /// Diameter of the wisher avatar (width and height).
  static const double avatarDiameter = 60.0;

  /// Vertical spacing between avatar and label text.
  static const double labelTopSpacing = 4.0;

  /// Default line height multiplier for body small text.
  /// Used in dynamic height calculations.
  static const double defaultBodySmallLineHeight = 1.33;

  /// Calculate the actual height of a wisher list item, accounting for
  /// text scaling. Returns the greater of [listItemHeight] or the
  /// calculated height based on avatar + spacing + scaled text.
  static double listItemHeightFor(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodySmall = textTheme.bodySmall;
    final bodySmallFontSize = bodySmall?.fontSize ?? 12.0;
    final scaledBodySmallFontSize = MediaQuery.textScalerOf(
      context,
    ).scale(bodySmallFontSize);
    final labelHeight =
        scaledBodySmallFontSize *
        (bodySmall?.height ?? defaultBodySmallLineHeight);

    return math.max(
      listItemHeight,
      (avatarDiameter + labelTopSpacing + labelHeight).ceilToDouble(),
    );
  }
}
