import 'package:angry_mark/Levels/levels_model.dart';
import 'package:flame/game.dart';

final List<LevelData> levels = [
  LevelData(
    enemyCount: 1,
    enemyPositions: [Vector2(600, 120)],
    obstaclePositions: [Vector2(600, 0), Vector2(600, 40), Vector2(600, 80)],
  ),
  LevelData(
    enemyCount: 3,
    enemyPositions: [Vector2(600, 80), Vector2(700, 40), Vector2(800, 40)],
    obstaclePositions: [Vector2(600, 0), Vector2(600, 40)],
  ),
  LevelData(
    enemyCount: 5,
    enemyPositions: [
      Vector2(500, 120),
      Vector2(600, 150),
      Vector2(600, 200),
      Vector2(700, 250),
      Vector2(800, 300)
    ],
    obstaclePositions: [Vector2(500, 0), Vector2(500, 40), Vector2(500, 80)],
  ),
  // Add more levels as needed
];
