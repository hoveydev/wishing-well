import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_logo_size.dart';
import 'package:wishing_well/theme/app_theme.dart';

class ConfirmationImage extends StatelessWidget {
  const ConfirmationImage({required this.icon, super.key});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = AppLogoSize(sectionHeight: screenHeight).large;

    return Icon(icon, size: imageSize, color: colorScheme.success);
  }
}
