import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:wishing_well/components/dotted_border_config.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:wishing_well/theme/app_theme.dart';

/// A generic circular image picker component.
///
/// Displays a placeholder with dotted border when no image is selected,
/// or shows the selected image (local file or remote URL) when available.
/// Tapping triggers the [onTap] callback for image selection.
class CircleImagePicker extends StatelessWidget {
  const CircleImagePicker({
    required this.onTap,
    this.imageFile,
    this.imageUrl,
    this.label,
    this.radius = 50,
    this.showEditIcon = true,
    super.key,
  });

  /// Callback when user taps to select an image
  final VoidCallback onTap;

  /// Local file selected by user (preview)
  final File? imageFile;

  /// Existing remote URL (for editing mode)
  final String? imageUrl;

  /// Optional label displayed below the avatar
  final String? label;

  /// Radius of the avatar circle (default: 50)
  final double radius;

  /// Whether to show the edit icon overlay (default: true)
  final bool showEditIcon;

  /// Whether an image is available (either local or remote)
  bool get hasImage =>
      imageFile != null || (imageUrl != null && imageUrl!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colorScheme = context.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TouchFeedbackOpacity(onTap: onTap, child: _buildAvatar(context)),
        if (label != null) ...[
          const AppSpacer.xsmall(),
          Text(
            label!,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.primary),
          ),
        ],
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colorScheme = context.colorScheme;

    if (hasImage) {
      // Show selected/remote image
      return _buildImageAvatar(context);
    }

    // Show placeholder with dotted border
    return DottedBorder(
      options: DottedBorderConfig.circularAvatar(color: colorScheme.primary!),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: colorScheme.background,
        child: Icon(
          Icons.camera_alt_outlined,
          size: 24,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildImageAvatar(BuildContext context) {
    final colorScheme = context.colorScheme;

    // Prefer local file, then fall back to remote URL
    final ImageProvider? backgroundImage = imageFile != null
        ? FileImage(imageFile!)
        : (imageUrl != null ? NetworkImage(imageUrl!) : null);

    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: colorScheme.primary,
          backgroundImage: backgroundImage,
          child: backgroundImage == null
              ? Icon(Icons.person, size: 24, color: colorScheme.onPrimary)
              : null,
        ),
        if (showEditIcon)
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: radius * 0.32,
              backgroundColor: colorScheme.surfaceGray,
              child: Icon(
                Icons.edit,
                size: radius * 0.32,
                color: colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
