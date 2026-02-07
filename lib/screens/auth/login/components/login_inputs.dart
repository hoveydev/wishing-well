import 'package:flutter/material.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_spacing.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/screens/auth/login/login_view_model.dart';

class LoginInputs extends StatelessWidget {
  const LoginInputs({
    required this.viewModel,
    this.emailFocusNode,
    this.passwordFocusNode,
    super.key,
  });
  final LoginViewModel viewModel;
  final FocusNode? emailFocusNode;
  final FocusNode? passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppInput(
          placeholder: l10n.authEmail,
          type: AppInputType.email,
          onChanged: (String val) => viewModel.updateEmailField(val),
          controller: viewModel.emailInputController,
          focusNode: emailFocusNode,
        ),
        AppInput(
          placeholder: l10n.authPassword,
          type: AppInputType.password,
          onChanged: (String val) => viewModel.updatePasswordField(val),
          controller: viewModel.passwordInputController,
          focusNode: passwordFocusNode,
        ),
        ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) => Visibility(
            visible: viewModel.hasAlert,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Padding(
              padding: AppInlineAlertSpacing.inputPadding,
              child: AppInlineAlert(
                message: _validationMessage(l10n),
                type: AppInlineAlertType.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _validationMessage(AppLocalizations l10n) =>
      switch (viewModel.authError) {
        UIAuthError(:final type) => switch (type) {
          LoginErrorType.noPasswordNoEmail => l10n.errorEmailPasswordRequired,
          LoginErrorType.noEmail => l10n.errorEmailRequired,
          LoginErrorType.badEmail => l10n.errorInvalidEmail,
          LoginErrorType.noPassword => l10n.errorPasswordRequired,
          LoginErrorType.unknown => l10n.errorUnknown,
          LoginErrorType.none => '',
        },
        SupabaseAuthError(:final message) => message,
      };
}
