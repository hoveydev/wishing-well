import 'package:flutter/widgets.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';

class AppSpacer extends StatelessWidget {
  final double height;
  const AppSpacer.xsmall({super.key}) : height = AppSpacerSize.xsmall;
  const AppSpacer.small({super.key}) : height = AppSpacerSize.small;
  const AppSpacer.medium({super.key}) : height = AppSpacerSize.medium;
  const AppSpacer.large({super.key}) : height = AppSpacerSize.large;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}