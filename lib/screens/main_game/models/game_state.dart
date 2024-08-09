import 'package:angry_mark/actors/enemy.dart';
import 'package:angry_mark/widgets/game_end_modal.dart';
import 'package:flutter/material.dart';

class GameState {
  final BuildContext context;
  List<Enemy> enemies = [];

  GameState(this.context);

  void addEnemy(Enemy enemy) {
    enemies.add(enemy);
  }

  void removeEnemy(Enemy enemy) {
    enemies.remove(enemy);
  }

  bool get hasEnemies => enemies.isNotEmpty;

  void endLevel(bool playerWon) {
    showDialog(
      context: context,
      builder: (context) {
        return GameEndModal(
          playerWon: playerWon,
          onNextLevel: () {
            Navigator.of(context).pop(); // Close the dialog
            // Logic to proceed to the next level
          },
          onRetry: () {
            Navigator.of(context).pop(); // Close the dialog
            // Logic to restart the current level
          },
          onQuit: () {
            Navigator.of(context).pop(); // Close the dialog
            // Logic to quit the game
          },
        );
      },
    );
  }
}
