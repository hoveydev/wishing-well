import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/logo/app_logo.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSpacerSize.medium),
              child: SizedBox(
                height: constraints.maxHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeader(context, constraints.maxHeight),
                    _buildInputSection(context),
                    _buildButtonsSection(context),
                    AppSpacer.medium(),
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

    final l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final logoSize = height * 0.15;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppLogo(size: logoSize),
        Text(
          l10n.appName,
          style: textTheme.headlineLarge,
          textAlign: TextAlign.center
        ),
        Text(
          l10n.appTagline,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
    
  }

  Widget _buildInputSection(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppInput(
          placeholder: l10n.email,
          type: AppInputType.text,
          controller: TextEditingController(),
        ),
        AppInput(
          placeholder: l10n.password,
          type: AppInputType.text,
          controller: TextEditingController(),
        ),
      ],
    );
  }

  Widget _buildButtonsSection(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          label: l10n.forgotPassword,
          onPressed: () {},
          type: AppButtonType.tertiary,
        ),
        AppButton(
          label: l10n.signIn,
          onPressed: () {},
          type: AppButtonType.primary,
        ),
        AppButton(
          label: l10n.createAccount,
          onPressed: () {},
          type: AppButtonType.secondary,
        ),
      ],
    );
  }
}