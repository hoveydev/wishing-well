import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/logo/app_logo.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SizedBox(
                height: constraints.maxHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeader(context, constraints.maxHeight),
                    _buildInputSection(context),
                    _buildButtonsSection(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double height) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final logoSize = height * 0.15; // TODO: this should be held in a constant somewhere

    return Column(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppLogo(size: logoSize),
        Text(
          "WishingWell",
          style: textTheme.headlineLarge,
          textAlign: TextAlign.center
        ),
        Text(
          "Your personal well for thoughtful giving",
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
    
  }

  Widget _buildInputSection(BuildContext context) {
    return Column(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppInput(
          placeholder: "Email",
          type: AppInputType.text,
          controller: TextEditingController(),
        ),
        AppInput(
          placeholder: "Password",
          type: AppInputType.text,
          controller: TextEditingController(),
        ),
      ],
    );
  }

  Widget _buildButtonsSection(BuildContext context) {
    return Column(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          label: "Forgot Password?",
          onPressed: () {},
          type: AppButtonType.tertiary,
        ),
        AppButton(
          label: 'Sign in',
          onPressed: () {},
          type: AppButtonType.primary,
        ),
        AppButton(
          label: 'Create an Account',
          onPressed: () {},
          type: AppButtonType.secondary,
        ),
      ],
    );
  }
}