import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';

class Screen extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final PreferredSizeWidget? appBar; // essentially navbar
  const Screen({
    super.key,
    this.children = const [],
    this.padding,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: appBar,
      backgroundColor: colorScheme.surface,
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
