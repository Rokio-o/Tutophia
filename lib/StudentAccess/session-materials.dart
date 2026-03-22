import 'package:flutter/material.dart';
import 'package:tutophia/data/student-data/session-materials-repository.dart';
import 'package:tutophia/widgets/student-widgets/bottom-navigation-student.dart';
import 'package:tutophia/widgets/student-widgets/header-student-wgt.dart';
import 'package:tutophia/widgets/student-widgets/session-material-card.dart';
import 'package:tutophia/StudentAccess/profile-student.dart';
import 'package:tutophia/StudentAccess/dashboard-student.dart';
import 'package:tutophia/StudentAccess/notifications-student.dart';

class SessionMaterialsScreen extends StatelessWidget {
  const SessionMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),

              const SizedBox(height: 12),

              // Header
              const HeaderStudentWdgt.sessionMaterials(),

              const SizedBox(height: 24),

              // Materials list from repository
              ...sessionMaterialsList.map(
                (material) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SessionMaterialCard(
                    data: material,
                    onDownload: () {
                      // TODO: implement file download using material.fileUrl
                    },
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavStudent(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const StudentDashboard()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const StudentNotificationsScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const StudentProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
