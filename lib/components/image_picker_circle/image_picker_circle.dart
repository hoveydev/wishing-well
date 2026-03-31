import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  /// Get auth headers for loading private images
  Map<String, String> get _authHeaders {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return {'Authorization': 'Bearer ${session.accessToken}'};
    }
    return {};
  }

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

    // Prefer local file, then use CachedNetworkImage for remote URL
    if (imageFile != null) {
      return Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: colorScheme.primary,
            backgroundImage: FileImage(imageFile!),
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

    // Remote URL with caching
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      httpHeaders: _authHeaders,
      imageBuilder: (context, imageProvider) => Stack(
        children: [
          CircleAvatar(radius: radius, backgroundImage: imageProvider),
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
      ),
      placeholder: (context, url) => Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: colorScheme.primary,
            child: Icon(Icons.person, size: 24, color: colorScheme.onPrimary),
          ),
        ],
      ),
      errorWidget: (context, url, error) => Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: colorScheme.primary,
            child: Icon(Icons.person, size: 24, color: colorScheme.onPrimary),
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
      ),
    );
  }
}
