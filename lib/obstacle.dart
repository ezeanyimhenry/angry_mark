import 'package:flutter/material.dart';

class Obstacle {
  Rect rect;
  bool isDestroyed = false;
  final Paint paint;
  final bool isBreakable;

  Obstacle(this.rect, {this.isBreakable = true})
      : paint = Paint()
          ..color = Colors.brown
          ..style = PaintingStyle.fill;

  void draw(Canvas canvas) {
    if (isDestroyed) return;

    canvas.drawRect(rect, paint);

    if (isBreakable) {
      // Draw some breakable features, e.g., cracks or damage marks
      final damagePaint = Paint()
        ..color = Colors.black.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawLine(rect.topLeft, rect.bottomRight, damagePaint);
      canvas.drawLine(rect.topRight, rect.bottomLeft, damagePaint);
    }
  }

  void handleCollision(Offset point) {
    if (isBreakable && rect.contains(point)) {
      isDestroyed = true;
    }
  }
}
