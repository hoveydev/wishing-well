import 'package:flutter/material.dart';

class ConfirmationHeader extends StatelessWidget {
  const ConfirmationHeader({required this.headerText, super.key});
  final String headerText;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Text(
      headerText,
      style: textTheme.headlineLarge,
      textAlign: TextAlign.center,
    );
  }
}
