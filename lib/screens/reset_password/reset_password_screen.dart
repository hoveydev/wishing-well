import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/screens/reset_password/reset_password_button.dart';
import 'package:wishing_well/screens/reset_password/reset_password_header.dart';
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
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ResetPasswordHeader(viewmodel: widget.viewmodel),
      ResetPasswordButton(viewmodel: widget.viewmodel),
    ],
  );
}
