import 'package:flutter/material.dart';

class ConfirmationHeader extends StatelessWidget {
  final String headerText;

  const ConfirmationHeader({required this.headerText, super.key});

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
