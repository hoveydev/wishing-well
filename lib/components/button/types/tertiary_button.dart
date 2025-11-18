import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button_content.dart';
import 'package:wishing_well/components/button/app_button_style.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:wishing_well/utilities.dart';
import '../app_button_type.dart';

enum _TertiaryButtonContentType { icon, label, labelWithIcon }

class TertiaryButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onPressed;
  final bool isLoading;
  final _TertiaryButtonContentType _tertiaryButtonContentType;

  const TertiaryButton._({
    super.key,
    this.icon,
    this.label,
    required this.onPressed,
    this.isLoading = false,
    required _TertiaryButtonContentType tertiaryButtonContentType,
  }) : _tertiaryButtonContentType = tertiaryButtonContentType;

  const TertiaryButton.icon({
    Key? key,
    required IconData icon,
    required VoidCallback onPressed,
    bool isLoading = false
  }) : this._(
    key: key,
    icon: icon,
    onPressed: onPressed,
    isLoading: isLoading,
    tertiaryButtonContentType: _TertiaryButtonContentType.icon
  );

  const TertiaryButton.label({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) : this._(
    key: key,
    label: label,
    onPressed: onPressed,
    isLoading: isLoading,
    tertiaryButtonContentType: _TertiaryButtonContentType.label
  );

  const TertiaryButton.labelWithIcon({
    Key? key,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) : this._(
    key: key,
    label: label,
    icon: icon,
    onPressed: onPressed,
    isLoading: isLoading,
    tertiaryButtonContentType: _TertiaryButtonContentType.labelWithIcon
  );

  @override
  Widget build(BuildContext context) {

    final buttonStyle = style(AppButtonType.primary);
    final onPressHandler = isLoading ? null : onPressed;

    if (isIOS) {
      return CupertinoButton.filled(
        onPressed: onPressHandler,
        color: AppColors.transparent,
        child: _buildContent(context)
      );
    } else {
      return ElevatedButton(
        style: buttonStyle,
        onPressed: onPressHandler,
        child: _buildContent(context)
      );
    }
  }

  Widget _buildContent(BuildContext context) {
    switch (_tertiaryButtonContentType) {
      case _TertiaryButtonContentType.icon:
        return AppButtonContent.icon(
          icon: icon!,
          buttonType: AppButtonType.tertiary,
          isLoading: isLoading
        );
      case _TertiaryButtonContentType.label:
        return AppButtonContent.label(
          label: label!,
          buttonType: AppButtonType.tertiary,
          isLoading: isLoading
        );
      case _TertiaryButtonContentType.labelWithIcon:
        return AppButtonContent.labelWithIcon(
          icon: icon!,
          label: label!,
          buttonType: AppButtonType.tertiary,
          isLoading: isLoading
        );
    }
  }
}