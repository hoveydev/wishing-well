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
      ColorSchemeExtension(
        primary: AppColors.primary,
        onPrimary: AppColors.darkText,
        success: AppColors.alertSuccess,
      ),
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
    extensions: const <ThemeExtension<dynamic>>[
      ColorSchemeExtension(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkBackground,
        success: AppColors.darkAlertSuccess,
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
  ColorSchemeExtension get colorScheme =>
      Theme.of(this).extension<ColorSchemeExtension>()!;
}
