import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/types/primary_button.dart';
import 'package:wishing_well/components/button/types/secondary_button.dart';
import 'package:wishing_well/components/button/types/tertiary_button.dart';
import 'button_type.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final ButtonType type;

  const Button({
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
      case ButtonType.primary:
        return PrimaryButton(label: label, onPressed: onPressed);
      case ButtonType.secondary:
        return SecondaryButton(label: label, onPressed: onPressed);
      case ButtonType.tertiary:
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
