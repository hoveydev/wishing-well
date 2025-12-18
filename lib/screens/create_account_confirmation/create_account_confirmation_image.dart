import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_logo_size.dart';
import 'package:wishing_well/theme/app_theme.dart';

class CreateAccountConfirmationImage extends StatelessWidget {
  const CreateAccountConfirmationImage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = AppLogoSize(sectionHeight: screenHeight).large;

    return Icon(
      Icons.check_circle,
      size: imageSize,
      color: colorScheme.success,
    );
  }
}
