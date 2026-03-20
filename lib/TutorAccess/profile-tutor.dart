import 'package:flutter/material.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';

// White screen with back button header and bottom navigation bar for tutor profile page
// since si ray na gagawa raw yipiee
class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({super.key});

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  int _selectedIndex = 2; // Profile tab is index 2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: const Center(
        child: Text(
          "Tutor Profile Page",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        tabActions: [
          () {
            // Home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TutorDashboard()),
            );
          },
          () {
            // Notifications screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const TutorNotificationScreen(),
              ),
            );
          },
          () {
            // Profile screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TutorProfileScreen()),
            );
          },
        ],
      ),
    );
  }
}
