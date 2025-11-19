import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/theme/app_colors.dart';

ButtonStyle style(AppButtonType type) {
  const EdgeInsets padding = EdgeInsets.symmetric(vertical: 16);
  final RoundedRectangleBorder roundedRectangle = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  );
  switch (type) {
    case AppButtonType.primary:
      return ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: padding,
        shape: roundedRectangle,
        elevation: 2,
      );
    case AppButtonType.secondary:
      return OutlinedButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 2),
        padding: padding,
        shape: roundedRectangle,
      );
    case AppButtonType.tertiary:
      return TextButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 2),
        padding: padding,
        shape: roundedRectangle,
      );
  }
}
