import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DottedLineComponent extends PositionComponent {
  List<Vector2> points;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  DottedLineComponent({
    required this.points,
    this.color = Colors.red,
    this.strokeWidth = 2.0,
    this.dashLength = 5.0,
    this.gapLength = 5.0,
  });
  @override
  void render(Canvas canvas) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    for (int i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      final segmentLength = (end - start).length;
      final direction = (end - start).normalized();
      double distance = 0.0;
      while (distance < segmentLength) {
        final startPoint = start + direction * distance;
        final endPoint = startPoint + direction * dashLength;
        canvas.drawLine(
          Offset(startPoint.x, startPoint.y),
          Offset(endPoint.x, endPoint.y),
          paint,
        );
        distance += dashLength + gapLength;
      }
    }
  }
}
