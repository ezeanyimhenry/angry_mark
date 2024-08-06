import 'package:flutter/material.dart';

import '../mythems/theme.dart';
import '../widgets/birdcard_screen.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Angry Bird'),
        backgroundColor: AppColors.cardDark,
      ),
      body: Scaffold(
        backgroundColor: const Color.fromARGB(255, 47, 68, 110),
        body: Center(
          child: BirdCard(),
        ),
      ),
    );
  }
}
