import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
// import 'package:flutter/material.dart';

class MyGame extends Forge2DGame with PanDetector {
  late SpriteComponent characterSpriteComponent;
  late SpriteComponent obstacle1SpriteComponent;
  late SpriteComponent obstacle2SpriteComponent;
  late Body characterBody;
  late Body obstacle1Body;
  late Body obstacle2Body;
  bool isLaunched = false;
  Vector2? dragStart;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final characterSprite = await loadSprite('angry-7.gif');
    final obstacleSprite = await loadSprite('angry-mark.gif');

    // Create and add the character sprite
    characterSpriteComponent = SpriteComponent()
      ..sprite = characterSprite
      ..size = Vector2(50.0, 50.0) // Adjust size
      ..position = Vector2(100.0, 300.0);
    add(characterSpriteComponent);

    // Create and add obstacles
    obstacle1SpriteComponent = SpriteComponent()
      ..sprite = obstacleSprite
      ..size = Vector2(50.0, 50.0) // Adjust size
      ..position = Vector2(250.0, 300.0);
    add(obstacle1SpriteComponent);

    obstacle2SpriteComponent = SpriteComponent()
      ..sprite = obstacleSprite
      ..size = Vector2(50.0, 50.0) // Adjust size
      ..position = Vector2(350.0, 300.0);
    add(obstacle2SpriteComponent);

    _setupPhysics();
  }

  void _setupPhysics() {
    final characterBodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = Vector2(100.0, 300.0);
    final characterFixtureDef = FixtureDef(CircleShape()..radius = 25.0)
      ..density = 1.0
      ..friction = 0.3
      ..restitution = 0.5;

    characterBody = world.createBody(characterBodyDef)
      ..createFixture(characterFixtureDef)
      ..userData = characterSpriteComponent;

    final obstacle1BodyDef = BodyDef()
      ..type = BodyType.static
      ..position = Vector2(250.0, 300.0);
    final obstacle1FixtureDef = FixtureDef(
      PolygonShape()
        ..setAsBox(
          25.0, // half-width
          25.0, // half-height
          Vector2.zero(), // center of the box
          0.0, // angle of rotation
        ),
    )
      ..density = 1.0
      ..friction = 0.3
      ..restitution = 0.5;

    obstacle1Body = world.createBody(obstacle1BodyDef)
      ..createFixture(obstacle1FixtureDef)
      ..userData = obstacle1SpriteComponent;

    final obstacle2BodyDef = BodyDef()
      ..type = BodyType.static
      ..position = Vector2(350.0, 300.0);
    final obstacle2FixtureDef = FixtureDef(
      PolygonShape()
        ..setAsBox(
          25.0, // half-width
          25.0, // half-height
          Vector2.zero(), // center of the box
          0.0, // angle of rotation
        ),
    )
      ..density = 1.0
      ..friction = 0.3
      ..restitution = 0.5;

    obstacle2Body = world.createBody(obstacle2BodyDef)
      ..createFixture(obstacle2FixtureDef)
      ..userData = obstacle2SpriteComponent;
  }

  @override
  void onPanStart(DragStartInfo info) {
    super.onPanStart(info);
    dragStart =
        Vector2(info.eventPosition.global.x, info.eventPosition.global.y);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    if (!isLaunched && dragStart != null) {
      final dragVector =
          Vector2(info.eventPosition.global.x, info.eventPosition.global.y) -
              dragStart!;
      final force = dragVector * -10.0; // Adjust strength as needed
      characterBody.applyLinearImpulse(force,
          point: characterBody.position, wake: true);
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    super.onPanEnd(info);
    isLaunched = true;
    dragStart = null;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update game logic and check for collisions
    if (isLaunched) {
      final characterPosition = characterBody.position;
      if (obstacle1Body.position.distanceTo(characterPosition) < 50.0 ||
          obstacle2Body.position.distanceTo(characterPosition) < 50.0) {
        // Handle obstacle destruction logic
      }
    }
  }
}
