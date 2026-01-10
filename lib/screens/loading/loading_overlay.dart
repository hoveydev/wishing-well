import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/throbber/app_throbber.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      child,
      Consumer<LoadingController>(
        builder: (context, controller, _) {
          final visible = controller.isLoading;
          final colorScheme = context.colorScheme;

          return IgnorePointer(
            ignoring: !visible,
            child: AnimatedOpacity(
              opacity: visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: Stack(
                children: [
                  const ModalBarrier(
                    dismissible: false,
                    color: Colors.transparent,
                  ),
                  Container(
                    color: colorScheme.background,
                    child: const Center(child: AppThrobber.xlarge()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );
}
