import 'package:flutter/material.dart';

class DottedBorder extends ShapeBorder {
  const DottedBorder({
    required this.borderRadius,
    required this.color,
    this.width = 1.0,
    this.dotLength = 4.0,
    this.dotSpacing = 4.0,
  });

  final BorderRadius borderRadius;
  final Color color;
  final double width;
  final double dotLength;
  final double dotSpacing;

  // coverage:ignore-start
  @override
  // ShapeBorder methods are called by Flutter's rendering system
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..addRRect(
      borderRadius.resolve(textDirection).toRRect(rect).deflate(width),
    );

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final rrect = borderRadius.resolve(textDirection).toRRect(rect);
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final path = Path()..addRRect(rrect);
    final pathMetric = path.computeMetrics().first;
    final length = pathMetric.length;

    double currentDistance = 0.0;
    while (currentDistance < length) {
      final endDistance = currentDistance + dotLength;
      if (endDistance > length) break;

      canvas.drawPath(
        pathMetric.extractPath(currentDistance, endDistance),
        paint,
      );

      currentDistance = endDistance + dotSpacing;
    }
  }

  @override
  ShapeBorder scale(double t) => DottedBorder(
    borderRadius: borderRadius * t,
    color: color,
    width: width * t,
    dotLength: dotLength * t,
    dotSpacing: dotSpacing * t,
  );
  // coverage:ignore-end
}
