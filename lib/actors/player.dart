import 'package:angry_mark/actors/path_component.dart';
import 'package:angry_mark/notifiers/sound_notifier.dart';
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

  final appVolume = SoundNotifer.instance.value;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Load and play background music
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('birds_intro.mp3', volume: appVolume);
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
    // _dragStartPosition = Vector2(0, 0);
    _dragStartPosition = screenToWorld(event.canvasPosition);
    // Initialize trajectory points with a basic forward direction
    if (_dragStartPosition != null) {
      trajectoryPoints.clear();
      trajectoryPoints
          .addAll(calculateTrajectory(_dragStartPosition!, Vector2.zero()));
      dottedLine.points = trajectoryPoints;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // ignore: deprecated_member_use
    _dragEndPosition = screenToWorld(event.canvasPosition);
    if (_dragStartPosition != null && _dragEndPosition != null) {
      final Vector2 dragVector = _dragStartPosition! - _dragEndPosition!;
      final double dragStrength = dragVector.length;
      final Vector2 impulse =
          dragVector.normalized() * dragStrength * 5000; // Adjusted impulse
      trajectoryPoints.clear();
      trajectoryPoints
          .addAll(calculateTrajectory(_dragStartPosition!, impulse));
      dottedLine.points = trajectoryPoints;

      // print('Trajectory Points: $trajectoryPoints'); // Debugging output
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_dragStartPosition != null && _dragEndPosition != null) {
      final Vector2 dragVector = _dragStartPosition! - _dragEndPosition!;
      final double dragStrength = dragVector.length;
      final Vector2 impulse = dragVector.normalized() * dragStrength * 5000;
      FlameAudio.play('sfx/launch.mp3', volume: appVolume);
      FlameAudio.bgm.stop();
      Future.delayed(
        const Duration(milliseconds: 100),
        () => FlameAudio.play('sfx/flying.mp3', volume: appVolume),
      );
      // print('Body Velocity Before: ${body.linearVelocity}');
      body.applyLinearImpulse(impulse);
      // print('Body Velocity After: ${body.linearVelocity}');
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
      // Apply friction
      velocity.x -= velocity.x * friction * timeStep;
      velocity.y -=
          (velocity.y * friction * timeStep) + (0.5 * _gravity * timeStep);
      // Calculate new position
      position += velocity * timeStep;
      position.y -= 0.5 * _gravity * timeStep * timeStep;
      points.add(position);

      // Stop if trajectory goes below the visible area
      if (position.y > game.size.y) break;
    }
    return points;
  }
}
