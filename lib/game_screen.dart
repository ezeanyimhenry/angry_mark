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
  ui.Image? _backgroundImage;

  double _zoomLevel = 0.8;
  double _targetZoomLevel = 0.8;
  final double _zoomSpeed = 0.1; // Adjust for smooth zoom

  @override
  void initState() {
    super.initState();

    _character = Character(const Offset(100, 300), Offset.zero, 40.0);
    _character!.init().then((_) {
      setState(() {});
    });

    _loadBackgroundImage();
    // Positioning obstacles
    _obstacles = [
      Obstacle(const Rect.fromLTWH(800, 400, 50, 50), type: ObstacleType.glass),
      Obstacle(const Rect.fromLTWH(900, 400, 50, 50), type: ObstacleType.wood),
      Obstacle(const Rect.fromLTWH(850, 350, 50, 50), type: ObstacleType.wood),
      Obstacle(const Rect.fromLTWH(800, 300, 50, 50), type: ObstacleType.stone),
      Obstacle(const Rect.fromLTWH(900, 300, 50, 50), type: ObstacleType.wood),
      Obstacle(const Rect.fromLTWH(850, 250, 50, 50), type: ObstacleType.stone),
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

  void _zoomIn() {
    setState(() {
      _targetZoomLevel = (_targetZoomLevel * 1.1)
          .clamp(0.5, 2.0); // Zoom in by 10%, with limits
    });
  }

  void _zoomOut() {
    setState(() {
      _targetZoomLevel = (_targetZoomLevel / 1.1)
          .clamp(0.5, 2.0); // Zoom out by 10%, with limits
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

      // Calculate zoom level based on drag strength
      _targetZoomLevel = (1 + launchStrength / 100).clamp(0.5, 2.0);

      // Launch the character in the opposite direction of the drag
      final initialVelocity =
          -launchDirection * launchStrength * 0.5; // Adjust factor as needed
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

        // Ensure the character rolls at the bottom of the screen
        final screenSize = MediaQuery.of(context).size;
        if (_character!.position.dy > screenSize.height - _character!.radius) {
          _character!.position = Offset(
            _character!.position.dx,
            screenSize.height - _character!.radius,
          );
          _character!.velocity =
              Offset(_character!.velocity.dx * 0.8, 0); // Dampening effect

          // Reset zoom level to default after touching the ground
          _zoomLevel = 0.8;
          _targetZoomLevel = 0.8;
        }

        // Smoothly adjust the zoom level
        if ((_targetZoomLevel - _zoomLevel).abs() > _zoomSpeed) {
          _zoomLevel += (_targetZoomLevel - _zoomLevel).sign * _zoomSpeed;
        } else {
          _zoomLevel = _targetZoomLevel;
        }
      });
    }
  }

  void _resetGame() {
    setState(() {
      _character = Character(const Offset(100, 300), Offset.zero, 40.0);
      _character!.init().then((_) {
        setState(() {});
      });

      _obstacles = [
        Obstacle(const Rect.fromLTWH(800, 400, 50, 50),
            type: ObstacleType.glass),
        Obstacle(const Rect.fromLTWH(900, 400, 50, 50),
            type: ObstacleType.wood),
        Obstacle(const Rect.fromLTWH(850, 350, 50, 50),
            type: ObstacleType.wood),
        Obstacle(const Rect.fromLTWH(800, 300, 50, 50),
            type: ObstacleType.stone),
        Obstacle(const Rect.fromLTWH(900, 300, 50, 50),
            type: ObstacleType.wood),
        Obstacle(const Rect.fromLTWH(850, 250, 50, 50),
            type: ObstacleType.stone),
      ];

      _isLaunched = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      updateGame();
    });
  }

  Future<void> _showQuitDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quit Game'),
          content: const Text('Are you sure you want to quit the game?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Quit'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.of(context).pop(); // Close the game screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GamePainter(
                _character,
                _obstacles,
                _backgroundImage,
                _zoomLevel,
              ),
              child: SlingshotArea(
                character: _character!,
                onLaunch: _handleLaunch,
                // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                onDrag: (Offset) {},
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Action for pause or menu button
                    _timer?.cancel();
                  },
                  child: const Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showQuitDialog();
                  },
                  child: const Text('Quit Game'),
                ),
              ],
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
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8), // Background color
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.zoom_in),
                    onPressed: _zoomIn,
                    color: Colors.black, // Icon color
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8), // Background color
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.zoom_out),
                    onPressed: _zoomOut,
                    color: Colors.black, // Icon color
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

class GamePainter extends CustomPainter {
  final Character? character;
  final List<Obstacle> obstacles;
  final ui.Image? backgroundImage;
  final double zoomLevel;

  GamePainter(
    this.character,
    this.obstacles,
    this.backgroundImage,
    this.zoomLevel,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (backgroundImage != null) {
      final imageWidth = backgroundImage!.width.toDouble();
      final imageHeight = backgroundImage!.height.toDouble();

      final scale = zoomLevel;

      final paint = Paint();
      final numImagesX = (size.width / (imageWidth * scale)).ceil();
      final numImagesY = (size.height / (imageHeight * scale)).ceil();

      for (int x = 0; x < numImagesX; x++) {
        for (int y = 0; y < numImagesY; y++) {
          final offsetX = x * imageWidth * scale;
          final offsetY = y * imageHeight * scale;
          canvas.drawImageRect(
            backgroundImage!,
            Rect.fromLTWH(0, 0, imageWidth, imageHeight),
            Rect.fromLTWH(
                offsetX, offsetY, imageWidth * scale, imageHeight * scale),
            paint,
          );
        }
      }
    } else {
      final paint = Paint()..color = Colors.blue;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }

    // Apply zoom effect by scaling the canvas
    canvas.save();
    canvas.scale(zoomLevel);

    if (character != null) {
      character!.draw(canvas);
    }

    for (var obstacle in obstacles) {
      obstacle.draw(canvas);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
