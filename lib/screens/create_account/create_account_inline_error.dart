import 'package:flutter/material.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';

class CreateAccountInlineError extends StatelessWidget {
  const CreateAccountInlineError({required this.viewModel, super.key});
  final CreateAccountViewmodel viewModel;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsGeometry.symmetric(
      horizontal: AppSpacerSize.xsmall,
    ),
    child: ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => Visibility(
        visible: viewModel.hasAlert,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: AppInlineAlert(
          message: _validationMessage(context),
          type: AppInlineAlertType.error,
        ),
      ),
    ),
  );

  String _validationMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (viewModel.validationMessage) {
      case CreateAccountErrorType.badEmail:
        return l10n.createAccountErrorBadEmail;
      case CreateAccountErrorType.noEmail:
        return l10n.createAccountErrorNoEmail;
      case CreateAccountErrorType.passwordRequirementsNotMet:
        return l10n.createAccountErrorPasswordNotValid;
      case CreateAccountErrorType.unknownError:
        return l10n.createAccountErrorUnknown;
      case CreateAccountErrorType.none:
        return '';
    }
  }
}
