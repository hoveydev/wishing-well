import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wishing_well/components/image_source_menu/image_source_menu.dart';
import 'package:wishing_well/utils/app_logger.dart';

class ImageSourcePicker {
  static const List<String> _allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'heic',
    'heif',
    'webp',
  ];

  static Future<File?> pick({
    required ImagePicker imagePicker,
    required ImageSourceOption option,
    required String logContext,
  }) async {
    switch (option) {
      case ImageSourceOption.photo:
        AppLogger.info(
          'User selected: Choose a Photo (gallery)',
          context: logContext,
        );
        final image = await imagePicker.pickImage(source: ImageSource.gallery);
        return image != null ? File(image.path) : null;
      case ImageSourceOption.file:
        AppLogger.info('User selected: Choose a File', context: logContext);
        try {
          final result = await FilePicker.pickFiles(
            type: FileType.custom,
            allowedExtensions: _allowedExtensions,
          );

          if (result == null || result.files.isEmpty) {
            return null;
          }

          final path = result.files.first.path;
          return path != null ? File(path) : null;
        } catch (e) {
          AppLogger.warning(
            'File picker not available: $e',
            context: logContext,
          );
          return null;
        }
    }
  }
}
