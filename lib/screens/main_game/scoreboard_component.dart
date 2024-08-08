import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreboardComponent extends PositionComponent {
  final TextComponent scoreText;
  int _score = 0;

  ScoreboardComponent({required this.scoreText}) {
    // Initialize the position of the scoreboard component
    position = Vector2(200, 100); // Placeholder, update position in game class
    size = scoreText.size;
  }

  @override
  void render(Canvas canvas) {
    scoreText.render(canvas);
  }

  @override
  void update(double dt) {
    // Update score text with the current score
    scoreText.text = 'Score: $_score';
    scoreText.update(dt);
  }

  void increaseScore(int amount) {
    _score += amount;
  }
}
