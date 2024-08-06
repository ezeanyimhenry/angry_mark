// import 'package:angry_mark/character.dart';
// import 'package:angry_mark/obstacle.dart';
// import 'package:angry_mark/slingshot_area.dart';
// import 'package:flutter/material.dart';

// class GameScreen extends StatefulWidget {
//   const GameScreen({super.key});

//   @override
//   GameScreenState createState() => GameScreenState();
// }

// class GameScreenState extends State<GameScreen> {
//   Character? _character;
//   List<Obstacle> _obstacles = [];
//   bool _isLaunched = false;

//   @override
//   void initState() {
//     super.initState();

//     _character = Character(const Offset(100, 300), Offset.zero, 40.0);
//     _character!.init().then((_) {
//       setState(() {});
//     });

//     _obstacles = [
//       Obstacle(const Rect.fromLTWH(250, 300, 50, 50)),
//       Obstacle(const Rect.fromLTWH(350, 300, 50, 50)),
//     ];
//   }

//   void _handleLaunch(Offset launchVector) {
//     setState(() {
//       final double launchStrength = launchVector.distance;
//       final Offset launchDirection = launchVector / launchStrength;

//       // Launch the character in the opposite direction of the drag
//       final initialVelocity = -launchDirection *
//           launchStrength *
//           0.5; // Adjust the factor as needed
//       if (_character != null) {
//         _character!.velocity = initialVelocity;
//         _isLaunched = true;
//       }
//     });
//   }

//   void updateGame() {
//     if (_character != null && _isLaunched) {
//       setState(() {
//         _character!.update();
//         // Check for collisions
//         for (var obstacle in _obstacles) {
//           if (obstacle.rect.contains(_character!.position)) {
//             obstacle.isDestroyed = true;
//             // Handle obstacle destruction logic
//           }
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     updateGame();

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/game-background.jpeg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned.fill(
//             child: CustomPaint(
//               painter: GamePainter(_character, _obstacles),
//               child: SlingshotArea(
//                 character: _character!,
//                 onLaunch: _handleLaunch,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 20,
//             left: 20,
//             child: ElevatedButton(
//               onPressed: () {
//                 // Action for pause or menu button
//               },
//               child: const Text('Pause'),
//             ),
//           ),
//           Positioned(
//             top: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: () {
//                 // Action for restart button
//               },
//               child: const Text('Restart'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GamePainter extends CustomPainter {
//   final Character? character;
//   final List<Obstacle> obstacles;

//   GamePainter(this.character, this.obstacles);

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (character != null) {
//       character!.draw(canvas);
//     }

//     for (var obstacle in obstacles) {
//       obstacle.draw(canvas);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:angry_mark/character.dart';
import 'package:angry_mark/obstacle.dart';
import 'package:angry_mark/slingshot_area.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  Character? _character;
  List<Obstacle> _obstacles = [];
  bool _isLaunched = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _character = Character(const Offset(100, 300), Offset.zero, 40.0);
    _character!.init().then((_) {
      setState(() {});
    });

    _obstacles = [
      Obstacle(const Rect.fromLTWH(250, 300, 50, 50), type: ObstacleType.wood),
      Obstacle(const Rect.fromLTWH(350, 300, 50, 50), type: ObstacleType.stone),
    ];

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      updateGame();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleLaunch(Offset launchVector) {
    setState(() {
      final double launchStrength = launchVector.distance;
      final Offset launchDirection = launchVector / launchStrength;

      // Launch the character in the opposite direction of the drag
      final initialVelocity = -launchDirection *
          launchStrength *
          0.5; // Adjust the factor as needed
      if (_character != null) {
        _character!.velocity = initialVelocity;
        _isLaunched = true;
      }
    });
  }

  void updateGame() {
    if (_character != null && _isLaunched) {
      setState(() {
        _character!.update();

        // Apply gravity
        _character!.velocity += const Offset(0, 0.5); // Adjust gravity as needed

        // Check for collisions
        for (var obstacle in _obstacles) {
          if (!obstacle.isDestroyed && obstacle.rect.overlaps(_character!.getBounds())) {
            obstacle.handleCollision(_character!.position);
            if (obstacle.isDestroyed) {
              _character!.velocity = Offset.zero;
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/game-background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: GamePainter(_character, _obstacles),
              child: SlingshotArea(
                character: _character!,
                onLaunch: _handleLaunch,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                // Action for pause or menu button
                _timer?.cancel();
              },
              child: const Text('Pause'),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // Action for restart button
                setState(() {
                  _character = Character(const Offset(100, 300), Offset.zero, 40.0);
                  _character!.init().then((_) {
                    setState(() {});
                  });

                  _obstacles = [
                    Obstacle(const Rect.fromLTWH(250, 300, 50, 50), type: ObstacleType.wood),
                    Obstacle(const Rect.fromLTWH(350, 300, 50, 50), type: ObstacleType.stone),
                  ];

                  _isLaunched = false;
                });

                _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
                  updateGame();
                });
              },
              child: const Text('Restart'),
            ),
          ),
        ],
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final Character? character;
  final List<Obstacle> obstacles;

  GamePainter(this.character, this.obstacles);

  @override
  void paint(Canvas canvas, Size size) {
    if (character != null) {
      character!.draw(canvas);
    }

    for (var obstacle in obstacles) {
      obstacle.draw(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
