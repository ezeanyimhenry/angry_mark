import 'package:angry_mark/core/sounds.dart';
import 'package:angry_mark/notifiers/sound_notifier.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final soundNotifier = SoundNotifer.instance;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (soundNotifier.hasSound) {
        FlameAudio.bgm.play(BirdSound.background);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hasSound = soundNotifier.hasSound;
    return Scaffold(
     
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,
                colors: [Colors.green, Colors.red,Colors.black], stops: [0.1,0.36, 0.7]),
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/angry-mark-background.jpg",
                ),
                fit: BoxFit.cover),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const SizedBox(),
                 Text(
                  'Settings:',
                  style: TextStyle(backgroundColor: Colors.lightGreen.withOpacity(0.5),
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              ]),
              // Add settings options here
              const SizedBox(height: 20),
              SettingsTile(
                label: "Sound:",
                trailing: IconButton(
                  onPressed: () {
                    if (hasSound) {
                      soundNotifier.offSound();
                    } else {
                      soundNotifier.onSound();
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    hasSound
                        ? Icons.volume_up_outlined
                        : Icons.volume_off_outlined,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.label,
    this.trailing,
    super.key,
  });
  final Widget? trailing;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style:const TextStyle(fontSize: 40, color: Colors.white),
        ),
        const Spacer(),
        trailing ??
            const Icon(
              Icons.arrow_forward_ios,
            )
      ],
    );
  }
}
