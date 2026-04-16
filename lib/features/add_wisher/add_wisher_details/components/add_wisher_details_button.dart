import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';

class AddWisherDetailsButton extends StatelessWidget {
  const AddWisherDetailsButton({required this.viewModel, super.key});
  final AddWisherDetailsViewModelContract viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton.label(
          label: l10n.save,
          onPressed: () => viewModel.tapSaveButton(context),
          type: AppButtonType.primary,
        ),
      ],
    );
  }
}
