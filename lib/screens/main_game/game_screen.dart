import 'package:angry_mark/Levels/levels_data.dart';
import 'package:angry_mark/actors/enemy.dart';
import 'package:angry_mark/actors/player.dart';
import 'package:angry_mark/screens/main_game/level_display.dart';
import 'package:angry_mark/screens/main_game/models/game_state.dart';
import 'package:angry_mark/screens/main_game/scoreboard_component.dart';
import 'package:angry_mark/screens/main_game/slingshort.dart';
import 'package:angry_mark/world/ground.dart';
import 'package:angry_mark/world/obstacle.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class MyGame extends Forge2DGame with DragCallbacks {
  Player? player;
  Slingshot? slingshot;
  late ScoreboardComponent scoreboard;
  late GameState gameState;
  int currentLevelIndex = 0;
  late LevelDisplayComponent levelDisplay;
  late double groundLevel;

  MyGame(BuildContext context) {
    gameState = GameState(context, this);
    world.gravity = Vector2(0, 9.8);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    loadLevel(currentLevelIndex);
  }

  final double speedFactor = 1.0;

  @override
  void update(double dt) {
    super.update(dt * speedFactor);
  }

  Future<void> loadLevel(int levelIndex) async {
    if (levelIndex < 0 || levelIndex >= levels.length) {
      // Handle invalid level index
      return;
    }

    final levelData = levels[levelIndex];

    camera.viewport = MaxViewport();

    add(
      SpriteComponent(
        sprite: await loadSprite('game-background.jpeg'),
        size: size,
      ),
    );
    final ground = Ground(size);
    add(ground);

    // Wait until ground is fully loaded to get the correct ground level
    await ground.onLoad();
    final initialGroundLevel = ground.groundLevel.toStringAsFixed(2);
    groundLevel = double.parse(initialGroundLevel);

    player = Player(gameState);
    add(player!);

    final scoreText = TextComponent(
      text: 'Score: 0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    scoreboard = ScoreboardComponent(scoreText: scoreText);
    add(scoreboard);

    final screenSize = size;
    scoreboard.position = Vector2(screenSize.x - scoreboard.size.x - 100, 10);

    // Add Level Display
    levelDisplay = LevelDisplayComponent(level: currentLevelIndex + 1);
    add(levelDisplay);

    levelDisplay.position =
        Vector2(screenSize.x - (screenSize.x - levelDisplay.size.x) + 100, 10);

    // Add obstacles
    for (final position in levelData.obstaclePositions) {
      // Position obstacles relative to the ground
      final obstaclePosition = Vector2(position.x, groundLevel - position.y);
      await addObstacle(obstaclePosition, 'crate.png');
    }

    // Add enemies
    for (int i = 0; i < levelData.enemyCount; i++) {
      final position = levelData.enemyPositions[i];
      final enemyPosition = Vector2(position.x, groundLevel - position.y);
      await addEnemy(enemyPosition, 'characters/2.png', scoreboard);
    }

    slingshot = Slingshot(this);
    add(slingshot!);

    slingshot!.position = Vector2(player!.position.x, player!.position.y);
  }

  void restartLevel() {
    player!.hasPlayerBeenDragged = false;
    // Clear existing components
    for (final component in children.toList()) {
      remove(component);
    }
    loadLevel(currentLevelIndex);
  }

  void nextLevel() {
    if (currentLevelIndex < levels.length - 1) {
      currentLevelIndex++;
      loadLevel(currentLevelIndex);
    } else {
      // Handle case when there are no more levels
    }
  }

  Future<void> addObstacle(Vector2 position, String spritePath) async {
    final obstacle = Obstacle(position, await loadSprite(spritePath));
    add(obstacle);
  }

  Future<void> addEnemy(Vector2 position, String spritePath,
      ScoreboardComponent scoreboard) async {
    final enemy =
        Enemy(position, await loadSprite(spritePath), scoreboard, gameState);
    gameState.addEnemy(enemy);
    add(enemy);
  }

  // Example method to update the score
  void incrementScore(int amount) {
    scoreboard.increaseScore(amount);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    // print('draging');
    player?.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    player?.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    player?.onDragEnd(event);
  }
}
