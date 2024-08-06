import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:angry_mark/character.dart';
import 'package:angry_mark/obstacle.dart';
import 'package:angry_mark/slingshot_area.dart';
import 'package:flutter/services.dart';

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
  Offset _backgroundOffset = Offset.zero;
  ui.Image? _backgroundImage;
  Size? _screenSize;

  @override
  void initState() {
    super.initState();

    _character = Character(const Offset(100, 300), Offset.zero, 40.0);
    _character!.init().then((_) {
      setState(() {});
    });

    _loadBackgroundImage();
    // Positioning obstacles horizontally within the phone frame
    _obstacles = [
      Obstacle(const Rect.fromLTWH(400, 400, 50, 50),
          type: ObstacleType.glass), // Obstacle to the right of the slingshot
      Obstacle(const Rect.fromLTWH(500, 400, 50, 50),
          type: ObstacleType.wood), // Another obstacle further right
      Obstacle(const Rect.fromLTWH(450, 350, 50, 50),
          type: ObstacleType.wood), // Stacked obstacle
    ];

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      updateGame();
    });
  }

  Future<void> _loadBackgroundImage() async {
    final ByteData data =
        await rootBundle.load('assets/images/game-background.jpeg');
    final Uint8List bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    setState(() {
      _backgroundImage = image;
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
        _character!.update(
            MediaQuery.of(context).size); // Pass screen size to update method

        // Check for collisions
        for (var obstacle in _obstacles) {
          if (!obstacle.isDestroyed &&
              obstacle.rect.overlaps(_character!.getBounds())) {
            obstacle.handleCollision(_character!.position);
            if (obstacle.isDestroyed) {
              _character!.velocity = Offset.zero;
            }
          }
        }

        // Update the background offset based on character movement
        _backgroundOffset = Offset(
          _backgroundOffset.dx - _character!.velocity.dx,
          _backgroundOffset.dy - _character!.velocity.dy,
        );

        // Ensure background wraps around
        if (_screenSize != null && _backgroundImage != null) {
          final imageWidth = _backgroundImage!.width.toDouble();
          final imageHeight = _backgroundImage!.height.toDouble();

          // Wrap around logic
          if (_backgroundOffset.dx < 0) {
            _backgroundOffset =
                Offset(_backgroundOffset.dx + imageWidth, _backgroundOffset.dy);
          } else if (_backgroundOffset.dx > imageWidth) {
            _backgroundOffset =
                Offset(_backgroundOffset.dx - imageWidth, _backgroundOffset.dy);
          }

          if (_backgroundOffset.dy < 0) {
            _backgroundOffset = Offset(
                _backgroundOffset.dx, _backgroundOffset.dy + imageHeight);
          } else if (_backgroundOffset.dy > imageHeight) {
            _backgroundOffset = Offset(
                _backgroundOffset.dx, _backgroundOffset.dy - imageHeight);
          }
        }
      });
    }
  }

  void _updateBackgroundOffset(Offset dragOffset) {
    setState(() {
      _backgroundOffset = Offset(
        _backgroundOffset.dx + dragOffset.dx,
        _backgroundOffset.dy + dragOffset.dy,
      );
    });
  }

  void _resetGame() {
    setState(() {
      _character = Character(const Offset(100, 300), Offset.zero, 40.0);
      _character!.init().then((_) {
        setState(() {});
      });

      _obstacles = [
        Obstacle(const Rect.fromLTWH(400, 400, 50, 50),
            type: ObstacleType.glass),
        Obstacle(const Rect.fromLTWH(500, 400, 50, 50),
            type: ObstacleType.wood),
        Obstacle(const Rect.fromLTWH(450, 350, 50, 50),
            type: ObstacleType.glass),
      ];

      _isLaunched = false;
      _backgroundOffset = Offset.zero; // Reset background position
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      updateGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/game-background.jpeg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Positioned.fill(
            child: CustomPaint(
              painter: GamePainter(_character, _obstacles, _backgroundImage,
                  _backgroundOffset, _screenSize),
              child: SlingshotArea(
                character: _character!,
                onLaunch: _handleLaunch,
                onDrag: (dragOffset) {
                  // Optionally update the background offset based on drag
                  _updateBackgroundOffset(dragOffset);
                },
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
                _resetGame();
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
  final ui.Image? backgroundImage;
  final Offset backgroundOffset;
  final Size? screenSize;

  GamePainter(this.character, this.obstacles, this.backgroundImage,
      this.backgroundOffset, this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background image
    if (backgroundImage != null) {
      final imageWidth = backgroundImage!.width.toDouble();
      final imageHeight = backgroundImage!.height.toDouble();

      // Draw background image multiple times to cover the screen
      final paint = Paint();
      final numImagesX = (size.width / imageWidth).ceil();
      final numImagesY = (size.height / imageHeight).ceil();

      for (int x = 0; x < numImagesX; x++) {
        for (int y = 0; y < numImagesY; y++) {
          final offsetX = (x * imageWidth) - backgroundOffset.dx % imageWidth;
          final offsetY = (y * imageHeight) - backgroundOffset.dy % imageHeight;
          canvas.drawImageRect(
            backgroundImage!,
            Rect.fromLTWH(0, 0, imageWidth, imageHeight),
            Rect.fromLTWH(offsetX, offsetY, imageWidth, imageHeight),
            paint,
          );
        }
      }
    } else {
      // Optional: Draw a solid color background if image is not loaded
      final paint = Paint()..color = Colors.blue;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }

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
