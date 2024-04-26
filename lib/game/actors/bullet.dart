import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ski_master/game/game.dart';
import 'package:ski_master/game/routes/gameplay.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameReference<SkiMasterGame>, HasAncestor<Gameplay> {
  Bullet({
    super.position,
  }) : super(
          size: Vector2(12, 25),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'BulletAnim.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(8, 16),
      ),
    );

    add(RectangleHitbox(size: size));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (ancestor.bulletSpawner.timer.isRunning()) {
      position.y += dt * 500;
      if (position.y > ancestor.player.y + 150) {
        removeFromParent();
      }
    } else {
      removeFromParent();
    }
  }
}
