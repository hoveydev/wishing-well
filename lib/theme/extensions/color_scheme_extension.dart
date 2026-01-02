import 'package:flutter/material.dart';

@immutable
class ColorSchemeExtension extends ThemeExtension<ColorSchemeExtension> {
  const ColorSchemeExtension({
    this.primary,
    this.onPrimary,
    this.success,
    this.onSuccess,
    this.surface,
  });
  final Color? primary;
  final Color? onPrimary;
  final Color? success;
  final Color? onSuccess;
  final Color? surface;

  @override
  ColorSchemeExtension copyWith({
    Color? primary,
    Color? onPrimary,
    Color? success,
    Color? onSuccess,
    Color? surface,
  }) => ColorSchemeExtension(
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    success: success ?? this.success,
    onSuccess: onSuccess ?? this.onSuccess,
    surface: surface ?? this.surface,
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
      success: Color.lerp(success, other.success, t),
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t),
      surface: Color.lerp(surface, other.surface, t),
    );
  }
}
