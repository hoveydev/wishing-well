import 'package:flutter/material.dart';
import 'package:wishing_well/components/throbber/app_throbber_size.dart';

class AppThrobber extends StatelessWidget {
  // coverage:ignore-start
  const AppThrobber.xsmall({super.key}) : size = AppThrobberSize.xsmall;
  const AppThrobber.small({super.key}) : size = AppThrobberSize.small;
  const AppThrobber.medium({super.key}) : size = AppThrobberSize.medium;
  const AppThrobber.large({super.key}) : size = AppThrobberSize.large;
  const AppThrobber.xlarge({super.key}) : size = AppThrobberSize.xlarge;
  final double size;
  // coverage:ignore-end

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final CircularProgressIndicator spinner =
        CircularProgressIndicator.adaptive(
          backgroundColor: colorScheme.primary,
        );
    // TODO: custom solution needed
    return SizedBox(height: size, width: size, child: spinner);
  }
}
