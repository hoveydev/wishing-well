import 'package:flutter/material.dart';

class ForgotPasswordHeader extends StatelessWidget {

  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Forgot Password', // TODO: localize
          style: textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        Text(
          'Enter your email address below to receive a password reset link.',
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}