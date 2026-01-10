import 'package:flutter/material.dart';

@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    this.primary,
    this.onPrimary,
    this.background,
    this.surfaceGray,
    this.borderGray,
    this.success,
    this.warning,
    this.error,
  });
  final Color? primary;
  final Color? onPrimary;
  final Color? background;
  final Color? surfaceGray;
  final Color? borderGray;
  final Color? success;
  final Color? warning;
  final Color? error;

  @override
  AppColorScheme copyWith({
    Color? primary,
    Color? onPrimary,
    Color? background,
    Color? surfaceGray,
    Color? borderGray,
    Color? success,
    Color? warning,
    Color? error,
  }) => AppColorScheme(
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    background: background ?? this.background,
    surfaceGray: surfaceGray ?? this.surfaceGray,
    borderGray: borderGray ?? this.borderGray,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    error: error ?? this.error,
  );

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      primary: Color.lerp(primary, other.primary, t),
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t),
      background: Color.lerp(background, other.background, t),
      surfaceGray: Color.lerp(surfaceGray, other.surfaceGray, t),
      borderGray: Color.lerp(borderGray, other.borderGray, t),
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      error: Color.lerp(error, other.error, t),
    );
  }
}
