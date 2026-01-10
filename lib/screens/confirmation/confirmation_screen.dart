import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/screens/confirmation/confirmation_header.dart';
import 'package:wishing_well/screens/confirmation/confirmation_image.dart';
import 'package:wishing_well/screens/confirmation/confirmation_subtext.dart';

class ConfirmationScreenContent {
  ConfirmationScreenContent({this.header, Object? icon = _unset, this.subtext})
    : icon = icon == _unset ? Icons.check_circle : icon as IconData;
  String? header;
  IconData? icon;
  String? subtext;

  static const _unset = Object();
}

enum _ConfirmationScreenFlavor {
  account,
  createAccount,
  forgotPassword,
  resetPassword,
}

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen._({
    required _ConfirmationScreenFlavor confirmationScreenFlavor,
    super.key,
    this.header,
    this.icon,
    this.subtext,
  }) : _confirmationScreenFlavor = confirmationScreenFlavor;

  const ConfirmationScreen.account({Key? key})
    : this._(
        key: key,
        confirmationScreenFlavor: _ConfirmationScreenFlavor.account,
      );

  const ConfirmationScreen.createAccount({Key? key})
    : this._(
        key: key,
        confirmationScreenFlavor: _ConfirmationScreenFlavor.createAccount,
      );

  const ConfirmationScreen.forgotPassword({Key? key})
    : this._(
        key: key,
        confirmationScreenFlavor: _ConfirmationScreenFlavor.forgotPassword,
      );

  const ConfirmationScreen.resetPassword({Key? key})
    : this._(
        key: key,
        confirmationScreenFlavor: _ConfirmationScreenFlavor.resetPassword,
      );
  final String? header;
  final IconData? icon;
  final String? subtext;
  final _ConfirmationScreenFlavor _confirmationScreenFlavor;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ConfirmationScreenContent content = _content(l10n);

    return Screen(
      appBar: AppMenuBar(
        action: () => context.goNamed(Routes.login.name),
        type: AppMenuBarType.close,
      ),
      children: [
        const AppSpacer.large(),
        if (content.header != null)
          ConfirmationHeader(headerText: content.header!),
        const AppSpacer.xlarge(),
        if (content.icon != null) ConfirmationImage(icon: content.icon!),
        const AppSpacer.xlarge(),
        if (content.subtext != null)
          ConfirmationSubtext(subtext: content.subtext!),
      ],
    );
  }

  ConfirmationScreenContent _content(AppLocalizations l10n) {
    switch (_confirmationScreenFlavor) {
      case _ConfirmationScreenFlavor.account:
        return ConfirmationScreenContent(
          header: l10n.accountConfirmationHeader,
          subtext: l10n.accountConfirmationMessage,
        );
      case _ConfirmationScreenFlavor.createAccount:
        return ConfirmationScreenContent(
          header: l10n.createAccountConfirmationHeader,
          subtext: l10n.createAccountConfirmationMessage,
        );
      case _ConfirmationScreenFlavor.forgotPassword:
        return ConfirmationScreenContent(
          header: l10n.forgotPasswordConfirmationHeader,
          subtext: l10n.forgotPasswordConfirmationMessage,
        );
      case _ConfirmationScreenFlavor.resetPassword:
        return ConfirmationScreenContent(
          header: l10n.resetPasswordConfirmationHeader,
          subtext: l10n.resetPasswordConfirmationMessage,
        );
    }
  }
}
