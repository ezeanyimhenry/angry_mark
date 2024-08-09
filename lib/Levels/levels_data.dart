import 'package:angry_mark/Levels/levels_model.dart';
import 'package:flame/game.dart';

final List<LevelData> levels = [
  LevelData(
    enemyCount: 3,
    enemyPositions: [Vector2(600, 100), Vector2(700, 150), Vector2(800, 200)],
    obstaclePositions: [Vector2(600, 160), Vector2(600, 200)],
  ),
  LevelData(
    enemyCount: 5,
    enemyPositions: [
      Vector2(600, 100),
      Vector2(700, 150),
      Vector2(800, 200),
      Vector2(900, 250),
      Vector2(1000, 300)
    ],
    obstaclePositions: [
      Vector2(600, 160),
      Vector2(600, 200),
      Vector2(600, 240)
    ],
  ),
  // Add more levels as needed
];
