import 'package:angry_mark/actors/enemy.dart';
import 'package:angry_mark/actors/player.dart';
import 'package:angry_mark/notifiers/sound_notifier.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Obstacle extends BodyComponent with ContactCallbacks {
  @override
  final Vector2 position;
  final Sprite sprite;

  Obstacle(this.position, this.sprite);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    add(
      SpriteComponent()
        ..sprite = sprite
        ..anchor = Anchor.center
        ..size = Vector2.all(40),
    );
    // Preload the sound effect
    await FlameAudio.audioCache.load('sfx/wood_collision.mp3');
  }

  @override
  Body createBody() {
    final shape = PolygonShape();
    final vertices = [
      Vector2(-20, -20),
      Vector2(20, -20),
      Vector2(20, 20),
      Vector2(-20, 20),
    ];
    shape.set(vertices);
    final FixtureDef fixtureDef = FixtureDef(shape, friction: 0.3);
    final BodyDef bodyDef =
        BodyDef(userData: this, position: position, type: BodyType.dynamic);
    final body = world.createBody(bodyDef)..createFixture(fixtureDef);

    // Set the body's position and velocity to ensure it starts in place
    body.position.setFrom(position);
    body.linearVelocity = Vector2.zero(); // Stop any initial movement

    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    final appVolume = SoundNotifer.instance.value;
    if (other is Player || other is Enemy) {
      // Play the sound effect
      FlameAudio.play('sfx/wood_collision.mp3', volume: appVolume);
    }
  }
}
