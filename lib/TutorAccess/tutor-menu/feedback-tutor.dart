import 'package:flutter/material.dart';
import 'package:tutophia/widgets/tutor-widgets/header-tutor-wdgt.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/feedback-to-rate-card.dart';
import 'package:tutophia/widgets/tutor-widgets/my-reviews-card.dart';
import 'package:tutophia/models/tutor-model/feedback-tutor-data.dart';
import 'package:tutophia/data/tutor-data/feedback-tutor-repository.dart';
import 'package:tutophia/widgets/tutor-widgets/feedback_constants.dart';
import 'rate-students.dart';

// ── Tab Enum ──────────────────────────────────────────────────────────────────

enum _FeedbackTab { toRate, myReviews }

// ── FeedbackTutorScreen ───────────────────────────────────────────────────────

class FeedbackTutorScreen extends StatefulWidget {
  const FeedbackTutorScreen({super.key});

  @override
  State<FeedbackTutorScreen> createState() => _FeedbackTutorScreenState();
}

class _FeedbackTutorScreenState extends State<FeedbackTutorScreen> {
  int _selectedNavIndex = 0;
  _FeedbackTab _activeTab = _FeedbackTab.toRate;

  late List<StudentToRateData> _studentsToRate;
  late List<ReviewData> _myReviews;

  @override
  void initState() {
    super.initState();
    _studentsToRate = List.from(sampleStudentsToRate);
    _myReviews = List.from(sampleMyReviews);
  }

  void _openRateScreen(StudentToRateData student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RateStudentScreen(
          student: student,
          onSave: (rating, comment) {
            setState(() {
              _studentsToRate.removeWhere((s) => s.id == student.id);
              _myReviews.insert(
                0,
                ReviewData(
                  id: student.id,
                  studentName: student.name,
                  program: student.program,
                  imagePath: student.imagePath,
                  rating: rating,
                  comment: comment,
                ),
              );
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Rating saved!')));
          },
        ),
      ),
    );
  }

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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderTutorWdgt.feedback(),
            const SizedBox(height: 20),
            _FeedbackTabBar(
              active: _activeTab,
              onTabChanged: (tab) => setState(() => _activeTab = tab),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _activeTab == _FeedbackTab.toRate
                  ? _ToRateList(
                      students: _studentsToRate,
                      onRate: _openRateScreen,
                    )
                  : _MyReviewsList(reviews: _myReviews),
            ),
          ],
        ),
      ),

      // ── Bottom Navigation ──
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

// ── _FeedbackTabBar ───────────────────────────────────────────────────────────

class _FeedbackTabBar extends StatelessWidget {
  final _FeedbackTab active;
  final ValueChanged<_FeedbackTab> onTabChanged;

  const _FeedbackTabBar({required this.active, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabButton(
            label: 'To Rate',
            isActive: active == _FeedbackTab.toRate,
            isLeft: true,
            onTap: () => onTabChanged(_FeedbackTab.toRate),
          ),
        ),
        Expanded(
          child: _TabButton(
            label: 'My Reviews',
            isActive: active == _FeedbackTab.myReviews,
            isLeft: false,
            onTap: () => onTabChanged(_FeedbackTab.myReviews),
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isLeft;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.isLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isActive ? kFeedbackBlue : kFeedbackBorder,
            width: isActive ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(8) : Radius.zero,
            right: !isLeft ? const Radius.circular(8) : Radius.zero,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? kFeedbackBlue : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// ── _ToRateList ───────────────────────────────────────────────────────────────

class _ToRateList extends StatelessWidget {
  final List<StudentToRateData> students;
  final ValueChanged<StudentToRateData> onRate;

  const _ToRateList({required this.students, required this.onRate});

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const Center(
        child: Text(
          'All students have been rated!',
          style: TextStyle(fontSize: 14, color: Colors.black45),
        ),
      );
    }
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (_, i) => FeedbackToRateCard(
        student: students[i],
        onRate: () => onRate(students[i]),
      ),
    );
  }
}

// ── _MyReviewsList ────────────────────────────────────────────────────────────

class _MyReviewsList extends StatelessWidget {
  final List<ReviewData> reviews;

  const _MyReviewsList({required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Center(
        child: Text(
          'No reviews yet.',
          style: TextStyle(fontSize: 14, color: Colors.black45),
        ),
      );
    }
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (_, i) => MyReviewsCard(review: reviews[i]),
    );
  }
}
