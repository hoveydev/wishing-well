import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/screens/confirmation/components/confirmation_header.dart';
import 'package:wishing_well/screens/confirmation/components/confirmation_image.dart';
import 'package:wishing_well/screens/confirmation/components/confirmation_subtext.dart';

enum ConfirmationScreenFlavor {
  account,
  createAccount,
  forgotPassword,
  resetPassword,
}

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen._({
    required ConfirmationScreenFlavor confirmationScreenFlavor,
    super.key,
    this.icon,
  }) : _confirmationScreenFlavor = confirmationScreenFlavor;

  const ConfirmationScreen.account({Key? key})
    : this._(
        key: key,
        confirmationScreenFlavor: ConfirmationScreenFlavor.account,
      );

  const ConfirmationScreen.createAccount({Key? key})
    : this._(
        key: key,
        confirmationScreenFlavor: ConfirmationScreenFlavor.createAccount,
      );

  const ConfirmationScreen.forgotPassword({Key? key})
    : this._(
        key: key,
        confirmationScreenFlavor: ConfirmationScreenFlavor.forgotPassword,
      );

  const ConfirmationScreen.resetPassword({Key? key})
    : this._(
        key: key,
        confirmationScreenFlavor: ConfirmationScreenFlavor.resetPassword,
      );
  final IconData? icon;
  final ConfirmationScreenFlavor _confirmationScreenFlavor;

  @override
  Widget build(BuildContext context) => Screen(
    appBar: AppMenuBar(
      action: () => context.goNamed(Routes.login.name),
      type: AppMenuBarType.close,
    ),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ConfirmationHeader(flavor: _confirmationScreenFlavor),
      const AppSpacer.large(),
      if (icon != null) ConfirmationImage(icon: icon!),
      const AppSpacer.large(),
      ConfirmationSubtext(flavor: _confirmationScreenFlavor),
    ],
  );
}
