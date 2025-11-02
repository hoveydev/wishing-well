import 'package:flutter/material.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:wishing_well/theme/app_border_weight.dart';

class AppInput extends StatelessWidget {
  final String placeholder;
  final AppInputType type;
  final TextEditingController controller;

  const AppInput({
    super.key,
    required this.placeholder,
    required this.type,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final textEditHandler = TextEditingController(text: controller.text);
    final textStyle = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: AppBorderWeight.regular),
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      ),
      child: TextField(
        obscureText: type == AppInputType.password,
        controller: textEditHandler,
        decoration: InputDecoration(
          hint: Text(style: textStyle.bodyMedium, placeholder),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: _getKeyboardType(),
        autofillHints: _getAutofillHints(),
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
      case AppInputType.text:
        return [AutofillHints.username];
      case AppInputType.email:
        return [AutofillHints.email];
      case AppInputType.password:
        return [AutofillHints.password];
      default:
        return [];
    }
  }
}