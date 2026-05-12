import 'package:flutter/widgets.dart';
import 'package:wishing_well/theme/app_spacer_size.dart';

class AppSpacer extends StatelessWidget {
  const AppSpacer.xsmall({super.key}) : height = AppSpacerSize.xsmall;
  const AppSpacer.small({super.key}) : height = AppSpacerSize.small;
  const AppSpacer.medium({super.key}) : height = AppSpacerSize.medium;
  const AppSpacer.large({super.key}) : height = AppSpacerSize.large;
  const AppSpacer.xlarge({super.key}) : height = AppSpacerSize.xlarge;
  const AppSpacer.xxlarge({super.key}) : height = AppSpacerSize.xxlarge;
  const AppSpacer.xxxlarge({super.key}) : height = AppSpacerSize.xxxlarge;
  const AppSpacer.huge({super.key}) : height = AppSpacerSize.huge;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height, width: height);
}
