import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button_content.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/button/button_feedback_style.dart';

enum _PrimaryButtonContentType { icon, label, labelWithIcon }

class PrimaryButton extends StatelessWidget {
  const PrimaryButton._({
    required this.onPressed,
    required this.isLoading,
    required this.alignment,
    required _PrimaryButtonContentType primaryButtonContentType,
    super.key,
    this.icon,
    this.label,
    this.semanticLabel,
    this.iconSize,
    this.fontWeight,
    this.backgroundColor,
  }) : _primaryButtonContentType = primaryButtonContentType;

  const PrimaryButton.icon({
    required IconData icon,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    String? semanticLabel,
    double? iconSize,
    FontWeight? fontWeight,
    Color? backgroundColor,
  }) : this._(
         key: key,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         alignment: alignment,
         semanticLabel: semanticLabel,
         primaryButtonContentType: _PrimaryButtonContentType.icon,
         iconSize: iconSize,
         fontWeight: fontWeight,
         backgroundColor: backgroundColor,
       );

  const PrimaryButton.label({
    required String label,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    FontWeight? fontWeight,
    Color? backgroundColor,
  }) : this._(
         key: key,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         alignment: alignment,
         primaryButtonContentType: _PrimaryButtonContentType.label,
         fontWeight: fontWeight,
         backgroundColor: backgroundColor,
       );

  const PrimaryButton.labelWithIcon({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    FontWeight? fontWeight,
    Color? backgroundColor,
  }) : this._(
         key: key,
         icon: icon,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         alignment: alignment,
         primaryButtonContentType: _PrimaryButtonContentType.labelWithIcon,
         fontWeight: fontWeight,
         backgroundColor: backgroundColor,
       );
  final IconData? icon;
  final String? label;
  final String? semanticLabel;
  final VoidCallback onPressed;
  final bool isLoading;
  final MainAxisAlignment alignment;
  final _PrimaryButtonContentType _primaryButtonContentType;
  final double? iconSize;
  final FontWeight? fontWeight;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final onPressHandler = isLoading ? null : onPressed;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    // Ensure minimum button height scales with text size
    // Base height of 56 (button + padding) scales with text
    final minHeight = (56.0 * textScale).clamp(56.0, 72.0);

    final buttonWidget = TextButton(
      style: ButtonFeedbackStyle.primary(
        context: context,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, minHeight)),
        color: backgroundColor,
      ),
      onPressed: onPressHandler,
      child: _buildContent(context),
    );

    if (semanticLabel != null) {
      return Semantics(label: semanticLabel, button: true, child: buttonWidget);
    }
    return buttonWidget;
  }

  Widget _buildContent(BuildContext context) {
    switch (_primaryButtonContentType) {
      case _PrimaryButtonContentType.icon:
        return AppButtonContent.icon(
          icon: icon!,
          buttonType: AppButtonType.primary,
          isLoading: isLoading,
          alignment: alignment,
          iconSize: iconSize,
          fontWeight: fontWeight,
        );
      case _PrimaryButtonContentType.label:
        return AppButtonContent.label(
          label: label!,
          buttonType: AppButtonType.primary,
          isLoading: isLoading,
          alignment: alignment,
          fontWeight: fontWeight,
        );
      case _PrimaryButtonContentType.labelWithIcon:
        return AppButtonContent.labelWithIcon(
          icon: icon!,
          label: label!,
          buttonType: AppButtonType.primary,
          isLoading: isLoading,
          alignment: alignment,
          fontWeight: fontWeight,
        );
    }
  }
}
