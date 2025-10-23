import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';

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
                  AppInput(placeholder: "Email", type: AppInputType.text, controller: TextEditingController()),
                  AppSpacer.small(),
                  AppInput(placeholder: "Password", type: AppInputType.text, controller: TextEditingController()),
                  Spacer(),
                  AppButton(label: "Forgot Password?", onPressed: () {}, type: AppButtonType.tertiary),
                  AppSpacer.small(),
                  AppButton(
                    label: 'Sign in',
                    onPressed: () {},
                    type: AppButtonType.primary,
                  ),
                  AppSpacer.small(),
                  AppButton(
                    label: 'Create an Account',
                    onPressed: () {},
                    type: AppButtonType.secondary,
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