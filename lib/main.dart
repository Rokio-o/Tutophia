// entry point for tutophia application

import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'login.dart';
import 'TutorAccess/dashboard-tutor.dart';

void main() {
  runApp(TutophiaApp());
}

class TutophiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutophia',
      home: TutorDashboard(),
    );
  }
}
