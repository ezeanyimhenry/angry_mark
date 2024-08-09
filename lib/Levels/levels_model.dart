import 'package:flame/game.dart';

class LevelData {
  final int enemyCount;
  final List<Vector2> enemyPositions; // Positions of enemies
  final List<Vector2> obstaclePositions; // Positions of obstacles

  LevelData({
    required this.enemyCount,
    required this.enemyPositions,
    required this.obstaclePositions,
  });
}
