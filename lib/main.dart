// entry point for tutophia application

import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'TutorAccess/registration1-tutor.dart';
import 'TutorAccess/registration2-tutor.dart';
import 'TutorAccess/registration3-tutor.dart';
import 'StudentAccess/registration1-student.dart';
import 'StudentAccess/registration2-student.dart';
import 'StudentAccess/dashboard-student.dart';
import 'registration-type.dart';
import 'StudentAccess/terms-condition-student.dart';
import 'TutorAccess/terms-condition-tutor.dart';

void main() {
  runApp(TutophiaApp());
}

class TutophiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutophia',
      home: SplashScreen(),
    );
  }
}
