import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/utils/auth_service.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';

/// A reusable profile image component with authenticated network image support.
///
/// Handles:
/// - Local file display (for preview)
/// - Remote URL display with auth headers
/// - Loading/placeholder states
/// - Error fallback to initials
class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    this.imageUrl,
    this.localImageFile,
    this.firstName = '',
    this.radius = 30,
    this.showEditIcon = false,
    this.onTap,
  });

  /// Remote URL for the profile image
  final String? imageUrl;

  /// Local file for preview (takes precedence over imageUrl)
  final File? localImageFile;

  /// First name for generating initial fallback
  final String firstName;

  /// Radius of the avatar circle
  final double radius;

  /// Whether to show the edit icon overlay
  final bool showEditIcon;

  /// Callback when avatar is tapped
  final VoidCallback? onTap;

  /// Whether an image is available (either local or remote)
  bool get hasImage =>
      localImageFile != null || (imageUrl != null && imageUrl!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    // Build the avatar based on available image
    Widget avatar;
    if (localImageFile != null) {
      avatar = _buildLocalFileAvatar(colorScheme);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatar = _buildNetworkAvatar(colorScheme);
    } else {
      avatar = _buildInitialAvatar(colorScheme);
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          avatar,
          if (showEditIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: radius * 0.32,
                backgroundColor: colorScheme.surfaceGray!,
                child: Icon(
                  Icons.edit,
                  size: radius * 0.32,
                  color: colorScheme.primary!,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds avatar showing local file
  Widget _buildLocalFileAvatar(AppColorScheme colorScheme) => CircleAvatar(
    radius: radius,
    backgroundColor: colorScheme.primary!,
    backgroundImage: FileImage(localImageFile!),
  );

  /// Builds avatar showing network image with auth headers
  Widget _buildNetworkAvatar(AppColorScheme colorScheme) => CachedNetworkImage(
    imageUrl: imageUrl!,
    httpHeaders: AuthService.storageHeaders,
    imageBuilder: (context, imageProvider) =>
        CircleAvatar(radius: radius, backgroundImage: imageProvider),
    placeholder: (context, url) => _buildLoadingAvatar(colorScheme),
    errorWidget: (context, url, error) => _buildInitialAvatar(colorScheme),
  );

  /// Builds avatar showing initial letter fallback
  Widget _buildInitialAvatar(AppColorScheme colorScheme) {
    final initial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primary!,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: radius * 0.67,
          color: colorScheme.onPrimary!,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Builds loading placeholder avatar
  Widget _buildLoadingAvatar(AppColorScheme colorScheme) => CircleAvatar(
    radius: radius,
    backgroundColor: colorScheme.primary!,
    child: SizedBox(
      width: radius * 0.5,
      height: radius * 0.5,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: colorScheme.onPrimary!,
      ),
    ),
  );
}

/// A simpler version of ProfileImage for use in lists (like WisherItem).
///
/// Displays just the image/initial without edit icon or tap handling.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.firstName = '',
    this.lastName = '',
    this.radius = 30,
  });

  /// Remote URL for the profile image
  final String? imageUrl;

  /// First name for generating initial fallback
  final String firstName;

  /// Last name for generating full name
  final String lastName;

  /// Radius of the avatar circle
  final double radius;

  /// Whether an image is available
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// The full name for display
  String get name {
    final fullName = [
      firstName,
      lastName,
    ].map((part) => part.trim()).where((part) => part.isNotEmpty).join(' ');

    return fullName.isEmpty ? Wisher.unnamedDisplayName : fullName;
  }

  /// The initial letter to display
  String get initial {
    final firstAvailableNamePart = [firstName, lastName]
        .map((part) => part.trim())
        .firstWhere((part) => part.isNotEmpty, orElse: () => '');

    return firstAvailableNamePart.isEmpty
        ? '?'
        : firstAvailableNamePart[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    if (!hasImage) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: colorScheme.primary!,
        child: Text(
          initial,
          style: TextStyle(
            fontSize: radius * 0.67,
            color: colorScheme.onPrimary!,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      httpHeaders: AuthService.storageHeaders,
      imageBuilder: (context, imageProvider) =>
          CircleAvatar(radius: radius, backgroundImage: imageProvider),
      placeholder: (context, url) => CircleAvatar(
        radius: radius,
        backgroundColor: colorScheme.primary!,
        child: SizedBox(
          width: radius * 0.5,
          height: radius * 0.5,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.onPrimary!,
          ),
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: radius,
        backgroundColor: colorScheme.primary!,
        child: Text(
          initial,
          style: TextStyle(
            fontSize: radius * 0.67,
            color: colorScheme.onPrimary!,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Widget that displays a profile image with a name label below.
///
/// Useful for success/error overlays where you want to show the name.
class ProfileImageWithLabel extends StatelessWidget {
  const ProfileImageWithLabel({
    required this.name,
    super.key,
    this.imageUrl,
    this.localImageFile,
    this.radius = 40,
  });

  /// Remote URL for the profile image
  final String? imageUrl;

  /// Local file for preview (takes precedence)
  final File? localImageFile;

  /// Name to display below the avatar
  final String name;

  /// Radius of the avatar circle
  final double radius;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileImage(
          imageUrl: imageUrl,
          localImageFile: localImageFile,
          firstName: name,
          radius: radius,
        ),
        const AppSpacer.xsmall(),
        Text(name, style: textTheme.bodySmall),
      ],
    );
  }
}
