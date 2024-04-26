import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;
import 'package:ski_master/game/routes/gameplay.dart';
import 'package:ski_master/game/routes/level_complete.dart';
import 'package:ski_master/game/routes/level_selection.dart';
import 'package:ski_master/game/routes/main_menu.dart';
import 'package:ski_master/game/routes/pause_menu.dart';
import 'package:ski_master/game/routes/retry_menu.dart';
import 'package:ski_master/game/routes/settings.dart';

class SkiMasterGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  static const snowmanSfx = 'Snowman.wav';
  static const hurtSfx = 'Hurt.wav';
  static const boostSfx = 'boost.wav';
  static const timerSfx = '321.wav';
  static const goSfx = 'Go!.wav';
  static const deathSfx = 'Death.wav';
  static const gameBgm = '8BitDNALoop.wav';
  static const itemBox = 'itemBox.wav';
  static const shieldSfx = 'Shield.wav';
  static const speedSfx = 'Speed.wav';
  static const bulletSfx = 'Bullet.wav';

  final musicValueNotifier = ValueNotifier(false);
  final sfxValueNotifier = ValueNotifier(false);

  ValueNotifier<bool> showJoypadNotifier = ValueNotifier(false);

  //Stores the mapping between strings and routes using a id as a key
  late final _routes = <String, Route>{
    MainMenu.id: OverlayRoute(
      (context, game) => MainMenu(
        onPlayPressed: () => _routeById(LevelSelection.id),
        onSettingsPressed: () => _routeById(Settings.id),
      ),
    ),
    Settings.id: OverlayRoute(
      (context, game) => Settings(
        musicValueListenable: musicValueNotifier,
        sfxValueListenable: sfxValueNotifier,
        onBackPressed: _popRoute,
        onMusicValueChanged: (value) => musicValueNotifier.value = value,
        onSfxcValueChanged: (value) => sfxValueNotifier.value = value,
      ),
    ),
    LevelSelection.id: OverlayRoute(
      (context, game) => LevelSelection(
        onLevelSelected: _startLevel,
        onBackPressed: _popRoute,
      ),
    ),
    PauseMenu.id: OverlayRoute(
      (context, game) => PauseMenu(
        onResumePressed: _resumeGame,
        onRestartPressed: _restartLevel,
        onExitPressed: _exitToMainMenu,
      ),
    ),
    RetryMenu.id: OverlayRoute(
      (context, game) => RetryMenu(
        onRetryPressed: _restartLevel,
        onExitPressed: _exitToMainMenu,
      ),
    ),
  };

  late final _routeFactories = <String, Route Function(String)>{
    LevelComplete.id: (argument) => OverlayRoute(
          (context, game) => LevelComplete(
            nStars: int.parse(argument),
            onNextPressed: _startNextLevel,
            onRetryPressed: _restartLevel,
            onExitPressed: _exitToMainMenu,
          ),
        ),
  };

  late final _router = RouterComponent(
    initialRoute: MainMenu.id,
    routes: _routes,
    routeFactories: _routeFactories,
  );

  @override
  Color backgroundColor() => const Color.fromARGB(255, 238, 248, 254);

  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache.loadAll(
      [
        hurtSfx,
        boostSfx,
        snowmanSfx,
        deathSfx,
        gameBgm,
        timerSfx,
        goSfx,
        itemBox,
        shieldSfx,
        boostSfx,
        bulletSfx,
      ],
    );
    await add(_router);
  }

  void _routeById(String id) {
    _router.pushNamed(id);
  }

  void _popRoute() {
    _router.pop();
  }

  void _startLevel(int levelIndex) {
    _router.pop();
    _router.pushReplacement(
        Route(
          () => Gameplay(
            levelIndex,
            onPausePressed: _pauseGame,
            onLevelCompleted: _showLevelCompleteMenu,
            onGameOver: _showRetryMenu,
            key: ComponentKey.named(Gameplay.id),
          ),
        ),
        name: Gameplay.id);
  }

  void _restartLevel() {
    final gameplay = findByKeyName<Gameplay>(Gameplay.id);
    if (gameplay != null) {
      _startLevel(gameplay.currentLevel);
      resumeEngine();
    }
  }

  void _startNextLevel() {
    final gameplay = findByKeyName<Gameplay>(Gameplay.id);
    if (gameplay != null) {
      if (gameplay.currentLevel == 4) {
        _exitToMainMenu();
      } else {
        _startLevel(gameplay.currentLevel + 1);
      }
    }
  }

  void _pauseGame() {
    _router.pushNamed(PauseMenu.id);
    pauseEngine();
  }

  void _resumeGame() {
    _router.pop();
    resumeEngine();
  }

  void _exitToMainMenu() {
    _resumeGame();
    _router.pushReplacementNamed(MainMenu.id);
  }

  void _showLevelCompleteMenu(int nStars) {
    //First slash is input id second is argument
    _router.pushNamed('${LevelComplete.id}/$nStars');
  }

  void _showRetryMenu() {
    _router.pushNamed(RetryMenu.id);
  }
}
