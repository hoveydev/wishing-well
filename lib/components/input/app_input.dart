import 'package:flutter/material.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/theme/app_colors.dart';

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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
      controller: textEditHandler,
      decoration: InputDecoration(
        hint: Text(style: TextStyle(color: AppColors.primary, fontSize: 16), placeholder),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: type == AppInputType.text ? TextInputType.text : TextInputType.number,
      ),
    );
  }
}