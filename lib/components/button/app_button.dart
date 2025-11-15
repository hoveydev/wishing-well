import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/types/primary_button.dart';
import 'package:wishing_well/components/button/types/secondary_button.dart';
import 'package:wishing_well/components/button/types/tertiary_button.dart';
import 'app_button_type.dart';

enum _AppButtonContentType { icon, label, labelWithIcon }

class AppButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final MainAxisAlignment alignment;
  final AppButtonType type;
  final _AppButtonContentType _appButtonContentType;

  const AppButton._({
    super.key,
    this.label,
    this.icon,
    required this.onPressed,
    required this.isLoading,
    required this.alignment,
    required this.type,
    required _AppButtonContentType appButtonContentType,
  }) : _appButtonContentType = appButtonContentType;

  const AppButton.icon({
    Key? key,
    required Widget icon,
    required VoidCallback onPressed,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    required AppButtonType type,
  }) : this._(
    key: key,
    icon: icon,
    onPressed: onPressed,
    isLoading: isLoading,
    alignment: alignment,
    type: type,
    appButtonContentType: _AppButtonContentType.icon
  );

  const AppButton.label({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    required AppButtonType type,
  }) : this._(
    key: key,
    label: label,
    onPressed: onPressed,
    isLoading: isLoading,
    alignment: alignment,
    type: type,
    appButtonContentType: _AppButtonContentType.label
  );

  const AppButton.labelWithIcon({
    Key? key,
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    required AppButtonType type,
  }) : this._(
    key: key,
    icon: icon,
    label: label,
    onPressed: onPressed,
    isLoading: isLoading,
    alignment: alignment,
    type: type,
    appButtonContentType: _AppButtonContentType.labelWithIcon
  );

  Widget _button(
    void Function()? onPressHandler,
  ) {
    switch (type) {
      case AppButtonType.primary:
        switch (_appButtonContentType) {
          case _AppButtonContentType.icon:
            return PrimaryButton.icon(icon: icon!, onPressed: onPressed, alignment: alignment);
          case _AppButtonContentType.label:
            return PrimaryButton.label(label: label!, onPressed: onPressed, alignment: alignment);
          case _AppButtonContentType.labelWithIcon:
            return PrimaryButton.labelWithIcon(icon: icon!, label: label!, onPressed: onPressed, alignment: alignment);
        }
      case AppButtonType.secondary:
        switch (_appButtonContentType) {
          case _AppButtonContentType.icon:
            return SecondaryButton.icon(icon: icon!, onPressed: onPressed);
          case _AppButtonContentType.label:
            return SecondaryButton.label(label: label!, onPressed: onPressed);
          case _AppButtonContentType.labelWithIcon:
            return SecondaryButton.labelWithIcon(icon: icon!, label: label!, onPressed: onPressed);
        }
      case AppButtonType.tertiary:
        switch (_appButtonContentType) {
          case _AppButtonContentType.icon:
            return TertiaryButton.icon(icon: icon!, onPressed: onPressed);
          case _AppButtonContentType.label:
            return TertiaryButton.label(label: label!, onPressed: onPressed);
          case _AppButtonContentType.labelWithIcon:
            return TertiaryButton.labelWithIcon(icon: icon!, label: label!, onPressed: onPressed);
        }
    }
  }

  @override
  Widget build(BuildContext context) {

    final onPressHandler = isLoading ? null : onPressed;

    return SizedBox(
      child: _button(onPressHandler),
    );
  }
}
