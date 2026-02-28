import 'package:flutter/material.dart';
import 'package:wishing_well/components/image_picker_overlay/image_picker_overlay_constants.dart';
import 'package:wishing_well/theme/app_theme.dart';

/// An elegant overlay with a pulsing icon shown while the image picker opens.
/// Provides visual feedback without using a traditional spinner.
class ImagePickerOverlay extends StatefulWidget {
  const ImagePickerOverlay({required this.message, super.key});

  /// Message to display below the icon
  final String message;

  @override
  State<ImagePickerOverlay> createState() => _ImagePickerOverlayState();
}

class _ImagePickerOverlayState extends State<ImagePickerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: ImagePickerOverlayAnimation.pulseDuration,
    );

    // Fade in over 200ms to cross-fade with bottom sheet dismiss
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          ImagePickerOverlayAnimation.fadeInIntervalEnd,
          curve: Curves.easeOut,
        ),
      ),
    );

    // Then pulse continuously
    _pulseAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        ImagePickerOverlayAnimation.fadeInIntervalEnd,
        1.0,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _fadeInAnimation.value,
        child: Material(
          color: ImagePickerOverlayVisuals.backdropColor.withValues(
            alpha: ImagePickerOverlayVisuals.backdropOpacity,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale:
                      ImagePickerOverlayAnimation.iconScaleMin +
                      (_pulseAnimation.value *
                          ImagePickerOverlayAnimation.iconScaleRange),
                  child: Opacity(
                    opacity:
                        ImagePickerOverlayAnimation.iconOpacityMin +
                        (_pulseAnimation.value *
                            ImagePickerOverlayAnimation.iconOpacityRange),
                    child: Container(
                      width: ImagePickerOverlaySize.iconContainer,
                      height: ImagePickerOverlaySize.iconContainer,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceGray?.withValues(
                          alpha: ImagePickerOverlayVisuals.containerOpacity,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        ImagePickerOverlayIcon.icon,
                        size: ImagePickerOverlaySize.icon,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: ImagePickerOverlayVisuals.textSpacing),
                Text(
                  widget.message,
                  style: TextStyle(
                    color: colorScheme.onPrimary?.withValues(
                      alpha: ImagePickerOverlayVisuals.textOpacity,
                    ),
                    fontSize: ImagePickerOverlayVisuals.textSize,
                    fontWeight: ImagePickerOverlayVisuals.textWeight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
