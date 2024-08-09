
import 'package:angry_mark/mythems/theme.dart';
import 'package:angry_mark/screens/splash_screen.dart';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:kimko_auth/kimko_auth.dart';
KimkoAuth kimkoAuth = KimkoAuth();
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();
  Flame.device.fullScreen();
//   await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );
 await KimkoAuth.initialize(teamId: 'angrybird-kimiko-f06');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Angry Mark',
      theme: ThemeData(
        primarySwatch: Colors.green,
        inputDecorationTheme: InputDecorTheme.inputDecorTheme,
        elevatedButtonTheme: AppElevatedButtonTheme.appElevatedButtonTheme
      ),
      home: const SplashScreen(),
    );
  }
}
