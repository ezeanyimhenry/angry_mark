import 'package:angry_mark/auth_screen.dart';
import 'package:angry_mark/game_screen.dart';
import 'package:angry_mark/instructions_screen.dart';
import 'package:angry_mark/screens/angrybird_screen.dart';
import 'package:angry_mark/settings_screen.dart';
// import 'package:angry_mark/instructions_screen.dart';
// import 'package:angry_mark/settings_screen.dart';
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
              // User icon at the top
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/angry-mark.jpeg'), // Profile image
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2, // Border width
                          ),
                        ),
                        // Add a tap gesture if needed
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                25), // Circular border radius
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
                    // Settings icon
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 50, // Width of the container
                        height: 50, // Height of the container
                        decoration: BoxDecoration(
                          color: Colors.black
                              .withOpacity(0.6), // Semi-transparent background
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.settings,
                                size: 30, color: Colors.white),
                            onPressed: () {
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
                  ],
                ),
              ),
              //settings icon at the top

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 50),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to game screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GameScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(180, 50),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        icon: const Icon(Icons.play_arrow, size: 24),
                        label: const Text(
                          'Start Game',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to instructions screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const InstructionsScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(180, 50),
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        icon: const Icon(Icons.help, size: 24),
                        label: const Text(
                          'Instructions',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to settings screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CharacterScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(180, 50),
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        icon: const Icon(Icons.settings, size: 24),
                        label: const Text(
                          'Characters',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
