import 'package:flutter/material.dart';
import 'package:wishing_well/components/throbber/app_throbber_size.dart';

class AppThrobber extends StatelessWidget {
  final double size;
  // coverage:ignore-start
  const AppThrobber.xsmall({super.key}) : size = AppThrobberSize.xsmall;
  const AppThrobber.small({super.key}) : size = AppThrobberSize.small;
  const AppThrobber.medium({super.key}) : size = AppThrobberSize.medium;
  const AppThrobber.large({super.key}) : size = AppThrobberSize.large;
  const AppThrobber.xlarge({super.key}) : size = AppThrobberSize.xlarge;
  // coverage:ignore-end

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final CircularProgressIndicator spinner =
        CircularProgressIndicator.adaptive(
          backgroundColor: colorScheme.primary,
        );
    // TODO: on iOS size cannot change with adaptive spinner - will need custom solution later
    return SizedBox(height: size, width: size, child: spinner);
  }
}
