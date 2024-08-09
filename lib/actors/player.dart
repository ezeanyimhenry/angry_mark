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
    final Shape shape = CircleShape()..radius = 20;
    final BodyDef bodyDef = BodyDef(
      userData: this,
      position: Vector2(100, 0),
      type: BodyType.dynamic,
    );
    final FixtureDef fixtureDef = FixtureDef(shape, friction: 0.5);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _dragStartPosition = body.position;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    // ignore: deprecated_member_use
    _dragEndPosition = screenToWorld(event.canvasPosition);
    if (_dragStartPosition != null && _dragEndPosition != null) {
      final Vector2 dragVector = Vector2.zero() - _dragEndPosition!;
      final double dragStrength = dragVector.length;
      final Vector2 impulse = dragVector.normalized() * dragStrength * 1000;

      trajectoryPoints.clear();
      trajectoryPoints.addAll(calculateTrajectory(body.position, impulse));
      trajectoryLine.points = trajectoryPoints;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_dragStartPosition != null && _dragEndPosition != null) {
      final Vector2 dragVector = _dragStartPosition! - _dragEndPosition!;
      final double dragStrength = dragVector.length;
      final Vector2 impulse = dragVector.normalized() * dragStrength * 1000;

      FlameAudio.play('sfx/launch.mp3', volume: 0.8);
      FlameAudio.bgm.stop();
      Future.delayed(
        const Duration(milliseconds: 100),
        () => FlameAudio.play('sfx/flying.mp3', volume: 0.8),
      );
      body.applyLinearImpulse(impulse, point: body.worldCenter);
      _dragStartPosition = null;
      _dragEndPosition = null;
      trajectoryPoints.clear();
      trajectoryPoints.addAll(calculateTrajectory(body.position, impulse));
      trajectoryLine.points = trajectoryPoints;
    }
  }

  Vector2 screenToWorld(Vector2 screenPosition) {
    final camera = game.camera;
    final viewportSize = game.size;

    final worldX = (screenPosition.x / viewportSize.x) * camera.viewport.size.x;
    final worldY = (screenPosition.y / viewportSize.y) * camera.viewport.size.y;

    return Vector2(worldX, worldY);
  }

  List<Vector2> calculateTrajectory(Vector2 startPosition, Vector2 impulse,
      {double friction = 0.5}) {
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
      // Apply friction
      velocity.x *= (1 - friction * timeStep);
      velocity.y *= (1 - friction * timeStep);
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

    if (body.position.y > game.size.y) {
      gameState.endLevel(checkWinCondition());
      removeFromParent();
    }

    if (_dragEndPosition != null && !gameState.hasEnemies) {
      gameState.endLevel(true);
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
