import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button_content.dart';
import 'package:wishing_well/components/button/app_button_style.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:wishing_well/utilities.dart';

enum _SecondaryButtonContentType { icon, label, labelWithIcon }

class SecondaryButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onPressed;
  final bool isLoading;
  final _SecondaryButtonContentType _secondaryButtonContentType;

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

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style(AppButtonType.secondary);
    final onPressHandler = isLoading ? null : onPressed;

    if (isIOS) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(14),
        ),
        child: CupertinoButton(
          onPressed: onPressHandler,
          child: _buildContent(context),
        ),
      );
    } else {
      return OutlinedButton(
        style: buttonStyle,
        onPressed: onPressHandler,
        child: _buildContent(context),
      );
    }
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
