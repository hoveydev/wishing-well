import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/theme/app_theme.dart';

class Screen extends StatelessWidget {
  // essentially navbar
  const Screen({
    super.key,
    this.children = const [],
    this.padding,
    this.appBar,
  });
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Scaffold(
      appBar: appBar,
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding:
                padding ??
                const EdgeInsets.symmetric(
                  horizontal: AppSpacerSize.medium,
                ), // will we ever not want this padding for general screens?
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                // maybe find a different solution here since this is expensive
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
