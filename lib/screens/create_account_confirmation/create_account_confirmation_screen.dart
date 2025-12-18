import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/screens/create_account_confirmation/create_account_confirmation_header.dart';
import 'package:wishing_well/screens/create_account_confirmation/create_account_confirmation_image.dart';
import 'package:wishing_well/screens/create_account_confirmation/create_account_confirmation_info_message.dart';

class CreateAccountConfirmationScreen extends StatelessWidget {
  // coverage:ignore-start
  const CreateAccountConfirmationScreen({super.key});
  // coverage:ignore-end

  @override
  Widget build(BuildContext context) => Screen(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      actions: [
        FittedBox(
          child: AppButton.icon(
            icon: Icons.close,
            onPressed: () => context.goNamed(Routes.login),
            type: AppButtonType.tertiary,
          ),
        ),
      ],
    ),
    children: const [
      AppSpacer.large(),
      CreateAccountConfirmationHeader(),
      AppSpacer.xlarge(),
      CreateAccountConfirmationImage(),
      AppSpacer.xlarge(),
      CreateAccountConfirmationInfoMessage(),
      Spacer(),
    ],
  );
}
