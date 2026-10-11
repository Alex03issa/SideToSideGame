import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart'; // Import gesture events
import 'package:flutter/animation.dart';

import '../../audio/sounds.dart';
import '../effects/hurt_effect.dart';
import '../endless_runner.dart';
import '../endless_world.dart';
import 'obstacle.dart';
import 'point.dart';

/// The [Player] is the component that the player controls by dragging.
class Player extends SpriteAnimationGroupComponent<PlayerState>
    with
        CollisionCallbacks,
        HasWorldReference<EndlessWorld>,
        HasGameReference<EndlessRunner>,
        DragCallbacks {
  Player({
    required this.addScore,
    required this.resetScore,
    super.position,
  }) : super(size: Vector2.all(150), anchor: Anchor.center, priority: 1);

  final void Function({int amount}) addScore;
  final VoidCallback resetScore;

  // Store the player's previous position.
  final Vector2 _lastPosition = Vector2.zero();

  @override
  Future<void> onLoad() async {
    // Define animations for different player states.
    animations = {
      PlayerState.running: await game.loadSpriteAnimation(
        'dash/dash_running.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2.all(16),
          stepTime: 0.15,
        ),
      ),
    };

    // Set the initial state to running.
    current = PlayerState.running;
    _lastPosition.setFrom(position);

    // Add a hitbox to the player.
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Keep the player inside the visible play area.
    _keepInsideVisibleArea();

    _lastPosition.setFrom(position); // Update the last position.
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Obstacle) {
      game.audioController.playSfx(SfxType.damage);
      resetScore();
      add(HurtEffect());
    } else if (other is Point) {
      game.audioController.playSfx(SfxType.score);
      other.removeFromParent();
      addScore();
    }
  }

  /// Handle drag updates to move the player.
  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    // Move the player by the distance the finger moved since the last update.
    // The event positions are in the player's own coordinate space (which
    // rotates while the hurt effect plays), so they are converted to the
    // world's coordinate space before the delta is applied.
    final worldDelta = localToParent(event.localEndPosition) -
        localToParent(event.localStartPosition);
    position.add(worldDelta);
    _keepInsideVisibleArea();
  }

  /// Clamps the player so that it is always fully inside the part of the world
  /// that the camera shows.
  ///
  /// The camera uses a fixed resolution and is centred on (0, 0), so the
  /// visible world goes from -width/2 to width/2 and from -height/2 to
  /// height/2. The player's anchor is its centre, so half of its size is
  /// subtracted on every side.
  void _keepInsideVisibleArea() {
    final visibleArea = game.camera.visibleWorldRect;
    position.clamp(
      Vector2(
        visibleArea.left + size.x / 2,
        visibleArea.top + size.y / 2,
      ),
      Vector2(
        visibleArea.right - size.x / 2,
        visibleArea.bottom - size.y / 2,
      ),
    );
  }
}

enum PlayerState {
  running,
}
