import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    splashFactory: NoSplash.splashFactory,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.darkText,
      secondary: AppColors.accent,
      surface: AppColors.background,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      ColorSchemeExtension(success: AppColors.alertSuccess),
    ],
    textTheme: GoogleFonts.nunitoSansTextTheme(
      ThemeData.light().textTheme,
    ).apply(bodyColor: AppColors.primary, displayColor: AppColors.primary),
  );

  // TODO: update colors
  static ThemeData get darkTheme => ThemeData(
    splashFactory: NoSplash.splashFactory,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.darkPrimary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimary,
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkAccent,
      surface: AppColors.darkSurface,
      brightness: Brightness.dark,
      onPrimary: AppColors.darkTextSecondary,
      onSecondary: AppColors.darkBackground,
      onSurface: AppColors.darkText,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      ColorSchemeExtension(success: AppColors.darkAlertSuccess),
    ],
    textTheme: GoogleFonts.nunitoSansTextTheme(ThemeData.dark().textTheme)
        .apply(
          bodyColor: AppColors.darkPrimary,
          displayColor: AppColors.darkPrimary,
        ),
  );
}

extension AppThemeExtension on BuildContext {
  ColorSchemeExtension get colorScheme =>
      Theme.of(this).extension<ColorSchemeExtension>()!;
}

/// additional color scheme variables
@immutable
class ColorSchemeExtension extends ThemeExtension<ColorSchemeExtension> {
  const ColorSchemeExtension({this.success, this.onSuccess});
  final Color? success;
  final Color? onSuccess;

  @override
  ColorSchemeExtension copyWith({Color? success, Color? onSuccess}) =>
      ColorSchemeExtension(
        success: success ?? this.success,
        onSuccess: onSuccess ?? this.onSuccess,
      );

  @override
  ColorSchemeExtension lerp(
    ThemeExtension<ColorSchemeExtension>? other,
    double t,
  ) {
    if (other is! ColorSchemeExtension) return this;
    return ColorSchemeExtension(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
    );
  }
}
