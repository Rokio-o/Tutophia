import 'package:flutter/material.dart';
import 'package:tutophia/login.dart';

class SuccessfulRegistration extends StatefulWidget {
  const SuccessfulRegistration({super.key});

  @override
  State<SuccessfulRegistration> createState() => _SuccessfulRegistrationState();
}

class _SuccessfulRegistrationState extends State<SuccessfulRegistration> {
  @override
  void initState() {
    super.initState();

    // Loading delay before redirecting to login
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFFF9AB55)),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Registered illustration
            Image.asset(
              'assets/images/registered-illustration.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),

            // Account Created Title
            const Text(
              'ACCOUNT CREATED',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Loading message
            const Text(
              'Your account has been successfully created.\nPlease log in to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF386FA4)),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
