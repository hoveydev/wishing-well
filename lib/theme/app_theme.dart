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
    textTheme: GoogleFonts.nunitoSansTextTheme(ThemeData.dark().textTheme)
        .apply(
          bodyColor: AppColors.darkPrimary,
          displayColor: AppColors.darkPrimary,
        ),
  );
}
