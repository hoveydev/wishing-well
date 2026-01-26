import 'package:flutter/material.dart';

/// A reusable widget that provides opacity-based touch feedback for any widget.
/// Ideal for custom tappable components needing consistent opacity animations.
class TouchFeedbackOpacity extends StatefulWidget {
  /// Creates a TouchFeedbackOpacity widget.
  const TouchFeedbackOpacity({
    required this.child,
    required this.onTap,
    this.pressedOpacity = 0.5,
    this.normalOpacity = 1.0,
    this.pressDuration = const Duration(milliseconds: 25),
    this.releaseDuration = const Duration(milliseconds: 100),
    super.key,
  });

  /// The child widget that will receive the opacity feedback.
  final Widget child;

  /// Callback when the widget is tapped.
  final VoidCallback? onTap;

  /// Opacity value when the widget is pressed.
  /// Defaults to 0.5 to match existing components.
  final double pressedOpacity;

  /// Opacity value when the widget is in normal state.
  /// Defaults to 1.0 (fully opaque).
  final double normalOpacity;

  /// Duration for the opacity animation when pressed.
  /// Defaults to 25ms to match existing components.
  final Duration pressDuration;

  /// Duration for the opacity animation when released.
  /// Defaults to 100ms to match existing components.
  final Duration releaseDuration;

  @override
  State<TouchFeedbackOpacity> createState() => _TouchFeedbackOpacityState();
}

class _TouchFeedbackOpacityState extends State<TouchFeedbackOpacity> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: widget.onTap != null
        ? (_) => setState(() => _isPressed = true)
        : null,
    onTapUp: widget.onTap != null
        ? (_) => setState(() => _isPressed = false)
        : null,
    onTapCancel: widget.onTap != null
        ? () => setState(() => _isPressed = false)
        : null,
    onTap: widget.onTap,
    child: AnimatedOpacity(
      opacity: _isPressed ? widget.pressedOpacity : widget.normalOpacity,
      duration: _isPressed ? widget.pressDuration : widget.releaseDuration,
      child: widget.child,
    ),
  );
}
