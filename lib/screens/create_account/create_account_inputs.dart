import 'package:flutter/material.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/create_account/create_account_password_checklist.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';

class CreateAccountInputs extends StatefulWidget {
  const CreateAccountInputs({required this.viewModel, super.key});
  final CreateAccountViewmodel viewModel;

  @override
  State<CreateAccountInputs> createState() => _CreateAccountInputsState();
}

class _CreateAccountInputsState extends State<CreateAccountInputs> {
  final emailFocusNode = FocusNode();
  final passwordOneFocusNode = FocusNode();
  final passwordTwoFocusNode = FocusNode();
  final emailController = TextEditingController();
  final passwordOneController = TextEditingController();
  final passwordTwoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(
      () => widget.viewModel.updateEmailField(emailController.text),
    );
    passwordOneFocusNode.addListener(
      () => widget.viewModel.updatePasswordOneField(passwordOneController.text),
    );
    passwordTwoFocusNode.addListener(
      () => widget.viewModel.updatePasswordTwoField(passwordTwoController.text),
    );
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordOneFocusNode.dispose();
    passwordTwoFocusNode.dispose();
    emailController.dispose();
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
          placeholder: l10n.authEmail,
          type: AppInputType.email,
          controller: emailController,
          focusNode: emailFocusNode,
          onChanged: (String email) => widget.viewModel.updateEmailField(email),
        ),
        const AppSpacer.large(),
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
        CreateAccountPasswordChecklist(viewModel: widget.viewModel),
      ],
    );
  }
}
