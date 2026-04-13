// tutophia splash screen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:tutophia/onboardingScreen.dart';
import 'package:tutophia/services/authentication/verified_home_router.dart';
import 'package:tutophia/services/repository/authentication_repository/authentication_repository.dart';
import 'package:tutophia/verify-email.dart';

const _hasSeenOnboardingKey = 'has_seen_onboarding';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // loading delay
    Future.delayed(const Duration(seconds: 5), _routeFromSplash);
  }

  Future<void> _routeFromSplash() async {
    if (!mounted || _hasNavigated) return;

    final preferences = await SharedPreferences.getInstance();
    final hasSeenOnboarding =
        preferences.getBool(_hasSeenOnboardingKey) ?? false;

    if (!hasSeenOnboarding) {
      _navigateTo(const OnboardingScreen());
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    Widget destination = const LoginScreen();

    if (currentUser != null) {
      final refreshedUser = await AuthenticationRepository.instance
          .reloadCurrentUser();

      if (refreshedUser != null) {
        if (!refreshedUser.emailVerified) {
          destination = VerifyEmailScreen(email: refreshedUser.email);
        } else {
          destination =
              await VerifiedHomeRouter.resolve(refreshedUser) ??
              const LoginScreen();
          if (destination is LoginScreen) {
            await AuthenticationRepository.instance.signOut();
          }
        }
      }
    }

    _navigateTo(destination);
  }

  void _navigateTo(Widget destination) {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => destination),
      (route) => false,
    );
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
            colors: [Color(0xFFFFFEFF), Color(0xFFF9AB55)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        // logo, app name, tagline, loading indicator of splash screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // tutophia logo
            Image.asset(
              'assets/images/tutophia-logo-white-outline.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),

            // tutophia name
            Text(
              'TUTOPHIA',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 40,
                color: Color(0xFF386FA4),
                fontWeight: FontWeight.bold,
              ),
            ),

            // tutophia tagline
            Text(
              'There’s always a tutor here for you!',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 14,
                color: Colors.black54,
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
