import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button_content.dart';
import 'package:wishing_well/components/button/app_button_type.dart';

enum _SecondaryButtonContentType { icon, label, labelWithIcon }

class SecondaryButton extends StatelessWidget {
  const SecondaryButton._({
    required this.onPressed,
    required _SecondaryButtonContentType secondaryButtonContentType,
    super.key,
    this.icon,
    this.label,
    this.isLoading = false,
  }) : _secondaryButtonContentType = secondaryButtonContentType;

  const SecondaryButton.icon({
    required IconData icon,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
  }) : this._(
         key: key,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         secondaryButtonContentType: _SecondaryButtonContentType.icon,
       );

  const SecondaryButton.label({
    required String label,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
  }) : this._(
         key: key,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         secondaryButtonContentType: _SecondaryButtonContentType.label,
       );

  const SecondaryButton.labelWithIcon({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Key? key,
    bool isLoading = false,
  }) : this._(
         key: key,
         icon: icon,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         secondaryButtonContentType: _SecondaryButtonContentType.labelWithIcon,
       );
  final IconData? icon;
  final String? label;
  final VoidCallback onPressed;
  final bool isLoading;
  final _SecondaryButtonContentType _secondaryButtonContentType;

  @override
  Widget build(BuildContext context) {
    final onPressHandler = isLoading ? null : onPressed;
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      style: ButtonStyle(
        backgroundBuilder: (context, states, child) {
          if (states.contains(WidgetState.pressed)) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 25),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.15),
              ),
              child: child,
            );
          } else {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: const BoxDecoration(color: Colors.transparent),
              child: child,
            );
          }
        },
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        elevation: WidgetStateProperty.all(0),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        side: WidgetStatePropertyAll(BorderSide(color: colorScheme.primary)),
      ),
      onPressed: onPressHandler,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (_secondaryButtonContentType) {
      case _SecondaryButtonContentType.icon:
        return AppButtonContent.icon(
          icon: icon!,
          buttonType: AppButtonType.secondary,
          isLoading: isLoading,
        );
      case _SecondaryButtonContentType.label:
        return AppButtonContent.label(
          label: label!,
          buttonType: AppButtonType.secondary,
          isLoading: isLoading,
        );
      case _SecondaryButtonContentType.labelWithIcon:
        return AppButtonContent.labelWithIcon(
          icon: icon!,
          label: label!,
          buttonType: AppButtonType.secondary,
          isLoading: isLoading,
        );
    }
  }
}
