import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ski_master/game/actors/player.dart';
import 'package:ski_master/game/game.dart';
import 'package:ski_master/game/routes/gameplay.dart';

class Avalanche extends PositionComponent
    with
        HasGameReference<SkiMasterGame>,
        HasAncestor<Gameplay>,
        HasTimeScale,
        CollisionCallbacks {
  Avalanche({super.position, super.priority});

  late final SpriteAnimationComponent _body;
  final _moveDirection = Vector2(0, 1);

  static const _maxSpeed = 90;

  @override
  FutureOr<void> onLoad() async {
    final animation = await game.loadSpriteAnimation(
        'BigAvalanch.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.2,
          textureSize: Vector2(960, 128),
        ));
    _body = SpriteAnimationComponent(
      animation: animation,
      anchor: Anchor.center,
    );
    await add(_body);
    await add(
      RectangleHitbox(
        size: _body.size,
        collisionType: CollisionType.passive,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) {
      _kill();
    }
  }

  void moveAvalanche(double dt) {
    position.addScaled(_moveDirection, _maxSpeed * dt);
  }

  void resetTo(Vector2 resetPosition) {
    position.y = resetPosition.y - _body.size.y * 3;
  }

  void _kill() {
    if (ancestor.player.hasShield) {
      ancestor.player.deactivateShield();
      ancestor.player.speed *= 5;
    } else {
      ancestor.resetPlayer();
    }
  }
}
