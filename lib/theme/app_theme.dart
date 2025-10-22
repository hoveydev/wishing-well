import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:wishing_well/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.background
      ),
      textTheme: TextTheme(
        titleLarge: AppTextStyles.title
      ),
    );
  }
}