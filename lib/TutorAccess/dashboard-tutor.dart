import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:tutophia/TutorAccess/tutor-menu/session-requests-tutor.dart';
import 'package:tutophia/services/repository/user_repository/user_repository.dart';
import 'package:tutophia/data/student-data/booking_repository.dart';
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
  StreamSubscription<int>? _pendingSub;
  StreamSubscription<int>? _upcomingSub;

  // These would be fetched dynamically per logged-in user
  String tutorName = "Tutor";
  String tutorType = "Tutor";
  String tutorCourse = "";
  String? tutorProfileImageUrl;
  int upcomingSessions = 0;
  int bookingRequests = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardProfile();
    _bindBookingCounts();
  }

  @override
  void dispose() {
    _pendingSub?.cancel();
    _upcomingSub?.cancel();
    super.dispose();
  }

  String _asString(dynamic value) {
    if (value is String) return value;
    return '';
  }

  Future<void> _loadDashboardProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final data = await UserRepository.instance.getUserProfile(uid);
    if (!mounted || data == null) return;

    final firstName = _asString(data['firstName']);
    final lastName = _asString(data['lastName']);
    final fullName = '$firstName $lastName'.trim();
    final dbTutorType = _asString(data['tutorType']);
    final program = _asString(data['program']);
    final university = _asString(data['university']);
    final imageUrl = _asString(data['profileImageUrl']);

    setState(() {
      tutorName = fullName.isNotEmpty ? fullName : tutorName;
      tutorType = dbTutorType.isNotEmpty ? dbTutorType : tutorType;
      tutorCourse = program.isNotEmpty
          ? program
          : (university.isNotEmpty ? university : tutorCourse);
      tutorProfileImageUrl = imageUrl.isNotEmpty ? imageUrl : null;
    });
  }

  void _bindBookingCounts() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _pendingSub = BookingRepository.instance.watchTutorPendingCount(uid).listen(
      (count) {
        if (!mounted) return;
        setState(() => bookingRequests = count);
      },
    );

    _upcomingSub = BookingRepository.instance
        .watchTutorUpcomingApprovedCount(uid)
        .listen((count) {
          if (!mounted) return;
          setState(() => upcomingSessions = count);
        });
  }

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
                profileImageSource: tutorProfileImageUrl,
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
        currentIndex: 0,
        onTap: (_) {},
        tabActions: [
          () {},
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TutorNotificationScreen(),
              ),
            );
          },
          () {
            Navigator.push(
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
