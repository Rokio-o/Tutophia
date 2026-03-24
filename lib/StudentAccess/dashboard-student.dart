import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutophia/StudentAccess/menu-feedback.dart';
import 'package:tutophia/StudentAccess/menu-find_tutors_student.dart';
import 'package:tutophia/StudentAccess/session-materials.dart';
import 'package:tutophia/StudentAccess/session-history-student.dart';
import 'package:tutophia/StudentAccess/notifications-student.dart';
import 'package:tutophia/StudentAccess/profile-student.dart';
import 'package:tutophia/StudentAccess/menu-my_booking.dart';
import 'package:tutophia/services/repository/user_repository/user_repository.dart';
import 'package:tutophia/widgets/student-widgets/student-dashboard-card.dart';
import 'package:tutophia/widgets/student-widgets/bottom-navigation-student.dart';
import 'package:tutophia/widgets/student-widgets/header-student-wgt.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;
  String studentName = 'Student';
  String studentCourse = '';

  // placeholder stats — replace with real data from backend
  int upcomingSessions = 0;
  int pendingBookings = 0;
  int newMaterials = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardProfile();
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
    final program = _asString(data['program']);
    final university = _asString(data['university']);

    setState(() {
      studentName = fullName.isNotEmpty ? fullName : studentName;
      studentCourse = program.isNotEmpty
          ? program
          : (university.isNotEmpty ? university : studentCourse);
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

              // ── Dashboard Header ──
              const HeaderStudentWdgt.dashboard(),

              const SizedBox(height: 25),

              // ── Profile Card with Stats ──
              StudentDashboardCard(
                name: studentName,
                course: studentCourse,
                upcomingSessions: upcomingSessions,
                pendingBookings: pendingBookings,
                newMaterials: newMaterials,
                profileImagePath:
                    "assets/icons/student_profile_placeholder.png",
              ),

              const SizedBox(height: 25),

              // ── Menu Option Grid ──
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.2,
                children: [
                  _menuButton("Find Tutors", Icons.search, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FindTutors()),
                    );
                  }),

                  _menuButton("My Bookings", Icons.calendar_today, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentBookingsScreen(),
                      ),
                    );
                  }),

                  _menuButton("Session Materials", Icons.menu_book, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SessionMaterialsScreen(),
                      ),
                    );
                  }),

                  _menuButton("Feedback", Icons.feedback, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FeedbackScreen()),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 15),

              // ── Session History Button ──
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SessionHistoryScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xff3d6fa5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Session History",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation ──
      bottomNavigationBar: BottomNavStudent(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StudentNotificationsScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudentProfileScreen()),
            );
          }
        },
      ),
    );
  }

  // ── Menu Button Widget ──
  Widget _menuButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff3d6fa5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
