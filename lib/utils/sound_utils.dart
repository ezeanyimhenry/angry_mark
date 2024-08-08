import 'package:angry_mark/core/sounds.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundUtils {
  final audioPlayer = AudioPlayer();

  void loopAppSound() async {
    await audioPlayer.play(AssetSource(BirdSound.background));
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  /// this would be used to play any sound based on
  /// the event of the game
  void playSound(String soundPath) async {
    await audioPlayer.play(AssetSource(soundPath));
  }
}
