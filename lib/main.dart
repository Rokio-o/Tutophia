// entry point for tutophia application

import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'login.dart';
import 'TutorAccess/dashboard-tutor.dart';
import 'StudentAccess/dashboard-student.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(TutophiaApp());
}

class TutophiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutophia',
      // put specific screen to run (StudentDashboard / TutorDashboard / login / splashScreen)
      home: SplashScreen(),
    );
  }
}
