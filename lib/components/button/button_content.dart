import 'package:flutter/material.dart';

class ButtonContent extends StatelessWidget {
  final bool isLoading;
  final String label;
  final Color buttonTextColor;

  const ButtonContent({
    super.key,
    required this.isLoading,
    required this.label,
    required this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            buttonTextColor
          ),
        ),
      );
    } else {
      return Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: buttonTextColor,
        ),
      );
    }
  }
}