import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:wishing_well/components/throbber/app_throbber_size.dart';
import 'package:wishing_well/theme/app_theme.dart';

class AppThrobber extends StatefulWidget {
  const AppThrobber.xsmall({super.key}) : size = AppThrobberSize.xsmall;
  const AppThrobber.small({super.key}) : size = AppThrobberSize.small;
  const AppThrobber.medium({super.key}) : size = AppThrobberSize.medium;
  const AppThrobber.large({super.key}) : size = AppThrobberSize.large;
  const AppThrobber.xlarge({super.key}) : size = AppThrobberSize.xlarge;
  final double size;

  @override
  State<AppThrobber> createState() => _AppThrobberState();
}

class _AppThrobberState extends State<AppThrobber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => CustomPaint(
          painter: _CustomSpinnerPainter(
            progress: _controller.value,
            color: colorScheme.primary!,
          ),
        ),
      ),
    );
  }
}

class _CustomSpinnerPainter extends CustomPainter {
  const _CustomSpinnerPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = radius * 0.15;

    final backgroundPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    final headAngle = 2 * math.pi * progress;
    final tailAngle =
        headAngle -
        (math.sin(progress * math.pi) * math.pi * 0.5 + math.pi * 0.25);
    final sweepAngle = (headAngle - tailAngle + 2 * math.pi) % (2 * math.pi);

    final foregroundPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    canvas.drawArc(rect, tailAngle, sweepAngle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(_CustomSpinnerPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
