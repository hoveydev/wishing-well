import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/edit_wisher_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class EditWisherButton extends StatelessWidget {
  const EditWisherButton({required this.viewModel, super.key});
  final EditWisherViewModelContract viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton.label(
          label: l10n.saveChanges,
          onPressed: () => viewModel.tapSaveButton(context),
          type: AppButtonType.primary,
        ),
      ],
    );
  }
}
