import 'package:angry_mark/auth_screen.dart';
import 'package:angry_mark/game_screen.dart';
import 'package:angry_mark/instructions_screen.dart';
import 'package:angry_mark/settings_screen.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/angry-mark-background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay content
          Column(
            children: <Widget>[
              // Large Play Button
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to game screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GameScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(150, 150), // Adjust size as needed
                      backgroundColor: Colors.white.withOpacity(0.8),
                      foregroundColor: Colors.orange,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      textStyle: const TextStyle(fontSize: 24),
                    ),
                    child: const Icon(Icons.play_arrow, size: 100),
                  ),
                ),
              ),
            ],
          ),
          // Instructions Button
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to instructions screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InstructionsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(10),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Icon(Icons.help, size: 24),
            ),
          ),
          // Profile image & settings icon
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                // Settings icon
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.settings,
                            size: 30, color: Colors.white),
                        onPressed: () {
                          // Uncomment and update if you have a settings screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Profile image
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/angry-mark.jpeg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
