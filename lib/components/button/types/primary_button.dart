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
  }) : _primaryButtonContentType = primaryButtonContentType;

  const PrimaryButton.icon({
    required IconData icon,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    String? semanticLabel,
  }) : this._(
         key: key,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         alignment: alignment,
         semanticLabel: semanticLabel,
         primaryButtonContentType: _PrimaryButtonContentType.icon,
       );

  const PrimaryButton.label({
    required String label,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
  }) : this._(
         key: key,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         alignment: alignment,
         primaryButtonContentType: _PrimaryButtonContentType.label,
       );

  const PrimaryButton.labelWithIcon({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
  }) : this._(
         key: key,
         icon: icon,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         alignment: alignment,
         primaryButtonContentType: _PrimaryButtonContentType.labelWithIcon,
       );
  final IconData? icon;
  final String? label;
  final String? semanticLabel;
  final VoidCallback onPressed;
  final bool isLoading;
  final MainAxisAlignment alignment;
  final _PrimaryButtonContentType _primaryButtonContentType;

  @override
  Widget build(BuildContext context) {
    final onPressHandler = isLoading ? null : onPressed;
    final buttonWidget = TextButton(
      style: ButtonFeedbackStyle.primary(
        context: context,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
        );
      case _PrimaryButtonContentType.label:
        return AppButtonContent.label(
          label: label!,
          buttonType: AppButtonType.primary,
          isLoading: isLoading,
          alignment: alignment,
        );
      case _PrimaryButtonContentType.labelWithIcon:
        return AppButtonContent.labelWithIcon(
          icon: icon!,
          label: label!,
          buttonType: AppButtonType.primary,
          isLoading: isLoading,
          alignment: alignment,
        );
    }
  }
}
