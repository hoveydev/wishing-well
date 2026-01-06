import 'package:flutter/material.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';
import 'package:wishing_well/utils/auth_error.dart';

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

    return switch (viewModel.authError) {
      UIAuthError(:final type) => switch (type) {
        CreateAccountErrorType.noEmail => l10n.createAccountErrorNoEmail,
        CreateAccountErrorType.badEmail => l10n.createAccountErrorBadEmail,
        CreateAccountErrorType.passwordRequirementsNotMet =>
          l10n.createAccountErrorPasswordNotValid,
        CreateAccountErrorType.unknown => l10n.createAccountErrorUnknown,
        CreateAccountErrorType.none => '',
      },
      SupabaseAuthError(:final message) => message,
    };
  }
}
