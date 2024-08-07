import 'package:angry_mark/mythems/theme.dart';
import 'package:angry_mark/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
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
