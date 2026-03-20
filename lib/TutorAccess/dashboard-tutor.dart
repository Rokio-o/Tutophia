import 'package:flutter/material.dart';
import 'package:tutophia/TutorAccess/tutor-menu/session-requests-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/tutor-dashboard-card.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/header-tutor-wdgt.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';
import 'package:tutophia/TutorAccess/tutor-menu/upload-materials.dart';
import 'package:tutophia/TutorAccess/tutor-menu/feedback-tutor.dart';
import 'package:tutophia/TutorAccess/tutor-menu/session-history-tutor.dart';

class TutorDashboard extends StatefulWidget {
  const TutorDashboard({super.key});

  @override
  State<TutorDashboard> createState() => _TutorDashboardState();
}

class _TutorDashboardState extends State<TutorDashboard> {
  int _selectedIndex = 0;

  // These would be fetched dynamically per logged-in user
  final String tutorName = "Tutor Name";
  final String tutorType = "Student Tutor";
  final String tutorCourse = "Course";
  final String? tutorProfileImage = " ";
  int upcomingSessions = 0;
  int bookingRequests = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── Header ──
              const HeaderTutorWdgt.dashboard(),

              const SizedBox(height: 25),

              // ── Tutor Dashboard Card (reusable widget) ──
              TutorDashboardCard(
                name: tutorName,
                tutorType: tutorType,
                course: tutorCourse,
                upcomingSessions: upcomingSessions,
                bookingRequests: bookingRequests,
                profileImagePath: tutorProfileImage,
              ),

              const SizedBox(height: 30),

              // ── Menu Grid ──
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.2,
                children: [
                  _menuButton("Session Requests", Icons.class_, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SessionRequestsScreen(),
                      ),
                    );
                  }),
                  _menuButton("Upload Materials", Icons.upload_file, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UploadMaterialsScreen(),
                      ),
                    );
                  }),
                  _menuButton("Session History", Icons.history, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SessionHistoryScreen(),
                      ),
                    );
                  }),
                  _menuButton("Feedback", Icons.star_outline, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FeedbackTutorScreen(),
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation ──
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        tabActions: [
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TutorDashboard()),
            );
          },
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const TutorNotificationScreen(),
              ),
            );
          },
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TutorProfileScreen()),
            );
          },
        ],
      ),
    );
  }

  Widget _menuButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff3d6fa5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 35),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
