import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:angry_mark/screens/main_game/game_screen.dart';

class Slingshot extends PositionComponent with DragCallbacks {
  final FlameGame game;
  late Vector2 _dragStart;
  late Vector2 _dragEnd;
  late SpriteComponent _slingshotSprite;
  late Sprite _sprite;

  Slingshot(this.game);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _sprite = await Sprite.load('slingshot.webp');
    _slingshotSprite = SpriteComponent(sprite: _sprite)
      ..size = Vector2(50, 50) // Adjust to your slingshot sprite size
      ..anchor = Anchor.center;

    add(_slingshotSprite);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _dragStart = _screenToWorld(event.canvasPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    // ignore: deprecated_member_use
    _dragEnd = _screenToWorld(event.canvasPosition);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    final Vector2 dragVector = _dragStart - _dragEnd;
    final double dragStrength = dragVector.length;
    final Vector2 impulse = dragVector.normalized() * dragStrength * 1000;

    final player = (game as MyGame).player;
    player?.applyImpulse(impulse);

    _dragStart = Vector2.zero();
    _dragEnd = Vector2.zero();
  }

  Vector2 _screenToWorld(Vector2 screenPosition) {
    final camera = (game as MyGame).camera;
    final viewport = camera.viewport;
    final viewportSize = viewport.size;

    final worldX = (screenPosition.x / viewportSize.x) * viewport.size.x;
    final worldY = (screenPosition.y / viewportSize.y) * viewport.size.y;

    return Vector2(worldX, worldY);
  }
}
