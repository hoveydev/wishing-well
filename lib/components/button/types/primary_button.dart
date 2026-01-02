import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button_content.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/theme/app_theme.dart';

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
  }) : _primaryButtonContentType = primaryButtonContentType;

  const PrimaryButton.icon({
    required IconData icon,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
  }) : this._(
         key: key,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         alignment: alignment,
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
  final VoidCallback onPressed;
  final bool isLoading;
  final MainAxisAlignment alignment;
  final _PrimaryButtonContentType _primaryButtonContentType;

  @override
  Widget build(BuildContext context) {
    final onPressHandler = isLoading ? null : onPressed;
    final colorScheme = context.colorScheme;

    return TextButton(
      style: ButtonStyle(
        backgroundBuilder: (context, states, child) {
          if (states.contains(WidgetState.pressed)) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 25),
              decoration: BoxDecoration(
                color: colorScheme.primary!.withValues(alpha: 0.5),
              ),
              child: child,
            );
          } else {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: colorScheme.primary!.withValues(alpha: 1),
              ),
              child: child,
            );
          }
        },
        foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
