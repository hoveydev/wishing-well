import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/button_content.dart';
import 'package:wishing_well/components/button/button_style.dart';
import 'package:wishing_well/theme.dart';
import 'package:wishing_well/utilities.dart';
import '../button_type.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading = false;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    final buttonStyle = style(ButtonType.secondary);
    final onPressHandler = isLoading ? null : onPressed;
    final buttonContent = ButtonContent(
      isLoading: isLoading,
      label: label,
      buttonTextColor: AppColors.primary,
    );

    if (isIOS) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: CupertinoButton(
          onPressed: onPressHandler,
          child: buttonContent,
        ),
      );
    } else {
      return OutlinedButton(
        style: buttonStyle,
        onPressed: onPressHandler,
        child: buttonContent,
      );
    }
  }
}