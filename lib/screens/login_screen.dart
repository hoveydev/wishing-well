import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/logo/app_logo.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            AppLogo(size: 150),
                            AppSpacer.small(),
                            Text("WishingWell", style: textTheme.headlineLarge),
                            AppSpacer.xsmall(),
                            Text(
                              "Your personal well for thoughtful giving",
                              style: textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            AppInput(
                              placeholder: "Email",
                              type: AppInputType.text,
                              controller: TextEditingController(),
                            ),
                            AppSpacer.medium(),
                            AppInput(
                              placeholder: "Password",
                              type: AppInputType.text,
                              controller: TextEditingController(),
                            ),
                            AppSpacer.large(),
                            AppButton(
                              label: "Forgot Password?",
                              onPressed: () {},
                              type: AppButtonType.tertiary,
                            ),
                            AppSpacer.medium(),
                            AppButton(
                              label: 'Sign in',
                              onPressed: () {},
                              type: AppButtonType.primary,
                            ),
                            AppSpacer.medium(),
                            AppButton(
                              label: 'Create an Account',
                              onPressed: () {},
                              type: AppButtonType.secondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
  }
}