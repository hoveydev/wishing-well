import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/screens/account_confirmation/account_confirmation_header.dart';
import 'package:wishing_well/screens/account_confirmation/account_confirmation_image.dart';
import 'package:wishing_well/screens/account_confirmation/account_confirmation_info_message.dart';

class AccountConfirmationScreen extends StatelessWidget {
  // coverage:ignore-start
  const AccountConfirmationScreen({super.key});
  // coverage:ignore-end

  @override
  Widget build(BuildContext context) => Screen(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      actions: [
        FittedBox(
          child: AppButton.icon(
            icon: Icons.close,
            onPressed: () => context.goNamed(Routes.login.name),
            type: AppButtonType.tertiary,
          ),
        ),
      ],
    ),
    children: const [
      AppSpacer.large(),
      AccountConfirmationHeader(),
      AppSpacer.xlarge(),
      AccountConfirmationImage(),
      AppSpacer.xlarge(),
      AccountConfirmationInfoMessage(),
      Spacer(),
      // Login button?
    ],
  );
}
