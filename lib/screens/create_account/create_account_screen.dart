import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/screens/create_account/create_account_button.dart';
import 'package:wishing_well/screens/create_account/create_account_header.dart';
import 'package:wishing_well/screens/create_account/create_account_inputs.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({required this.viewModel, super.key});
  final CreateAccountViewmodel viewModel;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
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
      // TODO: consider having a 'password requirements' section
      // that can check off each satisfying criteria
      const AppSpacer.xlarge(),
      const CreateAccountHeader(),
      const AppSpacer.xlarge(),
      CreateAccountInputs(viewModel: widget.viewModel),
      const Spacer(),
      CreateAccountButton(viewModel: widget.viewModel),
      const AppSpacer.large(),
    ],
  );
}
