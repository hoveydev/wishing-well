import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/button/types/primary_button.dart';
import 'package:wishing_well/components/button/types/secondary_button.dart';
import 'package:wishing_well/components/button/types/tertiary_button.dart';

enum _AppButtonContentType { icon, label, labelWithIcon }

class AppButton extends StatelessWidget {
  const AppButton._({
    required this.onPressed,
    required this.isLoading,
    required this.alignment,
    required this.type,
    required _AppButtonContentType appButtonContentType,
    super.key,
    this.label,
    this.icon,
    this.iconSize,
    this.color,
    this.fontWeight,
    this.backgroundColor,
  }) : _appButtonContentType = appButtonContentType;

  /// Creates an icon-only button.
  ///
  /// [icon] - The icon to display.
  /// [onPressed] - Callback when button is tapped.
  /// [type] - The button style (primary, secondary, tertiary).
  /// [isLoading] - Shows a loading indicator instead of the icon.
  /// [alignment] - Alignment of content within the button.
  /// [iconSize] - Custom size for the icon.
  /// [color] - Custom color (only applies to tertiary buttons).
  /// [backgroundColor] - Custom background (only applies to primary buttons).
  /// [fontWeight] - Custom font weight for text (label buttons only).
  const AppButton.icon({
    required IconData icon,
    required VoidCallback onPressed,
    required AppButtonType type,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    double? iconSize,
    Color? color,
    Color? backgroundColor,
    FontWeight? fontWeight,
  }) : this._(
         key: key,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         alignment: alignment,
         type: type,
         appButtonContentType: _AppButtonContentType.icon,
         iconSize: iconSize,
         color: color,
         backgroundColor: backgroundColor,
         fontWeight: fontWeight,
       );

  /// Creates a label-only button.
  ///
  /// [label] - The text to display.
  /// [onPressed] - Callback when button is tapped.
  /// [type] - The button style (primary, secondary, tertiary).
  /// [isLoading] - Shows a loading indicator instead of the label.
  /// [alignment] - Alignment of content within the button.
  /// [color] - Custom color (only applies to tertiary buttons).
  /// [backgroundColor] - Custom background (only applies to primary buttons).
  /// [fontWeight] - Custom font weight for the label text.
  const AppButton.label({
    required String label,
    required VoidCallback onPressed,
    required AppButtonType type,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    Color? color,
    Color? backgroundColor,
    FontWeight? fontWeight,
  }) : this._(
         key: key,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         alignment: alignment,
         type: type,
         appButtonContentType: _AppButtonContentType.label,
         color: color,
         backgroundColor: backgroundColor,
         fontWeight: fontWeight,
       );

  /// Creates a button with both an icon and label.
  ///
  /// [icon] - The icon to display.
  /// [label] - The text to display.
  /// [onPressed] - Callback when button is tapped.
  /// [type] - The button style (primary, secondary, tertiary).
  /// [isLoading] - Shows a loading indicator instead of content.
  /// [alignment] - Alignment of content within the button.
  /// [color] - Custom color (only applies to tertiary buttons).
  /// [backgroundColor] - Custom background (only applies to primary buttons).
  /// [fontWeight] - Custom font weight for the label text.
  const AppButton.labelWithIcon({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required AppButtonType type,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    Color? color,
    Color? backgroundColor,
    FontWeight? fontWeight,
  }) : this._(
         key: key,
         icon: icon,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         alignment: alignment,
         type: type,
         appButtonContentType: _AppButtonContentType.labelWithIcon,
         color: color,
         backgroundColor: backgroundColor,
         fontWeight: fontWeight,
       );
  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final MainAxisAlignment alignment;
  final AppButtonType type;
  final _AppButtonContentType _appButtonContentType;
  final double? iconSize;
  final Color? color;
  final Color? backgroundColor;

  /// Custom font weight for button text.
  ///
  /// Only applies to buttons with labels (label and labelWithIcon types).
  /// Supported on all button types: primary, secondary, and tertiary.
  final FontWeight? fontWeight;

  Widget _button(void Function()? onPressHandler) {
    switch (type) {
      case AppButtonType.primary:
        switch (_appButtonContentType) {
          case _AppButtonContentType.icon:
            return PrimaryButton.icon(
              icon: icon!,
              onPressed: onPressed,
              alignment: alignment,
              iconSize: iconSize,
              backgroundColor: backgroundColor,
              fontWeight: fontWeight,
            );
          case _AppButtonContentType.label:
            return PrimaryButton.label(
              label: label!,
              onPressed: onPressed,
              alignment: alignment,
              backgroundColor: backgroundColor,
              fontWeight: fontWeight,
            );
          case _AppButtonContentType.labelWithIcon:
            return PrimaryButton.labelWithIcon(
              icon: icon!,
              label: label!,
              onPressed: onPressed,
              alignment: alignment,
              backgroundColor: backgroundColor,
              fontWeight: fontWeight,
            );
        }
      case AppButtonType.secondary:
        switch (_appButtonContentType) {
          case _AppButtonContentType.icon:
            return SecondaryButton.icon(
              icon: icon!,
              onPressed: onPressed,
              iconSize: iconSize,
            );
          case _AppButtonContentType.label:
            return SecondaryButton.label(label: label!, onPressed: onPressed);
          case _AppButtonContentType.labelWithIcon:
            return SecondaryButton.labelWithIcon(
              icon: icon!,
              label: label!,
              onPressed: onPressed,
            );
        }
      case AppButtonType.tertiary:
        switch (_appButtonContentType) {
          case _AppButtonContentType.icon:
            return TertiaryButton.icon(
              icon: icon!,
              onPressed: onPressed,
              iconSize: iconSize,
              color: color,
              fontWeight: fontWeight,
            );
          case _AppButtonContentType.label:
            return TertiaryButton.label(
              label: label!,
              onPressed: onPressed,
              color: color,
              fontWeight: fontWeight,
            );
          case _AppButtonContentType.labelWithIcon:
            return TertiaryButton.labelWithIcon(
              icon: icon!,
              label: label!,
              onPressed: onPressed,
              color: color,
              fontWeight: fontWeight,
            );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final onPressHandler = isLoading ? null : onPressed;

    return _button(onPressHandler);
  }
}
