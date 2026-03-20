// entry point for tutophia application

import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'login.dart';
import 'TutorAccess/dashboard-tutor.dart';
import 'TutorAccess/tutor-menu/session-requests-tutor.dart';
import 'TutorAccess/tutor-menu/view-session-request.dart';
import 'TutorAccess/registration2-tutor.dart';
import 'TutorAccess/tutor-menu/view-session-request.dart';
import 'StudentAccess/registration1-student.dart';
import 'StudentAccess/registration2-student.dart';
import 'TutorAccess/registration1-tutor.dart';
import 'StudentAccess/dashboard-student.dart';
import 'TutorAccess/tutor-menu/view-session-details.dart';
import 'package:tutophia/TutorAccess/registration1-tutor.dart';

void main() {
  runApp(TutophiaApp());
}

class TutophiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutophia',
      home: StudentDashboard(),
    );
  }
}
