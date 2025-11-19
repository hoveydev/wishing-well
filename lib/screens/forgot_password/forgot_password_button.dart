import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_viewmodel.dart';

class ForgotPasswordButton extends StatelessWidget {

  final ForgotPasswordViewModel viewModel;

  const ForgotPasswordButton({
    super.key,
    required this.viewModel
  });

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // TODO: Localize
        AppButton.label(
          label: "Submit",
          onPressed: viewModel.tapSendResetLinkButton,
          type: AppButtonType.primary
        )
      ],
    );
  }
}