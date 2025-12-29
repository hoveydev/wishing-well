import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';

class ConfirmationSubtext extends StatelessWidget {
  final String subtext;

  const ConfirmationSubtext({required this.subtext, super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacerSize.large),
      child: Text(
        subtext,
        style: textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
