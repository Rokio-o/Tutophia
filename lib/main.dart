// entry point for tutophia application

import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notifications/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notificationService = NotificationService();
  await notificationService.initFCM();

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

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


Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Message: ${message.notification?.title}');
}
