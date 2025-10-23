import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/types/primary_button.dart';
import 'package:wishing_well/components/button/types/secondary_button.dart';
import 'package:wishing_well/components/button/types/tertiary_button.dart';
import 'app_button_type.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final AppButtonType type;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.type,
    this.isLoading = false,
  });

  Widget _button(
    void Function()? onPressHandler,
  ) {
    switch (type) {
      case AppButtonType.primary:
        return PrimaryButton(label: label, onPressed: onPressed);
      case AppButtonType.secondary:
        return SecondaryButton(label: label, onPressed: onPressed);
      case AppButtonType.tertiary:
        return TertiaryButton(label: label, onPressed: onPressed);
    }
  }

  @override
  Widget build(BuildContext context) {

    final onPressHandler = isLoading ? null : onPressed;

    return SizedBox(
      width: double.infinity,
      child: _button(onPressHandler),
    );
  }
}
