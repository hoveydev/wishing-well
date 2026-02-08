import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_theme.dart';

/// A utility class that provides consistent touch feedback styles for buttons.
/// This centralizes the opacity animation logic and ensures consistency across
/// all button types (primary, secondary, tertiary).
class ButtonFeedbackStyle {
  /// Creates a button style for primary buttons with opacity feedback.
  /// The background color opacity changes from 1.0 to 0.5 when pressed.
  static ButtonStyle primary({
    required BuildContext context,
    Duration? pressDuration,
    Duration? releaseDuration,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    BorderSide? side,
    WidgetStateProperty<Color>? foregroundColor,
    WidgetStateProperty<Color>? backgroundColor,
  }) {
    final durations = _getDurations(pressDuration, releaseDuration);
    final colorScheme = context.colorScheme;

    return ButtonStyle(
      backgroundBuilder: (context, states, child) => AnimatedContainer(
        duration: states.contains(WidgetState.pressed)
            ? durations.press
            : durations.release,
        decoration: BoxDecoration(
          color: states.contains(WidgetState.pressed)
              ? (backgroundColor?.resolve(states) ??
                    colorScheme.primary!.withValues(alpha: 0.5))
              : (backgroundColor?.resolve(states) ??
                    colorScheme.primary!.withValues(alpha: 1)),
          borderRadius: borderRadius ?? BorderRadius.circular(14),
          border: side != null ? Border.fromBorderSide(side) : null,
        ),
        child: child,
      ),
      foregroundColor:
          foregroundColor ?? WidgetStatePropertyAll(colorScheme.onPrimary),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      padding: WidgetStateProperty.all(
        padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(14),
          side: side ?? BorderSide.none,
        ),
      ),
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  /// Creates a button style for secondary buttons with opacity feedback.
  /// The background opacity changes from transparent to 0.15 when pressed.
  static ButtonStyle secondary({
    required BuildContext context,
    Duration? pressDuration,
    Duration? releaseDuration,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    BorderSide? side,
    WidgetStateProperty<Color>? foregroundColor,
  }) {
    final durations = _getDurations(pressDuration, releaseDuration);
    final colorScheme = context.colorScheme;

    final WidgetStateProperty<BorderSide?> sideProperty = side != null
        ? WidgetStatePropertyAll<BorderSide>(side)
        : WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: colorScheme.primary!),
          );

    return ButtonStyle(
      backgroundBuilder: (context, states, child) => AnimatedContainer(
        duration: states.contains(WidgetState.pressed)
            ? durations.press
            : durations.release,
        decoration: BoxDecoration(
          color: states.contains(WidgetState.pressed)
              ? colorScheme.primary!.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: borderRadius ?? BorderRadius.circular(14),
          border: side != null ? Border.fromBorderSide(side) : null,
        ),
        child: child,
      ),
      foregroundColor:
          foregroundColor ?? WidgetStatePropertyAll(colorScheme.primary),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      padding: WidgetStateProperty.all(
        padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(14),
        ),
      ),
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      side: sideProperty,
    );
  }

  /// Creates a button style for tertiary buttons with opacity feedback.
  /// The background color opacity changes from transparent to 0.1 when pressed.
  static ButtonStyle tertiary({
    required BuildContext context,
    Duration? pressDuration,
    Duration? releaseDuration,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    BorderSide? side,
    WidgetStateProperty<Color>? foregroundColor,
    OutlinedBorder? shape,
  }) {
    final durations = _getDurations(pressDuration, releaseDuration);
    final colorScheme = context.colorScheme;

    return ButtonStyle(
      backgroundBuilder: (context, states, child) => AnimatedContainer(
        duration: states.contains(WidgetState.pressed)
            ? durations.press
            : durations.release,
        decoration: BoxDecoration(
          color: states.contains(WidgetState.pressed)
              ? colorScheme.primary!.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: borderRadius ?? BorderRadius.circular(14),
          border: side != null ? Border.fromBorderSide(side) : null,
        ),
        child: child,
      ),
      foregroundColor:
          foregroundColor ?? WidgetStatePropertyAll(colorScheme.primary),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      padding: WidgetStateProperty.all(
        padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      shape: WidgetStateProperty.all(
        shape ??
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(14),
              side: side ?? BorderSide.none,
            ),
      ),
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  /// Helper method to get consistent durations for animations.
  static ({Duration press, Duration release}) _getDurations(
    Duration? pressDuration,
    Duration? releaseDuration,
  ) => (
    press: pressDuration ?? const Duration(milliseconds: 25),
    release: releaseDuration ?? const Duration(milliseconds: 100),
  );
}
