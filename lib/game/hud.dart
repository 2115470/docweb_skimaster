import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Viewport;

import 'actors/player.dart';

class Hud extends PositionComponent with ParentIsA<Viewport>, HasGameReference {
  Hud({
    required Sprite playerSprite,
    required Sprite snowmanSprite,
    required this.player,
    this.onPausePressed,
  }) : _playerHudSprite = SpriteComponent(
          sprite: playerSprite,
          anchor: Anchor.center,
        );

  //HudInfo
  final SpriteComponent _playerHudSprite;
  late final PositionComponent itemSlotContainer;
  final _life = TextComponent(
    text: 'x3',
    anchor: Anchor.centerLeft,
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 10,
      ),
    ),
  );

  //Timer
  late Timer intervalCountdown;
  int elapsedSecs = 3;
  late Timer goDisplayTimer;

  //Controlls
  late final JoystickComponent? _joystick;
  late final HudButtonComponent skillButton;
  final VoidCallback? onPausePressed;

  //Getters
  final Player player;
  Map<String, Sprite> itemSpriteCache = {};
  SpriteComponent? currentSpriteComponent;
  late String currentSkillName;

  @override
  Future<void> onLoad() async {
    //Setup for the Timer
    goDisplayTimer = Timer(0.5, repeat: false);
    intervalCountdown = Timer(
      1,
      onTick: () => elapsedSecs--,
      repeat: true,
    );

    _playerHudSprite.position.setValues(
      16,
      15,
    );

    _life.position.setValues(
      _playerHudSprite.position.x + 8,
      _playerHudSprite.position.y,
    );

    //adding them as child of hud
    await addAll([
      _playerHudSprite,
      _life,
    ]);

    //Adding items to the item list
    itemSpriteCache['Shield'] = await Sprite.load('Shield.png');
    itemSpriteCache['Speed'] = await Sprite.load('Can.png');
    itemSpriteCache['Bullet'] = await Sprite.load('Bullet.png');

    await _setupItemSlot();
    await _setupControlls();
  }

  Future<void> _setupItemSlot() async {
    // Create a container component to hold both the fill and stroke components
    itemSlotContainer = PositionComponent(
      size: Vector2(30, 30),
      anchor: Anchor.topRight,
      position: Vector2(parent.virtualSize.x - 10, 10),
    );

    final itemSlotFill = RectangleComponent(
      size: Vector2(30, 30),
      paint: Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill,
      priority: 0,
    );
    itemSlotContainer.add(itemSlotFill);

    final itemSlotBorder = RectangleComponent(
      size: Vector2(30, 30),
      paint: Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
      priority: 1,
    );
    itemSlotContainer.add(itemSlotBorder);

    await add(itemSlotContainer);
  }

  void addItemToSlot(String itemName) {
    if (itemSpriteCache.containsKey(itemName) &&
        currentSpriteComponent == null) {
      // Create and add the new sprite component
      final sprite = itemSpriteCache[itemName];
      currentSpriteComponent = SpriteComponent(
        sprite: sprite,
        size: Vector2.all(16),
      );

      // Position the new sprite in the center of the item slot
      currentSpriteComponent?.position = itemSlotContainer.size / 2;
      currentSpriteComponent?.anchor = Anchor.center;
      currentSkillName = itemName;

      itemSlotContainer.add(currentSpriteComponent!);
    }
  }

  void consumeItem() {
    // Remove the current sprite component if it exists
    currentSpriteComponent?.removeFromParent();
    currentSpriteComponent = null;
    currentSkillName = '';
  }

  Future<void> _setupControlls() async {
    _joystick = JoystickComponent(
      anchor: Anchor.center,
      position: parent.virtualSize * 0.2,
      knob: CircleComponent(
        radius: 15,
        paint: Paint()..color = Colors.green.withOpacity(0.5),
      ),
      background: CircleComponent(
        radius: 30,
        paint: Paint()
          ..color = Colors.black.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      ),
    );

    _joystick?.position.y = parent.virtualSize.y - _joystick.knobRadius * 1.5;
    await _joystick?.addToParent(this);

    skillButton = HudButtonComponent(
      anchor: Anchor.bottomRight,
      position: Vector2(
        parent.virtualSize.x * 0.95,
        parent.virtualSize.y * 0.85,
      ),
      button: CircleComponent(
        radius: 18,
        paint: Paint()..color = Colors.black.withOpacity(0.2),
      ),
      buttonDown: CircleComponent(
        radius: 18,
        paint: Paint()..color = Colors.black,
      ),
      onPressed: () {
        player.useSkill(currentSkillName);
      },
    );
    await skillButton.addToParent(this);

    final pauseButton = HudButtonComponent(
      anchor: Anchor.bottomLeft,
      position: Vector2(0, parent.virtualSize.y),
      button: SpriteComponent.fromImage(
        await game.images.load('pause.png'),
        size: Vector2.all(12),
      ),
      onPressed: onPausePressed,
    );
    await add(pauseButton);
  }

  @override
  void update(double dt) {
    intervalCountdown.update(dt);
    if (player.active) {
      player.joystickHaxis = lerpDouble(
        player.joystickHaxis,
        _joystick!.isDragged ? _joystick.relativeDelta.x * player.maxHAxis : 0,
        player.sensitivity * dt,
      )!;
    }
  }

  void updateLifeCount(int count) {
    _life.text = 'x$count';

    _playerHudSprite.add(
      RotateEffect.by(
        pi / 8,
        RepeatedEffectController(ZigzagEffectController(period: 0.2), 2),
      ),
    );

    _life.add(
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(
          duration: 0.1,
          alternate: true,
        ),
      ),
    );
  }

  //Count down
  @override
  void render(Canvas canvas) {
    if (intervalCountdown.isRunning() || goDisplayTimer.isRunning()) {
      //TextPaint for the Timer border (stroke)
      final TextPaint counterStrokeTextPaint = TextPaint(
        style: TextStyle(
          fontSize: 48.0,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..color = Colors.black,
        ),
      );

      //TextPaint for the Timer main text
      final TextPaint counterTextPaint = TextPaint(
        style: const TextStyle(
          fontSize: 48.0,
          color: Colors.white,
        ),
      );
      final String displayText =
          elapsedSecs <= 0 ? 'GO!' : elapsedSecs.toString();

      // Center Text
      final textSpan = TextSpan(
        text: displayText,
        style: counterTextPaint.style,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final xPosition = (parent.virtualSize.x - textPainter.width) * 0.5;
      final yPosition = (parent.virtualSize.y * 0.5 - textPainter.height * 0.5);

      // Render the stroke
      counterStrokeTextPaint.render(
        canvas,
        displayText,
        Vector2(xPosition, yPosition),
      );

      //Render the main text
      counterTextPaint.render(
        canvas,
        displayText,
        Vector2(xPosition, yPosition),
      );
    }
  }
}
