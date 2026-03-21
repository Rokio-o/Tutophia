// entry point for tutophia application

import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'login.dart';
import 'TutorAccess/dashboard-tutor.dart';
import 'StudentAccess/dashboard-student.dart';
<<<<<<< HEAD
import 'StudentAccess/menu-session-history.dart';
import 'StudentAccess/menu-session-materials.dart';
import 'TutorAccess/tutor-menu/view-session-details.dart';
import 'package:tutophia/TutorAccess/registration1-tutor.dart';
=======
>>>>>>> 44021367e3b4a8ecd52ba8b08169ec34fbc1ab04


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
