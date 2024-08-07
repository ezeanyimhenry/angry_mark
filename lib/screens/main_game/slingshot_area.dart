import 'package:flutter/material.dart';

import 'package:angry_mark/widgets/character/character.dart';

class SlingshotArea extends StatefulWidget {
  final Character character;
  final Function(Offset) onLaunch;
  final Function(Offset) onDrag; // Add this callback
  const SlingshotArea({
    super.key,
    required this.character,
    required this.onLaunch,
    required this.onDrag,
  });

  @override
  SlingshotAreaState createState() => SlingshotAreaState();
}

class SlingshotAreaState extends State<SlingshotArea> {
  Offset _startPosition = Offset.zero;
  Offset _currentPosition = Offset.zero;
  bool _dragging = false;
  bool _gameStarted = false;
  late Offset _catapultBase;
  final double _catapultWidth = 100.0;
  final double _catapultHeight = 100.0;
  final double _maxDragDistance = 100.0;
  final double _catapultOffset = 50.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _startPosition = details.localPosition;
          _currentPosition = details.localPosition;
          _dragging = true;
          _gameStarted = true;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          final offset = details.localPosition - _startPosition;
          if (offset.distance <= _maxDragDistance) {
            _currentPosition = details.localPosition;
          } else {
            _currentPosition =
                _startPosition + (offset / offset.distance) * _maxDragDistance;
          }

          // Pass drag offset to background updater
          widget.onDrag(details.globalPosition - _startPosition);
        });
      },
      onPanEnd: (details) {
        setState(() {
          _dragging = false;
          final launchVector = _currentPosition - _startPosition;
          widget.onLaunch(launchVector);
        });
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final catapultLeft = _catapultOffset;
        final catapultTop = constraints.maxHeight - _catapultHeight - 50;

        _catapultBase = Offset(catapultLeft, catapultTop);

        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Background image for the catapult
              Positioned(
                bottom: 50,
                left: catapultLeft,
                child: Image.asset(
                  'assets/images/catapult.png',
                  width: _catapultWidth,
                  height: _catapultHeight,
                  fit: BoxFit.cover,
                ),
              ),
              CustomPaint(
                painter: SlingshotPainter(
                  _startPosition,
                  _currentPosition,
                  _dragging,
                  _catapultBase,
                  Size(constraints.maxWidth, constraints.maxHeight),
                  _catapultWidth,
                  _catapultHeight,
                ),
                child: Center(
                  child: Text(
                    _gameStarted ? '' : 'Drag to Launch',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class SlingshotPainter extends CustomPainter {
  final Offset startPosition;
  final Offset currentPosition;
  final bool dragging;
  final Offset catapultBase;
  final Size screenSize;
  final double catapultWidth;
  final double catapultHeight;

  SlingshotPainter(
    this.startPosition,
    this.currentPosition,
    this.dragging,
    this.catapultBase,
    this.screenSize,
    this.catapultWidth,
    this.catapultHeight,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (dragging) {
      final paint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      final catapultLeftEdge =
          Offset(catapultBase.dx, catapultBase.dy + catapultHeight / 2);
      final catapultRightEdge = Offset(catapultBase.dx + catapultWidth,
          catapultBase.dy + catapultHeight / 2);

      canvas.drawLine(catapultLeftEdge, currentPosition, paint);
      canvas.drawLine(catapultRightEdge, currentPosition, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}




// import 'package:flutter/material.dart';
// import 'package:angry_mark/character.dart';

// class SlingshotArea extends StatefulWidget {
//   final Character character;
//   final Function(Offset) onLaunch;
//   const SlingshotArea({
//     super.key,
//     required this.character,
//     required this.onLaunch,
//   });

//   @override
//   SlingshotAreaState createState() => SlingshotAreaState();
// }

// class SlingshotAreaState extends State<SlingshotArea> {
//   Offset _startPosition = Offset.zero;
//   Offset _currentPosition = Offset.zero;
//   bool _dragging = false;
//   bool _gameStarted = false;
//   late Offset _catapultBase;
//   final double _catapultWidth = 100.0;
//   final double _catapultHeight = 100.0;
//   final double _maxDragDistance = 100.0; // Limit the dragging distance

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onPanStart: (details) {
//         setState(() {
//           _startPosition = details.localPosition;
//           _currentPosition = details.localPosition;
//           _dragging = true;
//           _gameStarted = true;
//         });
//       },
//       onPanUpdate: (details) {
//         setState(() {
//           final offset = details.localPosition - _startPosition;
//           if (offset.distance <= _maxDragDistance) {
//             _currentPosition = details.localPosition;
//           } else {
//             _currentPosition = _startPosition + (offset / offset.distance) * _maxDragDistance;
//           }
//         });
//       },
//       onPanEnd: (details) {
//         setState(() {
//           _dragging = false;
//           final launchVector = _startPosition - _currentPosition;
//           widget.onLaunch(launchVector);
//         });
//       },
//       child: LayoutBuilder(builder: (context, constraints) {
//         final catapultLeft = constraints.maxWidth / 2 - _catapultWidth / 2;
//         final catapultTop = constraints.maxHeight - _catapultHeight - 50;

//         _catapultBase = Offset(catapultLeft, catapultTop);

//         return SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: Stack(
//             children: [
//               // Background image for the catapult
//               Positioned(
//                 bottom: 50,
//                 left: catapultLeft,
//                 child: Image.asset(
//                   'assets/images/catapult.png',
//                   width: _catapultWidth,
//                   height: _catapultHeight,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               CustomPaint(
//                 painter: SlingshotPainter(
//                   _startPosition,
//                   _currentPosition,
//                   _dragging,
//                   _catapultBase,
//                   Size(constraints.maxWidth, constraints.maxHeight),
//                   _catapultWidth,
//                   _catapultHeight,
//                 ),
//                 child: Center(
//                   child: Text(
//                     _gameStarted ? '' : 'Drag to Launch',
//                     style: const TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

// class SlingshotPainter extends CustomPainter {
//   final Offset startPosition;
//   final Offset currentPosition;
//   final bool dragging;
//   final Offset catapultBase;
//   final Size screenSize;
//   final double catapultWidth;
//   final double catapultHeight;

//   SlingshotPainter(
//     this.startPosition,
//     this.currentPosition,
//     this.dragging,
//     this.catapultBase,
//     this.screenSize,
//     this.catapultWidth,
//     this.catapultHeight,
//   );

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (dragging) {
//       final paint = Paint()
//         ..color = Colors.black
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 3.0;

//       // Calculate edges of the catapult image
//       final catapultLeftEdge =
//           Offset(catapultBase.dx, catapultBase.dy + catapultHeight / 2);
//       final catapultRightEdge = Offset(catapultBase.dx + catapultWidth,
//           catapultBase.dy + catapultHeight / 2);

//       // Draw drag lines from edges
//       canvas.drawLine(catapultLeftEdge, currentPosition, paint);
//       canvas.drawLine(catapultRightEdge, currentPosition, paint);

//       // Draw the character at the current position
//       final characterPaint = Paint()..color = Colors.red;
//       canvas.drawCircle(currentPosition, 10.0, characterPaint); // Adjust as needed
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

