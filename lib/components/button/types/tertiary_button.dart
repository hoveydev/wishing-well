import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/button_content.dart';
import 'package:wishing_well/components/button/button_style.dart';
import 'package:wishing_well/theme.dart';
import 'package:wishing_well/utilities.dart';
import '../button_type.dart';

class TertiaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading = false;

  const TertiaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    final buttonStyle = style(ButtonType.primary);
    final onPressHandler = isLoading ? null : onPressed;
    final buttonContent = ButtonContent(
      isLoading: isLoading,
      label: label,
      buttonTextColor: AppColors.primary,
    );

    if (isIOS) {
      return CupertinoButton.filled(
        onPressed: onPressHandler,
        color: AppColors.transparent,
        child: buttonContent
      );
    } else {
      return ElevatedButton(
        style: buttonStyle,
        onPressed: onPressHandler,
        child: buttonContent,
      );
    }
  }
}