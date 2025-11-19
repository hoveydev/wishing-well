import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/screens/login/login_viewmodel.dart';

class LoginButtons extends StatelessWidget {
  final LoginViewModel viewModel;

  const LoginButtons({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton.label(
          label: l10n.forgotPassword,
          onPressed: () => context.push(Routes.forgotPassword),
          type: AppButtonType.tertiary,
        ),
        AppButton.label(
          label: l10n.signIn,
          onPressed: () => viewModel.tapLoginButton(),
          type: AppButtonType.primary,
        ),
        AppButton.label(
          label: l10n.createAccount,
          onPressed: () {},
          type: AppButtonType.secondary,
        ),
      ],
    );
  }
}
