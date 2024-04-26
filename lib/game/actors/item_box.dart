import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:ski_master/game/actors/player.dart';
import 'package:ski_master/game/game.dart';

class ItemBox extends PositionComponent
    with CollisionCallbacks, HasGameReference<SkiMasterGame> {
  ItemBox({super.position, this.onCollected});

  late final SpriteAnimationComponent _body;
  final VoidCallback? onCollected;

  @override
  FutureOr<void> onLoad() async {
    final animation = await game.loadSpriteAnimation(
      'GiftAnim.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(16, 16),
      ),
    );
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
      _collect();
    }
  }

  void _collect() {
    if (game.sfxValueNotifier.value) {
      FlameAudio.play(SkiMasterGame.itemBox);
    }
    addAll([
      OpacityEffect.fadeOut(
        LinearEffectController(0.4),
        target: _body,
        onComplete: removeFromParent,
      ),
      ScaleEffect.by(
        Vector2.all(1.2),
        LinearEffectController(0.4),
      ),
    ]);

    onCollected?.call();
  }
}
