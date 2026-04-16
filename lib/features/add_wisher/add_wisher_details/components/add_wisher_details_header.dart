import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wishing_well/components/image_picker_circle/image_picker_circle.dart';
import 'package:wishing_well/components/image_source_menu/image_source_menu.dart';
import 'package:wishing_well/components/image_source_menu/image_source_picker.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/components/add_wisher_details_inputs.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';

class AddWisherDetailsHeader extends StatefulWidget {
  const AddWisherDetailsHeader({required this.viewModel, super.key});
  final AddWisherDetailsViewModel viewModel;

  @override
  State<AddWisherDetailsHeader> createState() => _AddWisherDetailsHeaderState();
}

class _AddWisherDetailsHeaderState extends State<AddWisherDetailsHeader> {
  late final ImagePicker _imagePicker;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) =>
      // Listen to ViewModel changes to rebuild when image is updated
      ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) => Column(
          spacing: AppSpacerSize.small,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppSpacer.small(),
            // Wisher image picker - centered at the top
            Center(
              child: CircleImagePicker(
                onTap: () => _showImagePicker(context),
                imageFile: widget.viewModel.imageFile,
              ),
            ),
            const AppSpacer.small(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacerSize.medium,
              ),
              child: Text(
                AppLocalizations.of(context)!.manualAddWisherScreenHeader,
                style: Theme.of(context).textTheme.headlineLarge,
                semanticsLabel: AppLocalizations.of(
                  context,
                )!.manualAddWisherScreenHeader,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacerSize.medium,
              ),
              child: Text(
                AppLocalizations.of(context)!.manualAddWisherScreenSubtext,
                style: Theme.of(context).textTheme.bodyMedium,
                semanticsLabel: AppLocalizations.of(
                  context,
                )!.manualAddWisherScreenSubtext,
              ),
            ),
            const AppSpacer.large(),
            AddWisherDetailsInputs(viewModel: widget.viewModel),
          ],
        ),
      );

  void _showImagePicker(BuildContext context) {
    ImageSourceMenu.show(
      context: context,
      onOptionSelected: (option) => _pickImage(option),
    );
  }

  Future<void> _pickImage(ImageSourceOption option) async {
    final file = await ImageSourcePicker.pick(
      imagePicker: _imagePicker,
      option: option,
      logContext: 'AddWisherDetailsHeader._pickImage',
    );

    if (file != null) {
      widget.viewModel.updateImage(file);
    }
  }
}
