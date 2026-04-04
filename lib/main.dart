// entry point for tutophia application

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notifications/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

const useFirebaseEmulators = bool.fromEnvironment('USE_FIREBASE_EMULATORS');
const firebaseEmulatorHost = String.fromEnvironment(
  'FIREBASE_EMULATOR_HOST',
  defaultValue: 'localhost',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (useFirebaseEmulators) {
    final host = _resolveFirebaseEmulatorHost();
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
  }

  final notificationService = NotificationService();
  await notificationService.initFCM();

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  runApp(TutophiaApp());
}

String _resolveFirebaseEmulatorHost() {
  if (kIsWeb) {
    return firebaseEmulatorHost == 'localhost'
        ? '127.0.0.1'
        : firebaseEmulatorHost;
  }

  if (Platform.isAndroid &&
      (firebaseEmulatorHost == 'localhost' ||
          firebaseEmulatorHost == '127.0.0.1')) {
    return '10.0.2.2';
  }

  return firebaseEmulatorHost;
}

class TutophiaApp extends StatelessWidget {
  const TutophiaApp({super.key});

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
  debugPrint('Message: ${message.notification?.title}');
}
