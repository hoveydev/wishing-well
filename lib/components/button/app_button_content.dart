import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button_style.dart';
import 'package:wishing_well/components/button/app_button_type.dart';

enum _AppButtonContentType { icon, label, labelWithIcon }

class AppButtonContent extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isLoading;
  final MainAxisAlignment alignment;
  final AppButtonType buttonType;
  final _AppButtonContentType _appButtonContentType;

  const AppButtonContent._({
    super.key,
    this.label,
    this.icon,
    required this.isLoading,
    required this.alignment,
    required this.buttonType,
    required _AppButtonContentType appButtonContentType,
  }) : _appButtonContentType = appButtonContentType;

  const AppButtonContent.icon({
    Key? key,
    required IconData icon,
    required AppButtonType buttonType,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center
  }) : this._(
    key: key,
    icon: icon,
    buttonType: buttonType,
    isLoading: isLoading,
    alignment: alignment,
    appButtonContentType: _AppButtonContentType.icon
  );

  const AppButtonContent.label({
    Key? key,
    required String label,
    required AppButtonType buttonType,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center
  }) : this._(
    key: key,
    label: label,
    buttonType: buttonType,
    isLoading: isLoading,
    alignment: alignment,
    appButtonContentType: _AppButtonContentType.label
  );

  const AppButtonContent.labelWithIcon({
    Key? key,
    required String label,
    required IconData icon,
    required AppButtonType buttonType,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center
  }) : this._(
    key: key,
    label: label,
    icon: icon,
    buttonType: buttonType,
    isLoading: isLoading,
    alignment: alignment,
    appButtonContentType: _AppButtonContentType.labelWithIcon
  );

  @override
  Widget build(BuildContext context) {

    final ButtonStyle buttonStyle = style(buttonType);
    final Color resolvedForegroundColor = buttonStyle
            .foregroundColor
            ?.resolve(<WidgetState>{}) ??
        Theme.of(context).colorScheme.onPrimary;
    final TextTheme textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: alignment,
        children: _buildContent(context, textTheme, resolvedForegroundColor),
      );
    }
  }

  List<Widget> _buildContent(BuildContext context, TextTheme textTheme, Color textColor) {
    switch (_appButtonContentType) {
      case _AppButtonContentType.icon:
        return [
          Icon(
            icon!,
            size: textTheme.headlineLarge!.fontSize,
            color: textColor
          )
        ];
      case _AppButtonContentType.label:
        return [
          Text(
            label!,
            style: textTheme.bodyLarge?.copyWith(color: textColor),
          )
        ];
      case _AppButtonContentType.labelWithIcon:
        return [
          Icon(
            icon!,
            size: textTheme.headlineLarge!.fontSize,
            color: textColor
          ),
          Text(
            label!,
            style: textTheme.bodyLarge?.copyWith(color: textColor),
          )
        ];
    }
  }
}