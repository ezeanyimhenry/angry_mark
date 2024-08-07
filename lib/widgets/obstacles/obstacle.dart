// import 'package:flutter/material.dart';

// class Obstacle {
//   Rect rect;
//   bool isDestroyed = false;
//   final Paint paint;
//   final bool isBreakable;

//   Obstacle(this.rect, {this.isBreakable = true})
//       : paint = Paint()
//           ..color = Colors.brown
//           ..style = PaintingStyle.fill;

//   void draw(Canvas canvas) {
//     if (isDestroyed) return;

//     canvas.drawRect(rect, paint);

//     if (isBreakable) {
//       // Draw some breakable features, e.g., cracks or damage marks
//       final damagePaint = Paint()
//         ..color = Colors.black.withOpacity(0.5)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2;

//       canvas.drawLine(rect.topLeft, rect.bottomRight, damagePaint);
//       canvas.drawLine(rect.topRight, rect.bottomLeft, damagePaint);
//     }
//   }

//   void handleCollision(Offset point) {
//     if (isBreakable && rect.contains(point)) {
//       isDestroyed = true;
//     }
//   }
// }


import 'package:flutter/material.dart';

enum ObstacleType { wood, stone, glass }

class Obstacle {
  Rect rect;
  bool isDestroyed = false;
  final Paint paint;
  final bool isBreakable;
  final ObstacleType type;
  int hitPoints;

  Obstacle(this.rect, {this.isBreakable = true, required this.type})
      : hitPoints = _initialHitPoints(type),
        paint = _initialPaint(type);

  static int _initialHitPoints(ObstacleType type) {
    switch (type) {
      case ObstacleType.wood:
        return 3;
      case ObstacleType.stone:
        return 5;
      case ObstacleType.glass:
        return 2;
      default:
        return 3;
    }
  }

  static Paint _initialPaint(ObstacleType type) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    switch (type) {
      case ObstacleType.wood:
        paint.color = Colors.brown;
        break;
      case ObstacleType.stone:
        paint.color = Colors.grey;
        break;
      case ObstacleType.glass:
        paint.color = Colors.lightBlueAccent.withOpacity(0.5);
        break;
    }
    return paint;
  }

  void draw(Canvas canvas) {
    if (isDestroyed) return;

    canvas.drawRect(rect, paint);

    if (isBreakable && hitPoints < _initialHitPoints(type)) {
      final damagePaint = Paint()
        ..color = Colors.black.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      // Draw damage lines
      final damageLines = _calculateDamageLines();
      for (var line in damageLines) {
        canvas.drawLine(line[0], line[1], damagePaint);
      }
    }
  }

  List<List<Offset>> _calculateDamageLines() {
    final lines = <List<Offset>>[];
    final damagePercentage = (1 - (hitPoints / _initialHitPoints(type)));
    final numLines = (4 * damagePercentage).round();

    for (int i = 0; i < numLines; i++) {
      lines.add([
        Offset(rect.left + (rect.width * i / numLines), rect.top),
        Offset(rect.right - (rect.width * i / numLines), rect.bottom),
      ]);
    }

    return lines;
  }

  void handleCollision(Offset point) {
    if (isBreakable && rect.contains(point)) {
      hitPoints--;
      if (hitPoints <= 0) {
        isDestroyed = true;
      }
    }
  }
}
