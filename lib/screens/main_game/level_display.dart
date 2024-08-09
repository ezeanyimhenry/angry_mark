import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/text.dart';

class LevelDisplayComponent extends PositionComponent {
  final TextComponent levelText;
  final double leftPadding; // Add padding property

  LevelDisplayComponent({required int level, this.leftPadding = 10.0})
      : levelText = TextComponent(
          text: 'Level: $level',
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ) {
    add(levelText);
  }

  void onResize(Vector2 size) {
    // Positioning at the top-left corner with left padding
    levelText.position = Vector2(leftPadding, 10);
  }
}
