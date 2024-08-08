import 'package:angry_mark/actors/player.dart';
import 'package:angry_mark/notifiers/sound_notifier.dart';
import 'package:angry_mark/screens/main_game/scoreboard_component.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Enemy extends BodyComponent with ContactCallbacks {
  @override
  final Vector2 position;
  final Sprite sprite;
  late Sprite cloudSprite;
  final ScoreboardComponent scoreboard;
  Enemy(this.position, this.sprite, this.scoreboard);
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
    cloudSprite = await game.loadSprite('cloud.webp');
    // Preload the sound effect
    await FlameAudio.audioCache.load('sfx/wood_collision.mp3');
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 20;
    final FixtureDef fixtureDef = FixtureDef(shape, friction: 0.3);
    final BodyDef bodyDef = BodyDef(
        userData: this,
        position: position,
        type: BodyType.dynamic); // Dynamic body
    final body = world.createBody(bodyDef)..createFixture(fixtureDef);

    // Set the body's position and velocity to ensure it starts in place
    body.position.setFrom(position);
    body.linearVelocity = Vector2.zero(); // Stop any initial movement

    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    final appVolume = SoundNotifer.instance.value;
    if (other is Player) {
      // Play the sound effect
      FlameAudio.play('sfx/wood_collision.mp3', volume: appVolume);
      add(
        SpriteComponent()
          ..sprite = cloudSprite
          ..anchor = Anchor.center
          ..size = Vector2.all(40),
      );
      scoreboard.increaseScore(10);
      Future.delayed(
        const Duration(milliseconds: 1100),
        removeFromParent,
      );
    }
  }
}
