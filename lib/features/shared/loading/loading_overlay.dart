import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/throbber/app_throbber.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_icon_size.dart';
import 'package:wishing_well/theme/app_spacing.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';
import 'package:wishing_well/utils/loading_controller.dart';

/// Animation duration for overlay show/hide transitions.
///
/// Used for both the fade animation and content switcher transitions.
const Duration _overlayAnimationDuration = Duration(milliseconds: 100);

class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({required this.child, super.key});
  final Widget child;

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  LoadingState? _previousState;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _overlayAnimationDuration,
    );
    _controller.value = 0.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleStateChange(LoadingState newState) {
    final wasVisible =
        _previousState != null && _previousState != LoadingState.idle;
    final isVisible = newState != LoadingState.idle;

    if (!wasVisible && isVisible) {
      _controller.forward();
    } else if (wasVisible && !isVisible) {
      _controller.reverse();
    }
    _previousState = newState;
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      widget.child,
      Consumer<LoadingController>(
        builder: (context, controller, _) {
          _handleStateChange(controller.state);

          final colorScheme = Theme.of(context).extension<AppColorScheme>();
          final l10n = AppLocalizations.of(context)!;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Opacity(
              opacity: _controller.value,
              child: IgnorePointer(
                ignoring: controller.state == LoadingState.idle,
                child: Stack(
                  children: [
                    // Background
                    Positioned.fill(
                      child: Container(color: colorScheme?.background),
                    ),
                    // Content - use AnimatedSwitcher for smooth transitions
                    Positioned.fill(
                      child: AnimatedSwitcher(
                        duration: _overlayAnimationDuration,
                        child: _buildContent(controller, colorScheme, l10n),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ],
  );

  Widget _buildContent(
    LoadingController controller,
    AppColorScheme? colorScheme,
    AppLocalizations l10n,
  ) {
    if (controller.isLoading) {
      return Center(
        key: const ValueKey('loading'),
        child: Semantics(
          label: l10n.loading,
          liveRegion: true,
          child: const AppThrobber.xlarge(),
        ),
      );
    }

    if (controller.isSuccess) {
      return _OverlayContent(
        key: const ValueKey('success'),
        controller: controller,
        colorScheme: colorScheme,
        icon: Icons.check_circle,
        iconColor: colorScheme?.success,
      );
    }

    if (controller.isError) {
      return _OverlayContent(
        key: const ValueKey('error'),
        controller: controller,
        colorScheme: colorScheme,
        icon: Icons.error,
        iconColor: colorScheme?.error,
      );
    }

    return const SizedBox(key: ValueKey('empty'));
  }
}

class _OverlayContent extends StatelessWidget {
  const _OverlayContent({
    required super.key,
    required this.controller,
    required this.colorScheme,
    required this.icon,
    required this.iconColor,
  });
  final LoadingController controller;
  final AppColorScheme? colorScheme;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final message = controller.message ?? l10n.errorUnknown;
    final name = controller.name;
    final imageUrl = controller.imageUrl;
    final localImageFile = controller.localImageFile;
    final buttonColor = controller.isError
        ? colorScheme?.error
        : colorScheme?.success;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingStandard),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show image for success, icon for error
            if (controller.isSuccess &&
                (imageUrl != null || localImageFile != null))
              CircleAvatar(
                radius: const AppIconSize().successAvatar / 2,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : FileImage(localImageFile!),
              )
            else if (controller.isSuccess)
              Icon(
                icon,
                size: const AppIconSize().successAvatar,
                color: iconColor,
              )
            else
              Icon(
                icon,
                size: const AppIconSize().successAvatar,
                color: iconColor,
              ),
            const AppSpacer.large(),
            // Bold just the name in success, otherwise regular text
            // Note: name substitution assumes it's at the start of message
            // based on the wisherCreatedSuccess localization pattern
            controller.isSuccess && name != null
                ? RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: buttonColor),
                      children: [
                        TextSpan(
                          text: name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: message.substring(name.length)),
                      ],
                    ),
                  )
                : Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: buttonColor),
                  ),
            const AppSpacer.medium(),
            AppButton.label(
              label: l10n.ok,
              onPressed: controller.acknowledgeAndClear,
              type: AppButtonType.tertiary,
              color: buttonColor,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
