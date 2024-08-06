// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
// import 'dart:ui' as ui;

// class Character {
//   Offset position;
//   Offset velocity;
//   final double radius;
//   ui.Image? _image;

//   static const double gravity = 0.5; // Gravity constant
//   static const double groundLevel =
//       600.0; // Adjust this to your screen's ground level

//   Character(this.position, this.velocity, this.radius);

//   Future<void> _loadImage() async {
//     final ByteData data = await rootBundle.load('assets/images/char1.png');
//     final List<int> bytes = data.buffer.asUint8List();
//     _image = await decodeImageFromList(Uint8List.fromList(bytes));
//   }

//   void update() {
//     // Apply gravity to vertical velocity
//     velocity = Offset(velocity.dx, velocity.dy + gravity);

//     // Update position based on velocity
//     position = Offset(position.dx + velocity.dx, position.dy + velocity.dy);

//     // Check if the character has hit the ground
//     if (position.dy + radius > groundLevel) {
//       position = Offset(position.dx, groundLevel - radius);
//       velocity = Offset(velocity.dx,
//           0); // Stop vertical movement, but horizontal movement continues
//     }
//   }

//   void draw(Canvas canvas) {
//     if (_image == null) {
//       return;
//     }

//     final paint = Paint();
//     final Rect destRect = Rect.fromCenter(
//       center: position,
//       width: radius * 2,
//       height: radius * 2,
//     );

//     canvas.drawImageRect(
//       _image!,
//       Rect.fromLTWH(0, 0, _image!.width.toDouble(), _image!.height.toDouble()),
//       destRect,
//       paint,
//     );
//   }

//   Future<void> init() async {
//     await _loadImage();
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'dart:ui' as ui;

class Character {
  Offset position;
  Offset velocity;
  final double radius;
  ui.Image? _image;

  static const double gravity = 0.5; // Gravity constant
  static const double groundLevel = 600.0; // Adjust this to your screen's ground level

  Character(this.position, this.velocity, this.radius);

  Future<void> _loadImage() async {
    final ByteData data = await rootBundle.load('assets/images/char1.png');
    final List<int> bytes = data.buffer.asUint8List();
    _image = await decodeImageFromList(Uint8List.fromList(bytes));
  }

  void update(Size screenSize) {
    // Apply gravity to vertical velocity
    velocity = Offset(velocity.dx, velocity.dy + gravity);

    // Update position based on velocity
    position = Offset(position.dx + velocity.dx, position.dy + velocity.dy);

    // Check if the character has hit the ground
    if (position.dy + radius > groundLevel) {
      position = Offset(position.dx, groundLevel - radius);
      velocity = Offset(velocity.dx, 0); // Stop vertical movement, but horizontal movement continues
    }

    // Check for left and right boundaries
    if (position.dx - radius < 0) {
      position = Offset(radius, position.dy);
      velocity = Offset(-velocity.dx, velocity.dy); // Reverse horizontal velocity
    } else if (position.dx + radius > screenSize.width) {
      position = Offset(screenSize.width - radius, position.dy);
      velocity = Offset(-velocity.dx, velocity.dy); // Reverse horizontal velocity
    }

    // Check for top boundary
    if (position.dy - radius < 0) {
      position = Offset(position.dx, radius);
      velocity = Offset(velocity.dx, -velocity.dy); // Reverse vertical velocity
    }
  }

  void draw(Canvas canvas) {
    if (_image == null) {
      return;
    }

    final paint = Paint();
    final Rect destRect = Rect.fromCenter(
      center: position,
      width: radius * 2,
      height: radius * 2,
    );

    canvas.drawImageRect(
      _image!,
      Rect.fromLTWH(0, 0, _image!.width.toDouble(), _image!.height.toDouble()),
      destRect,
      paint,
    );
  }

  Future<void> init() async {
    await _loadImage();
  }

  Rect getBounds() {
    return Rect.fromCircle(center: position, radius: radius);
  }
}
