import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wishing_well/components/image_picker_circle/image_picker_circle.dart';
import 'package:wishing_well/components/image_source_menu/image_source_menu.dart';
import 'package:wishing_well/components/image_source_menu/image_source_picker.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/components/edit_wisher_inputs.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/edit_wisher_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class EditWisherHeader extends StatefulWidget {
  const EditWisherHeader({required this.viewModel, super.key});
  final EditWisherViewModel viewModel;

  @override
  State<EditWisherHeader> createState() => _EditWisherHeaderState();
}

class _EditWisherHeaderState extends State<EditWisherHeader> {
  late final ImagePicker _imagePicker;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.viewModel,
    builder: (context, _) => Column(
      spacing: AppSpacerSize.small,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AppSpacer.small(),
        Center(
          child: CircleImagePicker(
            onTap: () => _showImagePicker(context),
            imageFile: widget.viewModel.imageFile,
            imageUrl: widget.viewModel.existingImageUrl,
          ),
        ),
        const AppSpacer.small(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacerSize.medium),
          child: Text(
            AppLocalizations.of(context)!.editWisherScreenHeader,
            style: Theme.of(context).textTheme.headlineLarge,
            semanticsLabel: AppLocalizations.of(
              context,
            )!.editWisherScreenHeader,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacerSize.medium),
          child: Text(
            AppLocalizations.of(context)!.editWisherScreenSubtext,
            style: Theme.of(context).textTheme.bodyMedium,
            semanticsLabel: AppLocalizations.of(
              context,
            )!.editWisherScreenSubtext,
          ),
        ),
        const AppSpacer.large(),
        EditWisherInputs(viewModel: widget.viewModel),
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
      logContext: 'EditWisherHeader._pickImage',
    );

    if (file != null) {
      widget.viewModel.updateImage(file);
    }
  }
}
