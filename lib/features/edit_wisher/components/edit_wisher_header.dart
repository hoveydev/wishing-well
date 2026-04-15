import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wishing_well/components/image_picker_circle/image_picker_circle.dart';
import 'package:wishing_well/components/image_source_menu/image_source_menu.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/features/edit_wisher/components/edit_wisher_inputs.dart';
import 'package:wishing_well/features/edit_wisher/edit_wisher_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/utils/app_logger.dart';

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
    switch (option) {
      case ImageSourceOption.photo:
        AppLogger.info(
          'User selected: Choose a Photo (gallery)',
          context: 'EditWisherHeader._pickImage',
        );
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) {
          widget.viewModel.updateImage(File(image.path));
        }
      case ImageSourceOption.file:
        AppLogger.info(
          'User selected: Choose a File',
          context: 'EditWisherHeader._pickImage',
        );
        try {
          final FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: const [
              'jpg',
              'jpeg',
              'png',
              'gif',
              'heic',
              'heif',
              'webp',
            ],
          );
          if (result != null && result.files.isNotEmpty) {
            final file = result.files.first;
            if (file.path != null) {
              widget.viewModel.updateImage(File(file.path!));
            }
          }
        } catch (e) {
          AppLogger.warning(
            'File picker not available: $e',
            context: 'EditWisherHeader._pickImage',
          );
        }
    }
  }
}
