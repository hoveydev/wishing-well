import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.background,
    ),
    textTheme: GoogleFonts.nunitoSansTextTheme().apply(
      bodyColor: AppColors.primary,
      displayColor: AppColors.primary,
    ),
  );

  // TODO: update colors
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.text,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.text,
    ),
    textTheme: GoogleFonts.nunitoSansTextTheme().apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
  );
}
