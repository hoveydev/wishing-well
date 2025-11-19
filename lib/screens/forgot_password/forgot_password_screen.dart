import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_button.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_header.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_input.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_viewmodel.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({required this.viewModel, super.key});

  final ForgotPasswordViewModel viewModel;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // init
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Screen(
    appBar: AppBar(
      leading: FittedBox(
        child: AppButton.icon(
          icon: Icons.keyboard_arrow_down,
          onPressed: () => context.pop(),
          type: AppButtonType.tertiary,
        ),
      ),
    ),
    children: [
      const AppSpacer.xlarge(),
      const ForgotPasswordHeader(),
      const AppSpacer.xlarge(),
      ForgotPasswordInput(viewModel: widget.viewModel),
      const Spacer(),
      ForgotPasswordButton(viewModel: widget.viewModel),
      const AppSpacer.large(),
    ],
  );
}
