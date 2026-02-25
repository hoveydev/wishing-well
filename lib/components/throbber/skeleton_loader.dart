import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_theme.dart';

enum SkeletonShape { circle, roundedRectangle }

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    required this.shape,
    this.width,
    this.height,
    this.borderRadius,
    super.key,
  });

  final SkeletonShape shape;
  final double? width;
  final double? height;
  final double? borderRadius;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final baseColor = colorScheme.primary!.withValues(alpha: 0.1);
    final highlightColor = colorScheme.primary!.withValues(alpha: 0.3);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          shape: widget.shape == SkeletonShape.circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius: widget.shape == SkeletonShape.roundedRectangle
              ? BorderRadius.circular(widget.borderRadius ?? 4)
              : null,
          gradient: LinearGradient(
            stops: [
              (_animation.value - 0.5).clamp(0.0, 1.0),
              _animation.value.clamp(0.0, 1.0),
              (_animation.value + 0.5).clamp(0.0, 1.0),
            ],
            colors: [baseColor, highlightColor, baseColor],
          ),
        ),
      ),
    );
  }
}
