import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button_content.dart';
import 'package:wishing_well/components/button/app_button_style.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:wishing_well/utilities.dart';

enum _PrimaryButtonContentType { icon, label, labelWithIcon }

class PrimaryButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onPressed;
  final bool isLoading;
  final MainAxisAlignment alignment;
  final _PrimaryButtonContentType _primaryButtonContentType;

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

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style(AppButtonType.primary);
    final onPressHandler = isLoading ? null : onPressed;

    if (isIOS) {
      return CupertinoButton.filled(
        onPressed: onPressHandler,
        color: AppColors.primary,
        foregroundColor: AppColors.white,
        child: _buildContent(context),
      );
    } else {
      return ElevatedButton(
        style: buttonStyle,
        onPressed: onPressHandler,
        child: _buildContent(context),
      );
    }
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
