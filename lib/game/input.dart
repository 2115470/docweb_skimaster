import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Input extends Component with KeyboardHandler, HasGameReference {
  Input({Map<LogicalKeyboardKey, VoidCallback>? keyCallbacks})
      : _keyCallbacks = keyCallbacks ?? <LogicalKeyboardKey, VoidCallback>{};

  bool _leftPressed = false;
  bool _rightPressed = false;

  var leftInput = 0.0;
  var rightInput = 0.0;

  final maxHAxis = 1.5;
  final sensitivity = 3.0;
  bool active = false;

  final Map<LogicalKeyboardKey, VoidCallback> _keyCallbacks;

  @override
  void update(double dt) {
    leftInput = lerpDouble(
      leftInput,
      (_leftPressed && active) ? maxHAxis : 0,
      sensitivity * dt,
    )!;
    rightInput = lerpDouble(
      rightInput,
      (_rightPressed && active) ? maxHAxis : 0,
      sensitivity * dt,
    )!;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (game.paused == false) {
      _leftPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
          keysPressed.contains(LogicalKeyboardKey.arrowLeft);
      _rightPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
          keysPressed.contains(LogicalKeyboardKey.arrowRight);

      if (active && event is KeyDownEvent) {
        for (final entry in _keyCallbacks.entries) {
          if (entry.key == event.logicalKey) {
            entry.value.call();
          }
        }
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
