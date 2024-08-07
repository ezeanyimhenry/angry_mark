import 'package:flutter/material.dart';
import '../birdcard_screen.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 47, 68, 110),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 47, 68, 110),
      ),
      body: Center(
        child: BirdCard(),
      ),
    );
  }
}
