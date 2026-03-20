import 'package:flutter/material.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/header-tutor-wdgt.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/feedback-to-rate-card.dart';
import 'package:tutophia/TutorAccess/tutor-menu/rate-students.dart';
import 'package:tutophia/TutorAccess/tutor-menu/upload-materials.dart';
import 'package:tutophia/widgets/tutor-widgets/session-history-card.dart';

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

  // ── Sample data — replace with real data source ────────────────────────────

  final List<SessionStudentData> _students = [
    const SessionStudentData(
      id: '1',
      name: 'Isaac Rei Aniceta',
      program: 'Computer Science',
    ),
    const SessionStudentData(
      id: '2',
      name: 'Lance Gerald Ferangco',
      program: 'Computer Science',
    ),
    const SessionStudentData(
      id: '3',
      name: 'Ariah Mae Lindo',
      program: 'Computer Science',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SessionStudentData> get _filteredStudents {
    if (_searchQuery.isEmpty) return _students;
    final q = _searchQuery.toLowerCase();
    return _students
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              s.program.toLowerCase().contains(q),
        )
        .toList();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ── AppBar ─────────────────────────────────────────────────────────────
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
            // ── Header ───────────────────────────────────────────────────────
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
              child: _filteredStudents.isEmpty
                  ? const Center(
                      child: Text(
                        'No students found.',
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredStudents.length,
                      itemBuilder: (_, i) {
                        final student = _filteredStudents[i];
                        return SessionHistoryCard(
                          key: ValueKey(student.id),
                          student: student,
                          onGiveFeedback: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RateStudentScreen(
                                  student: StudentToRateData(
                                    id: student.id,
                                    name: student.name,
                                    program: student.program,
                                    imagePath: student.imagePath,
                                  ),
                                  onSave: (rating, comment) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Rating saved!'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          onGiveMaterials: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UploadMaterialsScreen(),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // ── Bottom Nav ─────────────────────────────────────────────────────────
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
