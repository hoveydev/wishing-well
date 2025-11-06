import 'package:flutter/material.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/screens/login/login_buttons.dart';
import 'package:wishing_well/screens/login/login_header.dart';
import 'package:wishing_well/screens/login/login_inputs.dart';
import 'package:wishing_well/screens/login/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // init
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      children: [
        const LoginHeader(),
        LoginInputs(viewModel: widget.viewModel),
        LoginButtons(viewModel: widget.viewModel),
        AppSpacer.medium(),
      ],
    );
  }
}