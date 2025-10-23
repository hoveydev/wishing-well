import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'app_button_type.dart';

ButtonStyle style(AppButtonType type) {
  final EdgeInsets padding = const EdgeInsets.symmetric(vertical: 16);
  final RoundedRectangleBorder shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  );
    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: padding,
          shape: shape,
          elevation: 2,
        );
      case AppButtonType.secondary:
        return OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: padding,
          shape: shape,
        );
      case AppButtonType.tertiary:
        return TextButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: padding,
          shape: shape,
        );
    }
  }