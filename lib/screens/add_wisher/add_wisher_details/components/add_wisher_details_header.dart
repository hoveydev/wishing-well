import 'package:flutter/material.dart';
import 'package:wishing_well/components/image_picker_circle/image_picker_circle.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/components/add_wisher_details_inputs.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';

class AddWisherDetailsHeader extends StatelessWidget {
  const AddWisherDetailsHeader({required this.viewModel, super.key});
  final AddWisherDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AppSpacer.small(),
        // Wisher image picker - centered at the top
        Center(
          child: CircleImagePicker(
            onTap: () => _showImagePicker(context),
            imageFile: viewModel.imageFile,
          ),
        ),
        const AppSpacer.small(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacerSize.medium),
          child: Text(
            l10n.manualAddWisherScreenHeader,
            style: textTheme.headlineLarge,
            semanticsLabel: l10n.manualAddWisherScreenHeader,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacerSize.medium),
          child: Text(
            l10n.manualAddWisherScreenSubtext,
            style: textTheme.bodyMedium,
            semanticsLabel: l10n.manualAddWisherScreenSubtext,
          ),
        ),
        const AppSpacer.large(),
        AddWisherDetailsInputs(viewModel: viewModel),
      ],
    );
  }

  void _showImagePicker(BuildContext context) {
    // TODO: Implement image picker - handled by parent or service
    // Placeholder - connect to image picker service
  }
}
