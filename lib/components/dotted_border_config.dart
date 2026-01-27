import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

/// Reusable configurations for DottedBorder components.
/// Centralizes common visual styling parameters to maintain consistency
/// across the application while providing flexibility for different use cases.
class DottedBorderConfig {
  const DottedBorderConfig._();

  /// Default dash pattern for dotted borders.
  static const List<double> _defaultDashPattern = [10, 5];

  /// Default stroke width for dotted borders.
  static const double _defaultStrokeWidth = 2.0;

  /// Standard configuration for circular dotted borders.
  /// Used in AddWisherItem to match WisherItem styling.
  /// Border padding is automatically calculated as stroke width / 2.
  static CircularDottedBorderOptions standard({
    required Color color,
    double strokeWidth = _defaultStrokeWidth,
  }) => CircularDottedBorderOptions(
    dashPattern: _defaultDashPattern,
    strokeWidth: strokeWidth,
    borderPadding: EdgeInsets.all(strokeWidth / 2),
    color: color,
  );

  /// Configuration optimized for circular avatars.
  /// Uses dimensions calculated to prevent overflow issues.
  /// Border padding is automatically calculated as stroke width / 2.
  static CircularDottedBorderOptions circularAvatar({
    required Color color,
    double strokeWidth = _defaultStrokeWidth,
  }) => CircularDottedBorderOptions(
    dashPattern: _defaultDashPattern,
    strokeWidth: strokeWidth,
    borderPadding: EdgeInsets.all(strokeWidth / 2),
    color: color,
  );

  /// Configuration for dotted borders with minimal padding.
  /// Border padding is automatically calculated as stroke width / 2
  /// to prevent spacing issues while maintaining visual balance.
  static CircularDottedBorderOptions minimal({
    required Color color,
    double strokeWidth = _defaultStrokeWidth,
  }) => CircularDottedBorderOptions(
    dashPattern: _defaultDashPattern,
    strokeWidth: strokeWidth,
    borderPadding: EdgeInsets.all(strokeWidth / 2),
    color: color,
  );

  /// Configuration for dotted borders with automatic padding.
  /// Border padding is automatically calculated as stroke width / 2
  /// to ensure proper spacing regardless of stroke width.
  static CircularDottedBorderOptions automatic({
    required Color color,
    double strokeWidth = _defaultStrokeWidth,
  }) => CircularDottedBorderOptions(
    dashPattern: _defaultDashPattern,
    strokeWidth: strokeWidth,
    borderPadding: EdgeInsets.all(strokeWidth / 2),
    color: color,
  );

  /// Custom configuration with full control over all parameters.
  /// Allows for complete customization when predefined configurations
  /// don't meet specific requirements. This is the only method that
  /// allows manual control over border padding.
  static CircularDottedBorderOptions custom({
    required Color color,
    List<double> dashPattern = _defaultDashPattern,
    double strokeWidth = _defaultStrokeWidth,
    EdgeInsets? borderPadding,
  }) => CircularDottedBorderOptions(
    dashPattern: dashPattern,
    strokeWidth: strokeWidth,
    borderPadding: borderPadding ?? EdgeInsets.all(strokeWidth / 2),
    color: color,
  );
}
