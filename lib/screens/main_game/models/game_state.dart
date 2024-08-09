import 'package:angry_mark/actors/enemy.dart';
import 'package:angry_mark/screens/main_game/game_screen.dart';
import 'package:angry_mark/widgets/game_end_modal.dart';
import 'package:flutter/material.dart';

class GameState {
  final BuildContext context;
  final MyGame game;
  List<Enemy> enemies = [];

  GameState(this.context, this.game);

  void addEnemy(Enemy enemy) {
    enemies.add(enemy);
  }

  void removeEnemy(Enemy enemy) {
    enemies.remove(enemy);
  }

  bool get hasEnemies => enemies.isNotEmpty;

  void endLevel(bool playerWon) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return GameEndModal(
          playerWon: playerWon,
          onNextLevel: () {
            Navigator.of(context).pop(); // Close the dialog
            game.nextLevel();
          },
          onRetry: () {
            Navigator.of(context).pop(); // Close the dialog
            game.restartLevel();
          },
          onQuit: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
