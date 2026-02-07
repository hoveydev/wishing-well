import 'package:flutter/material.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/screens/auth/login/components/login_buttons.dart';
import 'package:wishing_well/screens/auth/login/components/login_header.dart';
import 'package:wishing_well/screens/auth/login/components/login_inputs.dart';
import 'package:wishing_well/screens/auth/login/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.viewModel, super.key});
  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard(BuildContext context) {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => _dismissKeyboard(context),
    child: Screen(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LoginHeader(),
        const AppSpacer.large(),
        LoginInputs(
          viewModel: widget.viewModel,
          emailFocusNode: _emailFocusNode,
          passwordFocusNode: _passwordFocusNode,
        ),
        const AppSpacer.large(),
        LoginButtons(viewModel: widget.viewModel),
      ],
    ),
  );
}
