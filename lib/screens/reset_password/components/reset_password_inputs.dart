import 'package:flutter/material.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/reset_password/components/reset_password_checklist.dart';
import 'package:wishing_well/screens/reset_password/reset_password_view_model.dart';

class ResetPasswordInputs extends StatefulWidget {
  const ResetPasswordInputs({required this.viewModel, super.key});
  final ResetPasswordViewModel viewModel;

  @override
  State<ResetPasswordInputs> createState() => _ResetPasswordInputsState();
}

class _ResetPasswordInputsState extends State<ResetPasswordInputs> {
  final passwordOneFocusNode = FocusNode();
  final passwordTwoFocusNode = FocusNode();
  final passwordOneController = TextEditingController();
  final passwordTwoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordOneFocusNode.addListener(
      () => widget.viewModel.updatePasswordOneField(passwordOneController.text),
    );
    passwordTwoFocusNode.addListener(
      () => widget.viewModel.updatePasswordTwoField(passwordTwoController.text),
    );
  }

  @override
  void dispose() {
    passwordOneFocusNode.dispose();
    passwordTwoFocusNode.dispose();
    passwordOneController.dispose();
    passwordTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppInput(
          placeholder: l10n.authPassword,
          type: AppInputType.password,
          controller: passwordOneController,
          focusNode: passwordOneFocusNode,
          onChanged: (String password) =>
              widget.viewModel.updatePasswordOneField(password),
        ),
        AppInput(
          placeholder: l10n.authConfirmPassword,
          type: AppInputType.password,
          controller: passwordTwoController,
          focusNode: passwordTwoFocusNode,
          onChanged: (String password) =>
              widget.viewModel.updatePasswordTwoField(password),
        ),
        ResetPasswordChecklist(viewModel: widget.viewModel),
      ],
    );
  }
}
