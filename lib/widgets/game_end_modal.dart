import 'package:flutter/material.dart';

class GameEndModal extends StatelessWidget {
  final bool playerWon;
  final VoidCallback onNextLevel;
  final VoidCallback onRetry;
  final VoidCallback onQuit;

  const GameEndModal({
    super.key,
    required this.playerWon,
    required this.onNextLevel,
    required this.onRetry,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(playerWon ? "You Won!" : "Game Over"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              playerWon
                  ? 'assets/images/win_cup.webp'
                  : 'assets/images/lost_image.webp',
              height: 150,
            ),
            const SizedBox(height: 20),
            if (playerWon)
              ElevatedButton(
                onPressed: onNextLevel,
                child: const Text("Next Level"),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: onRetry,
                    child: const Text("Retry"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: onQuit,
                    child: const Text("Quit"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
