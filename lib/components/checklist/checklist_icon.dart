import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_icon_size.dart';

class ChecklistIcon extends StatelessWidget {
  const ChecklistIcon({
    required this.iconColor,
    required this.bgColor,
    required this.borderColor,
    super.key,
    this.icon,
  });

  final Color iconColor;
  final Color bgColor;
  final Color borderColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    width: const AppIconSize().medium,
    height: const AppIconSize().medium,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: bgColor,
      border: Border.all(color: borderColor),
    ),
    child: Center(
      child: Icon(icon, size: const AppIconSize().small, color: iconColor),
    ),
  );
}
