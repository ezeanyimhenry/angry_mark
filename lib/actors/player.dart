import 'package:angry_mark/actors/path_component.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Player extends BodyComponent with DragCallbacks {
  final List<Vector2> trajectoryPoints = [];
  Vector2? _dragStartPosition;
  Vector2? _dragEndPosition;
  final double _gravity = 9.8;
  late DottedLineComponent dottedLine;

  final Paint trajectoryPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Load and play background music
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
    dottedLine = DottedLineComponent(
      points: trajectoryPoints,
      color: Colors.red,
      strokeWidth: 2.0,
      dashLength: 5.0,
      gapLength: 5.0,
    );
    add(dottedLine);
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
    _dragStartPosition = screenToWorld(event.canvasPosition);
    if (_dragStartPosition != null) {
      final Vector2 dragVector = Vector2.zero();
      final double dragStrength = dragVector.length;
      final Vector2 impulse = dragVector.normalized() * dragStrength * 5000;
      trajectoryPoints.clear();
      trajectoryPoints.addAll(calculateTrajectory(position, impulse));
      dottedLine.points = trajectoryPoints;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // ignore: deprecated_member_use
    _dragEndPosition = screenToWorld(event.canvasPosition);
    if (_dragStartPosition != null && _dragEndPosition != null) {
      final Vector2 dragVector = position - _dragEndPosition!;
      final Vector2 dragVector2 = _dragStartPosition! - _dragEndPosition!;
      final double dragStrength = dragVector.length;
      final Vector2 impulse =
          dragVector.normalized() * dragStrength * 5000; // Adjusted impulse
      trajectoryPoints.clear();
      trajectoryPoints.addAll(calculateTrajectory(dragVector2, impulse));
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_dragStartPosition != null && _dragEndPosition != null) {
      final Vector2 dragVector = _dragStartPosition! - _dragEndPosition!;
      final double dragStrength = dragVector.length;
      final Vector2 impulse = dragVector.normalized() * dragStrength * 5000;
      FlameAudio.play('sfx/launch.mp3', volume: 0.8);
      FlameAudio.bgm.stop();
      Future.delayed(
        const Duration(milliseconds: 100),
        () => FlameAudio.play('sfx/flying.mp3', volume: 0.8),
      );
      body.applyLinearImpulse(impulse);
      _dragStartPosition = null;
      _dragEndPosition = null;
      trajectoryPoints.clear();
      dottedLine.points = trajectoryPoints;
    }
  }

  Vector2 screenToWorld(Vector2 screenPosition) {
    final camera = game.camera;
    final viewportSize = camera.viewport.size;
    final cameraPosition = camera.viewport.position;

    // Correct the coordinate transformation
    final worldX = (screenPosition.x / camera.viewfinder.zoom) +
        cameraPosition.x -
        (viewportSize.x / 2) / camera.viewfinder.zoom;
    final worldY = (screenPosition.y / camera.viewfinder.zoom) +
        cameraPosition.y -
        (viewportSize.y / 2) / camera.viewfinder.zoom;

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
      velocity.x -= velocity.x * friction * timeStep;
      velocity.y -=
          (velocity.y * friction * timeStep) + (0.5 * _gravity * timeStep);
      position += velocity * timeStep;
      position.y -= 0.5 * _gravity * timeStep * timeStep;
      points.add(position);

      // if (position.y > game.size.y) break; // Stop if trajectory goes below the visible area
    }
    return points;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (trajectoryPoints.isNotEmpty) {
      final path = Path();
      path.moveTo(trajectoryPoints.first.x, trajectoryPoints.first.y);
      for (var point in trajectoryPoints.skip(1)) {
        path.lineTo(point.x, point.y);
      }
      canvas.drawPath(path, trajectoryPaint);
    }
  }
}
