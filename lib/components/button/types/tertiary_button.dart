import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button_content.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/theme/app_theme.dart';

enum _TertiaryButtonContentType { icon, label, labelWithIcon }

class TertiaryButton extends StatelessWidget {
  const TertiaryButton._({
    required this.onPressed,
    required _TertiaryButtonContentType tertiaryButtonContentType,
    super.key,
    this.icon,
    this.label,
    this.isLoading = false,
  }) : _tertiaryButtonContentType = tertiaryButtonContentType;

  const TertiaryButton.icon({
    required IconData icon,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
  }) : this._(
         key: key,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         tertiaryButtonContentType: _TertiaryButtonContentType.icon,
       );

  const TertiaryButton.label({
    required String label,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
  }) : this._(
         key: key,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         tertiaryButtonContentType: _TertiaryButtonContentType.label,
       );

  const TertiaryButton.labelWithIcon({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
  }) : this._(
         key: key,
         label: label,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         tertiaryButtonContentType: _TertiaryButtonContentType.labelWithIcon,
       );
  final IconData? icon;
  final String? label;
  final VoidCallback onPressed;
  final bool isLoading;
  final _TertiaryButtonContentType _tertiaryButtonContentType;

  @override
  Widget build(BuildContext context) {
    final onPressHandler = isLoading ? null : onPressed;
    final colorScheme = context.colorScheme;

    return TextButton(
      style: ButtonStyle(
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStatePropertyAll(colorScheme.primary),
        padding: WidgetStateProperty.all(
          _tertiaryButtonContentType == _TertiaryButtonContentType.icon
              ? const EdgeInsets.all(0)
              : const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        elevation: WidgetStateProperty.all(0),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
      ),
      onPressed: onPressHandler,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (_tertiaryButtonContentType) {
      case _TertiaryButtonContentType.icon:
        return AppButtonContent.icon(
          icon: icon!,
          buttonType: AppButtonType.tertiary,
          isLoading: isLoading,
        );
      case _TertiaryButtonContentType.label:
        return AppButtonContent.label(
          label: label!,
          buttonType: AppButtonType.tertiary,
          isLoading: isLoading,
        );
      case _TertiaryButtonContentType.labelWithIcon:
        return AppButtonContent.labelWithIcon(
          icon: icon!,
          label: label!,
          buttonType: AppButtonType.tertiary,
          isLoading: isLoading,
        );
    }
  }
}
