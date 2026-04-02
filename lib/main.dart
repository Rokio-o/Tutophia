// entry point for tutophia application

import 'package:flutter/material.dart';
import 'package:tutophia/login.dart';
import 'onboardingScreen.dart';

void main() {
  runApp(TutophiaApp());
}

class TutophiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutophia',
      home: OnboardingScreen(),
    );
  }
}
