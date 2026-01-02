import 'package:flutter/material.dart';

@immutable
class ColorSchemeExtension extends ThemeExtension<ColorSchemeExtension> {
  const ColorSchemeExtension({
    this.primary,
    this.onPrimary,
    this.background,
    this.success,
    this.warning,
    this.error,
  });
  final Color? primary;
  final Color? onPrimary;
  final Color? background;
  final Color? success;
  final Color? warning;
  final Color? error;

  @override
  ColorSchemeExtension copyWith({
    Color? primary,
    Color? onPrimary,
    Color? background,
    Color? success,
    Color? warning,
    Color? error,
  }) => ColorSchemeExtension(
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    background: background ?? this.background,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    error: error ?? this.error,
  );

  @override
  ColorSchemeExtension lerp(
    ThemeExtension<ColorSchemeExtension>? other,
    double t,
  ) {
    if (other is! ColorSchemeExtension) return this;
    return ColorSchemeExtension(
      primary: Color.lerp(primary, other.primary, t),
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t),
      background: Color.lerp(background, other.background, t),
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      error: Color.lerp(error, other.error, t),
    );
  }
}
