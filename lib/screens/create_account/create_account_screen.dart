import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/screens/create_account/create_account_button.dart';
import 'package:wishing_well/screens/create_account/create_account_header.dart';
import 'package:wishing_well/screens/create_account/create_account_inputs.dart';
import 'package:wishing_well/screens/create_account/create_account_password_checklist.dart';
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
    appBar: AppMenuBar(
      action: () => context.pop(),
      type: AppMenuBarType.dismiss,
    ),
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const CreateAccountHeader(),
      CreateAccountInputs(viewModel: widget.viewModel),
      CreateAccountPasswordChecklist(viewModel: widget.viewModel),
      CreateAccountButton(viewModel: widget.viewModel),
    ],
  );
}
