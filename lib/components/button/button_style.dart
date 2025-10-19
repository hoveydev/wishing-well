import 'package:flutter/material.dart';
import '../../theme.dart';
import 'button_type.dart';

ButtonStyle style(ButtonType type) {
  final EdgeInsets padding = const EdgeInsets.symmetric(vertical: 16);
  final RoundedRectangleBorder shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  );
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: padding,
          shape: shape,
          elevation: 2,
        );
      case ButtonType.secondary:
        return OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: padding,
          shape: shape,
        );
      case ButtonType.tertiary:
        return TextButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: padding,
          shape: shape,
        );
    }
  }