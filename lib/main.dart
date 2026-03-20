import 'package:flutter/material.dart';
import 'splashScreen.dart';

void main() {
  runApp(TutophiaApp());
}

class TutophiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutophia',
      home: SplashScreen(), // 1. Change this to your splash screen widget
    );
  }
}
