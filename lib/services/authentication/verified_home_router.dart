import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutophia/StudentAccess/dashboard-student.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/services/repository/user_repository/user_repository.dart';

class VerifiedHomeRouter {
  static Future<Widget?> resolve(User user) async {
    final role = await UserRepository.instance.getUserRole(user.uid);

    switch (role) {
      case 'student':
        return const StudentDashboard();
      case 'tutor':
        return const TutorDashboard();
      default:
        return null;
    }
  }

  static Future<bool> navigate(
    BuildContext context, {
    required User user,
    bool clearStack = true,
  }) async {
    final destination = await resolve(user);
    if (!context.mounted || destination == null) {
      return false;
    }

    final route = MaterialPageRoute<void>(builder: (_) => destination);
    if (clearStack) {
      Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
    } else {
      Navigator.of(context).pushReplacement(route);
    }

    return true;
  }
}
