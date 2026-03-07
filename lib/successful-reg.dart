// successful registration

import 'package:flutter/material.dart';
import 'login.dart';
import 'StudentAccess/dashboard-student.dart';

class SuccessfulRegistration extends StatefulWidget {
  @override
  _SuccessfulRegistrationState createState() => _SuccessfulRegistrationState();
}

class _SuccessfulRegistrationState extends State<SuccessfulRegistration> {
  @override
  void initState() {
    super.initState();

    // loading delay
    Future.delayed(Duration(seconds: 5), () {
      // navigate to dashboard screen after delay for splash screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StudentDashboard()),
      );
    });
  }

  // visual design of the splash screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // gradient background for the splash screen
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9AB55), Color(0xFFF9AB55)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        // illustration, indicator,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // registered illustration
            Image.asset(
              'assets/images/registered-illustration.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),

            // tutophia name
            Text(
              'ACCOUNT CREATED',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 40,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),

            // loading message
            Text(
              'TUTOPHIA is now bringing you to the Dashboard. Please wait a moment.',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),

            // loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF386FA4)),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
