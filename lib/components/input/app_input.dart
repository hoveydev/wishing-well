import 'package:flutter/material.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/theme/app_border_radius.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    required this.placeholder,
    required this.type,
    required this.onChanged,
    this.controller,
    super.key,
  });
  final String placeholder;
  final AppInputType type;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.primary),
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      ),
      child: TextField(
        obscureText: type == AppInputType.password,
        decoration: InputDecoration(
          prefixIcon: _getIcon(),
          prefixIconColor: colorScheme.primary,
          hint: Text(style: textStyle.bodyMedium, placeholder),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: _getKeyboardType(),
        autofillHints: _getAutofillHints(),
        onChanged: onChanged,
        controller: controller,
      ),
    );
  }

  TextInputType _getKeyboardType() {
    switch (type) {
      case AppInputType.text:
        return TextInputType.text;
      case AppInputType.email:
        return TextInputType.emailAddress;
      case AppInputType.password:
        return TextInputType.visiblePassword;
      default:
        return TextInputType.text;
    }
  }

  List<String> _getAutofillHints() {
    switch (type) {
      case AppInputType.email:
        return [AutofillHints.email];
      case AppInputType.password:
        return [AutofillHints.password];
      default:
        return [];
    }
  }

  Icon _getIcon() {
    switch (type) {
      case AppInputType.text:
        return const Icon(Icons.input);
      case AppInputType.email:
        return const Icon(Icons.email_outlined);
      case AppInputType.password:
        return const Icon(Icons.lock_outline);
      default:
        return const Icon(Icons.input);
    }
  }
}
