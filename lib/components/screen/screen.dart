import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_spacing.dart';

class Screen extends StatelessWidget {
  const Screen({
    required this.children,
    super.key,
    this.appBar,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final List<Widget> children;
  final PreferredSizeWidget? appBar;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBar,
    body: LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: SafeArea(
            child: Padding(
              padding:
                  padding ??
                  const EdgeInsets.all(AppSpacing.screenPaddingStandard),
              child: Semantics(
                container: true,
                child: Column(
                  mainAxisAlignment: mainAxisAlignment,
                  crossAxisAlignment: crossAxisAlignment,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
