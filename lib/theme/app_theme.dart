import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    splashFactory: NoSplash.splashFactory,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    extensions: const <ThemeExtension<dynamic>>[
      AppColorScheme(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        background: AppColors.background,
        surfaceGray: AppColors.surfaceGray,
        borderGray: AppColors.borderGray,
        success: AppColors.success,
        warning: AppColors.warning,
        error: AppColors.error,
      ),
    ],
    textTheme: GoogleFonts.nunitoSansTextTheme(
      ThemeData.light().textTheme,
    ).apply(bodyColor: AppColors.primary, displayColor: AppColors.primary),
  );

  static ThemeData get darkTheme => ThemeData(
    splashFactory: NoSplash.splashFactory,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.darkPrimary,
    extensions: const <ThemeExtension<dynamic>>[
      AppColorScheme(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        background: AppColors.darkBackground,
        surfaceGray: AppColors.darkSurfaceGray,
        borderGray: AppColors.darkBorderGray,
        success: AppColors.darkSuccess,
        warning: AppColors.darkWarning,
        error: AppColors.darkError,
      ),
    ],
    textTheme: GoogleFonts.nunitoSansTextTheme(ThemeData.dark().textTheme)
        .apply(
          bodyColor: AppColors.darkPrimary,
          displayColor: AppColors.darkPrimary,
        ),
  );
}

extension AppThemeExtension on BuildContext {
  AppColorScheme get colorScheme => Theme.of(this).extension<AppColorScheme>()!;
}
