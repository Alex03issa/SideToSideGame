import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../endless_world.dart';

/// The [Point] components are the components that the [Player] should collect
/// to finish a level. The points are represented by Flame's mascot; Ember.
class Point extends SpriteAnimationComponent
    with HasGameReference, HasWorldReference<EndlessWorld> {
  Point() : super(size: spriteSize, anchor: Anchor.center);

  static final Vector2 spriteSize = Vector2.all(100);
  final speed = 200;

  @override
  Future<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'ember.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.15,
      ),
    );
    // Since the original Ember sprite is looking to the right we have to flip
    // it, so that it is facing the player instead.
    flipHorizontallyAroundCenter();

    // When adding a CircleHitbox without any arguments it automatically
    // fills up the size of the component as much as it can without overflowing
    // it.
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // The background scrolls downwards, so the embers fall down the screen
    // with the speed that we have set for the world plus the speed set for the
    // point, so that they move a bit faster than the obstacles.
    // `dt` here stands for delta time and it is the time, in seconds, since the
    // last update ran. We need to multiply the speed by `dt` to make sure that
    // the speed of the points are the same no matter the refresh rate/speed
    // of your device.
    position.y += (world.speed + speed) * dt;

    // When the component is no longer visible on the screen anymore, we
    // remove it.
    // The position is the centre of the component (the anchor) and the center
    // of the world is in (0, 0), so when the top edge of the component
    // (position.y - size.y / 2) is below half the world height we know that it
    // is no longer visible and it can be removed.
    if (position.y - size.y / 2 > world.size.y / 2) {
      removeFromParent();
    }
  }
}
