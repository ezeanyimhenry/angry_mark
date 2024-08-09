import 'package:angry_mark/screens/main_game/models/game_state.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Player extends BodyComponent with DragCallbacks {
  GameState gameState;

  Player(this.gameState);

  final List<Vector2> trajectoryPoints = [];
  Vector2? _dragStartPosition;
  Vector2? _dragEndPosition;
  final double _gravity = 9.8;
  late TrajectoryLineComponent trajectoryLine;
  bool hasPlayerBeenDragged = false;
  final double playerRadius = 20.0;

  Vector2 velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('birds_intro.mp3', volume: 0.5);
    Future.delayed(const Duration(seconds: 10), FlameAudio.bgm.stop);
    renderBody = false;
    add(
      SpriteComponent()
        ..sprite = await game.loadSprite('char1.png')
        ..flipHorizontally()
        ..size = Vector2.all(40)
        ..anchor = Anchor.center,
    );
    trajectoryLine = TrajectoryLineComponent(
      points: trajectoryPoints,
      color: Colors.red,
      strokeWidth: 2.0,
    );
    add(trajectoryLine);
  }

  @override
  Body createBody() {
    final double groundLevel = game.size.y * 0.78;

    final Shape shape = CircleShape()..radius = playerRadius;
    final BodyDef bodyDef = BodyDef(
      userData: this,
      position: Vector2(100, groundLevel - playerRadius),
      type: BodyType.dynamic,
    );

    final FixtureDef fixtureDef = FixtureDef(
      shape,
      density: 1.0,
      friction: 0.5,
      restitution: 0.5,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (!hasPlayerBeenDragged) {
      _dragStartPosition = body.position;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!hasPlayerBeenDragged) {
      // ignore: deprecated_member_use
      _dragEndPosition = screenToWorld(event.canvasPosition);
      if (_dragStartPosition != null && _dragEndPosition != null) {
        // Calculate the drag vector
        final Vector2 dragVector = _dragEndPosition! - _dragStartPosition!;
        final double dragStrength = dragVector.length;

        // Ensure the impulse calculation is correct
        final Vector2 impulse = -dragVector.normalized() * dragStrength * 10000;

        trajectoryPoints.clear();
        trajectoryPoints
            .addAll(calculateTrajectory(_dragStartPosition!, impulse));
        trajectoryLine.points = trajectoryPoints;
      }
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!hasPlayerBeenDragged &&
        _dragStartPosition != null &&
        _dragEndPosition != null) {
      // Calculate the drag vector
      final Vector2 dragVector = _dragEndPosition! - _dragStartPosition!;
      final double dragStrength = dragVector.length;

      final Vector2 impulse = -dragVector.normalized() * dragStrength * 10000;

      trajectoryPoints.clear();
      trajectoryPoints.addAll(calculateTrajectory(body.position, impulse));
      trajectoryLine.points = trajectoryPoints;

      FlameAudio.play('sfx/launch.mp3', volume: 0.8);
      FlameAudio.bgm.stop();
      Future.delayed(
        const Duration(milliseconds: 100),
        () => FlameAudio.play('sfx/flying.mp3', volume: 0.8),
      );

      body.applyLinearImpulse(impulse, point: body.worldCenter);
      _dragStartPosition = null;
      _dragEndPosition = null;

      hasPlayerBeenDragged = true;
    }
  }

  Vector2 screenToWorld(Vector2 screenPosition) {
    final camera = game.camera;
    final viewportSize = game.size;

    final worldX = (screenPosition.x / viewportSize.x) * camera.viewport.size.x;
    final worldY = (screenPosition.y / viewportSize.y) * camera.viewport.size.y;

    return Vector2(worldX, worldY);
  }

  void applyImpulse(Vector2 impulse) {
    body.applyLinearImpulse(impulse, point: body.worldCenter);
  }

  List<Vector2> calculateTrajectory(
    Vector2 startPosition,
    Vector2 impulse,
  ) {
    List<Vector2> points = [];
    const double timeStep = 0.1;
    const double maxTime = 3.0;
    double time = 0.0;
    Vector2 velocity = impulse;
    Vector2 position = startPosition;

    while (time < maxTime) {
      time += timeStep;
      // Apply gravity
      velocity.y -= _gravity * timeStep;
      // Update position
      position += velocity * timeStep;
      points.add(position);
      if (position.y > game.size.y) {
        break;
      }
    }
    return points;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // print("Dragged: $hasPlayerBeenDragged");
    final groundLevel = (game.size.y * .78).toStringAsFixed(2);
    final approximatePosition =
        (body.position.y + playerRadius).toStringAsFixed(2);
    double approximatePositionDouble = double.parse(approximatePosition);
    double groundLevelDouble = double.parse(groundLevel);

    // Check if player touches the ground
    if (hasPlayerBeenDragged &&
        (approximatePositionDouble == groundLevelDouble)) {
      gameState.endLevel(checkWinCondition());
      removeFromParent();
    }
  }

  bool checkWinCondition() {
    return !gameState.hasEnemies;
  }
}

class TrajectoryLineComponent extends Component {
  List<Vector2> points;
  final Color color;
  final double strokeWidth;

  TrajectoryLineComponent({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.x, points.first.y);
      for (var point in points.skip(1)) {
        path.lineTo(point.x, point.y);
      }
      canvas.drawPath(path, paint);
    }
  }
}
