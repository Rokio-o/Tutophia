import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/header-tutor-wdgt.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/session-history-card.dart';
import 'package:tutophia/TutorAccess/give-feedback.dart';
import 'package:tutophia/TutorAccess/tutor-menu/upload-materials.dart';
import 'package:tutophia/models/tutor-model/feedback-tutor-data.dart';
import 'package:tutophia/models/tutor-model/session-history-data.dart';
import 'package:tutophia/data/tutor-data/feedback-tutor-repository.dart';
import 'package:tutophia/data/tutor-data/session-history-repository.dart';

// ── SessionHistoryScreen ──────────────────────────────────────────────────────

class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({super.key});

  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  int _selectedNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SessionStudentData> _filterStudents(List<SessionStudentData> students) {
    if (_searchQuery.isEmpty) return students;
    final q = _searchQuery.toLowerCase();
    return students
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              s.program.toLowerCase().contains(q) ||
              s.subject.toLowerCase().contains(q),
        )
        .toList();
  }

  StudentToRateData _feedbackTargetFromSession(SessionStudentData student) {
    return StudentToRateData(
      id: student.bookingId.isNotEmpty ? student.bookingId : student.id,
      studentId: student.id,
      bookingId: student.bookingId,
      name: student.name,
      program: student.program,
      imagePath: student.imagePath,
    );
  }

  Future<void> _openGiveFeedback(SessionStudentData student) async {
    final feedbackTarget = _feedbackTargetFromSession(student);
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => GiveFeedbackScreen(
          student: feedbackTarget,
          onSave: (feedback) => TutorFeedbackRepository.instance
              .submitTutorFeedback(student: feedbackTarget, advice: feedback),
        ),
      ),
    );

    if (saved == true && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Feedback saved!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tutorId = FirebaseAuth.instance.currentUser?.uid;

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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderTutorWdgt.sessionHistory(),

            const SizedBox(height: 20),

            // ── Search bar ────────────────────────────────────────────────────
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kSessionBorder),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black38,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Student list ──────────────────────────────────────────────────
            Expanded(
              child: tutorId == null
                  ? const Center(
                      child: Text(
                        'Please log in to view completed sessions.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                      ),
                    )
                  : StreamBuilder<List<SessionStudentData>>(
                      stream: TutorSessionHistoryRepository.instance
                          .watchCompletedStudents(tutorId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error loading session history: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          );
                        }

                        final students = _filterStudents(
                          snapshot.data ?? const <SessionStudentData>[],
                        );
                        if (students.isEmpty) {
                          return const Center(
                            child: Text(
                              'No completed students found.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black45,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: students.length,
                          itemBuilder: (_, i) {
                            final student = students[i];
                            return SessionHistoryCard(
                              key: ValueKey(student.bookingId),
                              student: student,
                              onGiveFeedback: () => _openGiveFeedback(student),
                              onGiveMaterials: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const UploadMaterialsScreen(),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        tabActions: [
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorDashboard()),
          ),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorNotificationScreen()),
          ),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorProfileScreen()),
          ),
        ],
      ),
    );
  }
}
