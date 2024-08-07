import 'package:angry_mark/actors/enemy.dart';
import 'package:angry_mark/actors/player.dart';
import 'package:angry_mark/screens/main_game/scoreboard_component.dart';
import 'package:angry_mark/world/ground.dart';
import 'package:angry_mark/world/obstacle.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class MyGame extends Forge2DGame with DragCallbacks {
  Player? player;
  late ScoreboardComponent scoreboard;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // camera.viewport = FixedResolutionViewport(resolution: Vector2(1400, 400));
    camera.viewport = MaxViewport();

    add(
      SpriteComponent(
          sprite: await loadSprite('game-background.jpeg'), size: size),
    );
    add(Ground(size));
    player = Player();
    add(player!);

    // Create and add the scoreboard
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

    // Position the scoreboard at the top-right corner
    final screenSize = size;
    scoreboard.position = Vector2(screenSize.x - scoreboard.size.x - 550, 10);

    await addEnemy(Vector2(600, 100), 'pig.webp', scoreboard);
    await addObstacle(Vector2(600, 160), 'crate.png');
    await addObstacle(Vector2(600, 172), 'crate.png');
    await addObstacle(Vector2(600, 184), 'crate.png');
    await addObstacle(Vector2(600, 196), 'crate.png');
    await addObstacle(Vector2(600, 208), 'crate.png');
    await addObstacle(Vector2(600, 208), 'crate.png');
    await addObstacle(Vector2(600, 220), 'crate.png');
    await addObstacle(Vector2(600, 220), 'crate.png');
    await addObstacle(Vector2(600, 220), 'crate.png');
  }

  Future<void> addObstacle(Vector2 position, String spritePath) async {
    final obstacle = Obstacle(position, await loadSprite(spritePath));
    add(obstacle);
  }

  Future<void> addEnemy(Vector2 position, String spritePath,
      ScoreboardComponent scoreboard) async {
    final enemy = Enemy(position, await loadSprite(spritePath), scoreboard);
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
