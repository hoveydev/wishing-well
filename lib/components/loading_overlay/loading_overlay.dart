import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/profile_image/profile_image.dart';
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

/// A widget that wraps its child with a loading overlay.
///
/// The overlay responds to [LoadingController] state changes and displays
/// different content based on the current state:
/// - [LoadingState.idle]: No overlay (child is fully visible)
/// - [LoadingState.loading]: Loading spinner with optional message
/// - [LoadingState.success]: Success message with checkmark icon
/// - [LoadingState.error]: Error message with error icon and OK button
/// - [LoadingState.warning]: Warning message with confirm/cancel actions
///
/// The overlay is animated with a fade transition and automatically handles
/// user acknowledgment for success/error states.
///
/// ## Usage
///
/// Wrap any screen or widget that needs to show loading states:
///
/// ```dart
/// LoadingOverlay(
///   child: MyScreen(),
/// )
/// ```
///
/// Then use the [LoadingController] to control the overlay:
///
/// ```dart
/// final loading = context.read<LoadingController>();
/// loading.show();           // Show loading spinner
/// loading.showSuccess('Operation complete!');
/// loading.showError('Something went wrong');
/// ```
///
/// ## Requirements
///
/// - A [LoadingController] must be provided via a [ChangeNotifierProvider]
///   ancestor (typically at the app level)
/// - The overlay displays over the child widget, blocking interaction
///   when visible
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

  /// Builds the appropriate overlay content based on loading state.
  ///
  /// Returns different widgets for each [LoadingState]:
  /// - [LoadingState.loading]: Shows a centered throbber/spinner
  /// - [LoadingState.success]: Shows success icon with message
  /// - [LoadingState.error]: Shows error icon with message and OK button
  /// - [LoadingState.warning]: Shows warning icon with message and two actions
  /// - [LoadingState.idle]: Returns an empty SizedBox
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

    if (controller.isWarning) {
      return _OverlayContent(
        key: const ValueKey('warning'),
        controller: controller,
        colorScheme: colorScheme,
        icon: Icons.warning_amber_outlined,
        iconColor: colorScheme?.warning,
      );
    }

    return const SizedBox(key: ValueKey('empty'));
  }
}

/// Internal widget that displays non-loading overlay content.
///
/// Shows an icon, a message, and optionally an image or name for success
/// states. Success and error states include an OK button, while warning
/// states include primary and secondary confirmation actions.
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
    final messageColor = controller.isError
        ? colorScheme?.error
        : controller.isWarning
        ? colorScheme?.primary
        : colorScheme?.success;
    final textStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(color: messageColor);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingStandard),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show image for success, icon for error
            if (controller.isSuccess && name != null)
              ProfileImage(
                imageUrl: imageUrl,
                localImageFile: localImageFile,
                firstName: name,
                radius: const AppIconSize().overlayIcon / 2,
              )
            else
              Icon(
                icon,
                size: const AppIconSize().overlayIcon,
                color: iconColor,
              ),
            const AppSpacer.large(),
            controller.isSuccess && name != null
                ? _buildPersonalizedMessage(
                    message: message,
                    name: name,
                    textStyle: textStyle,
                  )
                : Text(message, textAlign: TextAlign.center, style: textStyle),
            const AppSpacer.medium(),
            if (controller.isWarning)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppButton.label(
                    label: controller.primaryActionLabel ?? l10n.ok,
                    onPressed: controller.primaryActionAndClear,
                    type: AppButtonType.primary,
                    backgroundColor: colorScheme?.primary,
                  ),
                  const SizedBox(height: AppSpacing.wisherSpacing),
                  AppButton.label(
                    label: controller.secondaryActionLabel ?? l10n.ok,
                    onPressed: controller.secondaryActionAndClear,
                    type: AppButtonType.secondary,
                    color: colorScheme?.error,
                  ),
                ],
              )
            else
              AppButton.label(
                label: l10n.ok,
                onPressed: controller.acknowledgeAndClear,
                type: AppButtonType.tertiary,
                color: messageColor,
                fontWeight: FontWeight.bold,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizedMessage({
    required String message,
    required String name,
    required TextStyle? textStyle,
  }) {
    final matchIndex = message.indexOf(name);
    if (name.isEmpty || matchIndex < 0) {
      return Text(message, textAlign: TextAlign.center, style: textStyle);
    }

    final prefix = message.substring(0, matchIndex);
    final suffix = message.substring(matchIndex + name.length);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textStyle,
        children: [
          if (prefix.isNotEmpty) TextSpan(text: prefix),
          TextSpan(
            text: name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (suffix.isNotEmpty) TextSpan(text: suffix),
        ],
      ),
    );
  }
}
