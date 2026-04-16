import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/loading_overlay/loading_overlay.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/features/auth/create_account/components/create_account_button.dart';
import 'package:wishing_well/features/auth/create_account/components/create_account_header.dart';
import 'package:wishing_well/features/auth/create_account/create_account_view_model.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({required this.viewModel, super.key});
  final CreateAccountViewModelContract viewModel;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LoadingOverlay(
    child: Screen(
      appBar: AppMenuBar(
        action: () => widget.viewModel.tapDismissButton(context),
        type: AppMenuBarType.dismiss,
      ),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CreateAccountHeader(viewModel: widget.viewModel),
        CreateAccountButton(viewModel: widget.viewModel),
      ],
    ),
  );
}
