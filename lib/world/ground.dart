import 'package:flame_forge2d/flame_forge2d.dart';

class Ground extends BodyComponent {
  final Vector2 gameSize;
  late double groundLevel;

  Ground(this.gameSize) : super(renderBody: false);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    groundLevel = gameSize.y * .78;
  }

  @override
  Body createBody() {
    final Shape shape = EdgeShape()
      ..set(
        Vector2(0, gameSize.y * .78),
        Vector2(gameSize.x, gameSize.y * .78),
      );
    final BodyDef bodyDef = BodyDef(userData: this, position: Vector2.zero());
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
