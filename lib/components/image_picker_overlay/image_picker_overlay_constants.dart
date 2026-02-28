// Constants for the ImagePickerOverlay component
import 'package:flutter/material.dart';

/// Size constants for the overlay icon container
class ImagePickerOverlaySize {
  const ImagePickerOverlaySize._();

  /// Diameter of the circular icon container
  static const double iconContainer = 80.0;

  /// Size of the icon within the container
  static const double icon = 40.0;
}

/// Animation constants for the overlay
class ImagePickerOverlayAnimation {
  const ImagePickerOverlayAnimation._();

  /// Total duration of one pulse cycle
  static const Duration pulseDuration = Duration(milliseconds: 1500);

  /// Interval for fade-in (0-13% of animation)
  static const double fadeInIntervalEnd = 0.13;

  /// Opacity values for the pulsing icon
  static const double iconOpacityMin = 0.6;
  static const double iconOpacityMax = 1.0;
  static const double iconOpacityRange = iconOpacityMax - iconOpacityMin;

  /// Scale values for the pulsing icon
  static const double iconScaleMin = 0.9;
  static const double iconScaleMax = 1.1;
  static const double iconScaleRange = iconScaleMax - iconScaleMin;
}

/// Visual constants for the overlay
class ImagePickerOverlayVisuals {
  const ImagePickerOverlayVisuals._();

  /// Background color opacity for the overlay backdrop
  static const Color backdropColor = Colors.black;
  static const double backdropOpacity = 0.5;

  /// Opacity for the icon container background
  static const double containerOpacity = 0.9;

  /// Opacity for text color
  static const double textOpacity = 0.9;

  /// Text styling
  static const double textSize = 16.0;
  static const FontWeight textWeight = FontWeight.w500;

  /// Spacing between icon and text
  static const double textSpacing = 16.0;
}

/// Default messages shown in the overlay
class ImagePickerOverlayMessage {
  const ImagePickerOverlayMessage._();

  /// Message shown when opening gallery
  static const String gallery = 'Opening gallery...';

  /// Message shown when opening camera
  static const String camera = 'Opening camera...';
}

/// Icon constants for the overlay
class ImagePickerOverlayIcon {
  const ImagePickerOverlayIcon._();

  /// Icon shown in the overlay
  static const IconData icon = Icons.photo_library_outlined;
}
