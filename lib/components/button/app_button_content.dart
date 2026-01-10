import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button_type.dart';

enum _AppButtonContentType { icon, label, labelWithIcon }

class AppButtonContent extends StatelessWidget {
  const AppButtonContent._({
    required this.isLoading,
    required this.alignment,
    required this.buttonType,
    required _AppButtonContentType appButtonContentType,
    super.key,
    this.label,
    this.icon,
  }) : _appButtonContentType = appButtonContentType;

  const AppButtonContent.icon({
    required IconData icon,
    required AppButtonType buttonType,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
  }) : this._(
         key: key,
         icon: icon,
         buttonType: buttonType,
         isLoading: isLoading,
         alignment: alignment,
         appButtonContentType: _AppButtonContentType.icon,
       );

  const AppButtonContent.label({
    required String label,
    required AppButtonType buttonType,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
  }) : this._(
         key: key,
         label: label,
         buttonType: buttonType,
         isLoading: isLoading,
         alignment: alignment,
         appButtonContentType: _AppButtonContentType.label,
       );

  const AppButtonContent.labelWithIcon({
    required String label,
    required IconData icon,
    required AppButtonType buttonType,
    Key? key,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
  }) : this._(
         key: key,
         label: label,
         icon: icon,
         buttonType: buttonType,
         isLoading: isLoading,
         alignment: alignment,
         appButtonContentType: _AppButtonContentType.labelWithIcon,
       );
  final String? label;
  final IconData? icon;
  final bool isLoading;
  final MainAxisAlignment alignment;
  final AppButtonType buttonType;
  final _AppButtonContentType _appButtonContentType;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else {
      return Row(
        mainAxisAlignment: alignment,
        children: _buildContent(context, textTheme),
      );
    }
  }

  List<Widget> _buildContent(BuildContext context, TextTheme textTheme) {
    switch (_appButtonContentType) {
      case _AppButtonContentType.icon:
        return [Icon(icon!, size: textTheme.headlineLarge!.fontSize)];
      case _AppButtonContentType.label:
        return [
          Flexible(
            child: Text(
              label!,
              style: TextStyle(fontSize: textTheme.bodyLarge!.fontSize),
              textAlign: TextAlign.center,
            ),
          ),
        ];
      case _AppButtonContentType.labelWithIcon:
        return [
          Icon(icon!, size: textTheme.headlineLarge!.fontSize),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label!,
              style: TextStyle(fontSize: textTheme.bodyLarge!.fontSize),
            ),
          ),
        ];
    }
  }
}
