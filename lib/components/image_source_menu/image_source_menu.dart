import 'package:flutter/material.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';

/// Options available in the image source menu
enum ImageSourceOption { photo, file }

/// A modal bottom sheet that presents image source options.
///
/// Displayed when user taps on an image picker (e.g., CircleImagePicker).
/// Provides options to choose an image from gallery or from device files.
class ImageSourceMenu extends StatelessWidget {
  const ImageSourceMenu({required this.onOptionSelected, super.key});

  /// Callback when user selects an option
  final void Function(ImageSourceOption) onOptionSelected;

  /// Show the image source menu as a modal bottom sheet
  static Future<void> show({
    required BuildContext context,
    required void Function(ImageSourceOption) onOptionSelected,
  }) {
    final colorScheme = context.colorScheme;
    return showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ImageSourceMenu(onOptionSelected: onOptionSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.borderGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.selectImageSource,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
          Divider(height: 1, color: colorScheme.borderGray),
          // Options
          _buildOption(
            context: context,
            icon: Icons.photo_library,
            title: l10n.chooseAPhoto,
            onTap: () => _handleSelection(context, ImageSourceOption.photo),
          ),
          _buildOption(
            context: context,
            icon: Icons.folder_open,
            title: l10n.chooseAFile,
            onTap: () => _handleSelection(context, ImageSourceOption.file),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final colorScheme = context.colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _handleSelection(BuildContext context, ImageSourceOption option) {
    Navigator.of(context).pop();
    onOptionSelected(option);
  }
}
