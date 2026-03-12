import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/throbber/app_throbber.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_spacing.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';
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
          final hasOverlay = controller.hasOverlay;
          final colorScheme = Theme.of(context).extension<AppColorScheme>();
          final l10n = AppLocalizations.of(context)!;

          return IgnorePointer(
            ignoring: !hasOverlay,
            child: AnimatedOpacity(
              opacity: hasOverlay ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: Stack(
                children: [
                  const ModalBarrier(
                    dismissible: false,
                    color: Colors.transparent,
                  ),
                  Container(
                    color: colorScheme?.background,
                    child: _buildContent(
                      context,
                      controller,
                      colorScheme,
                      l10n,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );

  Widget _buildContent(
    BuildContext context,
    LoadingController controller,
    AppColorScheme? colorScheme,
    AppLocalizations l10n,
  ) {
    if (controller.isLoading) {
      return Center(
        child: Semantics(
          label: l10n.loading,
          liveRegion: true,
          child: const AppThrobber.xlarge(),
        ),
      );
    }

    if (controller.isSuccess) {
      return _buildSuccessOrErrorContent(
        context: context,
        controller: controller,
        colorScheme: colorScheme,
        l10n: l10n,
        icon: Icons.check_circle,
        iconColor: colorScheme?.success,
        message: controller.message ?? '',
      );
    }

    if (controller.isError) {
      return _buildSuccessOrErrorContent(
        context: context,
        controller: controller,
        colorScheme: colorScheme,
        l10n: l10n,
        icon: Icons.error,
        iconColor: colorScheme?.error,
        message: controller.message ?? l10n.errorUnknown,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSuccessOrErrorContent({
    required BuildContext context,
    required LoadingController controller,
    required AppColorScheme? colorScheme,
    required AppLocalizations l10n,
    required IconData icon,
    required Color? iconColor,
    required String message,
  }) {
    final buttonColor = controller.isError
        ? colorScheme?.error
        : colorScheme?.success;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: AppSpacing.screenPaddingStandard,
          left: AppSpacing.screenPaddingStandard,
          right: AppSpacing.screenPaddingStandard,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: message,
              liveRegion: true,
              child: Icon(icon, size: 64, color: iconColor),
            ),
            const AppSpacer.large(),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const AppSpacer.large(),
            AppButton.label(
              label: l10n.ok,
              onPressed: () => controller.handleOkPressed(),
              type: AppButtonType.tertiary,
              color: buttonColor,
            ),
          ],
        ),
      ),
    );
  }
}
