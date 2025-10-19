import 'package:flutter/material.dart';
import 'package:wishing_well/components/input/input_type.dart';
import 'package:wishing_well/theme.dart';

class Input extends StatelessWidget {
  final String placeholder;
  final InputType type;
  final TextEditingController controller;

  const Input({
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
      keyboardType: type == InputType.text ? TextInputType.text : TextInputType.number,
      ),
    );
  }
}