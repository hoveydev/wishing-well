import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_spacing.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/logo/app_logo.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/login_viewmodel.dart';
import 'package:wishing_well/theme/app_logo_size.dart';

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
        _buildHeader(context, MediaQuery.of(context).size.height),
        _buildInputSection(context),
        _buildButtonsSection(context),
        AppSpacer.medium(),
      ],
    );
  }

  // TODO: in the future I want to label this const when called to prevent re-rendering
  // but that requires this to be a class instead - I will need to convert it
  Widget _buildHeader(BuildContext context, double height) {

    final l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final logoSize = AppLogoSize(sectionHeight: height).large;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppLogo(size: logoSize),
        Text(
          l10n.appName,
          style: textTheme.headlineLarge,
          textAlign: TextAlign.center
        ),
        Text(
          l10n.appTagline,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
    
  }

  Widget _buildInputSection(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppInput(
          placeholder: l10n.email,
          type: AppInputType.email,
          onChanged: (String val) => widget.viewModel.updateEmailField(val),
        ),
        AppInput(
          placeholder: l10n.password,
          type: AppInputType.password,
          onChanged: (String val) => widget.viewModel.updatePasswordField(val),
        ),
        ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) => Visibility(
            visible: widget.viewModel.hasAlert,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Padding(
              padding: AppInlineAlertSpacing.inputPadding,
              child: AppInlineAlert(
                message: widget.viewModel.validationMessage,
                type: AppInlineAlertType.error,
              )
            )
          )
        )
      ],
    );
  }

  Widget _buildButtonsSection(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          label: l10n.forgotPassword,
          onPressed: () {},
          type: AppButtonType.tertiary,
        ),
        AppButton(
          label: l10n.signIn,
          onPressed: () => widget.viewModel.tapLoginButton(),
          type: AppButtonType.primary,
        ),
        AppButton(
          label: l10n.createAccount,
          onPressed: () {},
          type: AppButtonType.secondary,
        ),
      ],
    );
  }
}