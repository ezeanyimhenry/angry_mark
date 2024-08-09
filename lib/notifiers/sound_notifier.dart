import 'package:angry_mark/core/sounds.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class SoundNotifer extends ValueNotifier<double>{

  SoundNotifer._():super(1.0);

  static final instance = SoundNotifer._();

  bool get hasSound => value>=1.0;
  void offSound(){
    value = 0.0;
    FlameAudio.bgm.stop();
    notifyListeners();
  }

  void onSound(){
    value = 1.0;
    FlameAudio.bgm.play(BirdSound.background);
    notifyListeners();
  }
}