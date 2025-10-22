import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/button.dart';
import 'package:wishing_well/components/button/button_type.dart';
import 'package:wishing_well/components/input/input.dart';
import 'package:wishing_well/components/input/input_type.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Logo Placeholder", style: textTheme.titleLarge),
                  Text("WishingWell", style: textTheme.headlineLarge),
                  Text("Your personal well for thoughtful giving", style: textTheme.bodyMedium),
                  Spacer(),
                  Input(placeholder: "Email", type: InputType.text, controller: TextEditingController()),
                  const SizedBox(height: 8),
                  Input(placeholder: "Password", type: InputType.text, controller: TextEditingController()),
                  Spacer(),
                  Button(label: "Forgot Password?", onPressed: () {}, type: ButtonType.tertiary),
                  const SizedBox(height: 8),
                  Button(
                    label: 'Sign in',
                    onPressed: () {},
                    type: ButtonType.primary,
                  ),
                  const SizedBox(height: 8),
                  Button(
                    label: 'Create an Account',
                    onPressed: () {},
                    type: ButtonType.secondary,
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      );
  }
}