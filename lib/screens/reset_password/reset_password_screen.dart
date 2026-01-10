import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/screens/reset_password/reset_password_button.dart';
import 'package:wishing_well/screens/reset_password/reset_password_checklist.dart';
import 'package:wishing_well/screens/reset_password/reset_password_header.dart';
import 'package:wishing_well/screens/reset_password/reset_password_inline_error.dart';
import 'package:wishing_well/screens/reset_password/reset_password_inputs.dart';
import 'package:wishing_well/screens/reset_password/reset_password_viewmodel.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({required this.viewmodel, super.key});
  final ResetPasswordViewmodel viewmodel;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Screen(
    appBar: AppMenuBar(
      action: () => widget.viewmodel.tapCloseButton(context),
      type: AppMenuBarType.close,
    ),
    children: [
      const ResetPasswordHeader(),
      const AppSpacer.xlarge(),
      ResetPasswordInputs(viewmodel: widget.viewmodel),
      const AppSpacer.large(),
      ResetPasswordChecklist(viewModel: widget.viewmodel),
      ResetPasswordInlineError(viewModel: widget.viewmodel),
      ResetPasswordButton(viewmodel: widget.viewmodel),
      const AppSpacer.large(),
    ],
  );
}
