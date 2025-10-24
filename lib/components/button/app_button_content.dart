import 'package:flutter/material.dart';

class AppButtonContent extends StatelessWidget {
  final bool isLoading;
  final String label;
  final Color buttonTextColor;

  const AppButtonContent({
    super.key,
    required this.isLoading,
    required this.label,
    required this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
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
        style: textTheme.bodyLarge?.copyWith(
          color: buttonTextColor,
        ),
      );
    }
  }
}