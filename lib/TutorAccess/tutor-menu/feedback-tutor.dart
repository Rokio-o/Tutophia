import 'package:flutter/material.dart';
import 'package:tutophia/widgets/tutor-widgets/header-tutor-wdgt.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/feedback-to-rate-card.dart';
import 'package:tutophia/widgets/tutor-widgets/my-feedback-card.dart';
import 'package:tutophia/TutorAccess/give-feedback.dart';
import 'package:tutophia/models/tutor-model/feedback-tutor-data.dart';
import 'package:tutophia/data/tutor-data/feedback-tutor-repository.dart';
import 'package:tutophia/widgets/tutor-widgets/feedback_constants.dart';
import 'package:tutophia/widgets/tutor-widgets/student-to-rate-card.dart';

// ── Tab Enum ──────────────────────────────────────────────────────────────────

enum _FeedbackTab { giveFeedback, myFeedback, studentsFeedback }

// ── FeedbackTutorScreen ───────────────────────────────────────────────────────

class FeedbackTutorScreen extends StatefulWidget {
  const FeedbackTutorScreen({super.key});

  @override
  State<FeedbackTutorScreen> createState() => _FeedbackTutorScreenState();
}

class _FeedbackTutorScreenState extends State<FeedbackTutorScreen> {
  _FeedbackTab _activeTab = _FeedbackTab.giveFeedback;

  late List<StudentToRateData> _studentsToRate;
  late List<TutorFeedbackGivenData> _myFeedback;
  late List<StudentRatingData> _studentRatings;

  @override
  void initState() {
    super.initState();
    _studentsToRate = List.from(sampleStudentsToRate);
    _myFeedback = List.from(sampleFeedbackGiven);
    _studentRatings = List.from(sampleStudentRatings);
  }

  void _openGiveFeedbackScreen(StudentToRateData student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GiveFeedbackScreen(
          student: student,
          onSave: (feedback) {
            setState(() {
              _studentsToRate.removeWhere((s) => s.id == student.id);
              _myFeedback.insert(
                0,
                TutorFeedbackGivenData(
                  id: student.id,
                  studentName: student.name,
                  program: student.program,
                  imagePath: student.imagePath,
                  feedback: feedback,
                ),
              );
              _activeTab = _FeedbackTab.myFeedback;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Feedback saved!')));
          },
        ),
      ),
    );
  }

  // ---------- BODY CONTENT ----------

  Widget _buildBodyContent() {
    switch (_activeTab) {
      case _FeedbackTab.giveFeedback:
        return _GiveFeedbackList(
          students: _studentsToRate,
          onGiveFeedback: _openGiveFeedbackScreen,
        );
      case _FeedbackTab.myFeedback:
        return _MyFeedbackList(feedbackList: _myFeedback);
      case _FeedbackTab.studentsFeedback:
        return _StudentsFeedbackList(ratings: _studentRatings);
    }
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

            // ── 3-Tab Bar ──
            _FeedbackTabBar(
              active: _activeTab,
              onTabChanged: (tab) => setState(() => _activeTab = tab),
            ),

            const SizedBox(height: 16),

            Expanded(child: _buildBodyContent()),
          ],
        ),
      ),

      // ── Bottom Navigation ──
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (_) {},
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
            label: 'Give Feedback',
            isActive: active == _FeedbackTab.giveFeedback,
            position: _TabPosition.left,
            onTap: () => onTabChanged(_FeedbackTab.giveFeedback),
          ),
        ),
        Expanded(
          child: _TabButton(
            label: 'My Feedback',
            isActive: active == _FeedbackTab.myFeedback,
            position: _TabPosition.middle,
            onTap: () => onTabChanged(_FeedbackTab.myFeedback),
          ),
        ),
        Expanded(
          child: _TabButton(
            label: "Student's Feedback",
            isActive: active == _FeedbackTab.studentsFeedback,
            position: _TabPosition.right,
            onTap: () => onTabChanged(_FeedbackTab.studentsFeedback),
          ),
        ),
      ],
    );
  }
}

// ── Tab Position ──────────────────────────────────────────────────────────────

enum _TabPosition { left, middle, right }

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final _TabPosition position;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.position,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    switch (position) {
      case _TabPosition.left:
        borderRadius = const BorderRadius.horizontal(left: Radius.circular(8));
        break;
      case _TabPosition.middle:
        borderRadius = BorderRadius.zero;
        break;
      case _TabPosition.right:
        borderRadius = const BorderRadius.horizontal(right: Radius.circular(8));
        break;
    }

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
          borderRadius: borderRadius,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? kFeedbackBlue : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// ── _GiveFeedbackList ─────────────────────────────────────────────────────────

class _GiveFeedbackList extends StatelessWidget {
  final List<StudentToRateData> students;
  final ValueChanged<StudentToRateData> onGiveFeedback;

  const _GiveFeedbackList({
    required this.students,
    required this.onGiveFeedback,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const Center(
        child: Text(
          'All students have received feedback!',
          style: TextStyle(fontSize: 14, color: Colors.black45),
        ),
      );
    }
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (_, i) => FeedbackToRateCard(
        student: students[i],
        onGiveFeedback: () => onGiveFeedback(students[i]),
      ),
    );
  }
}

// ── _MyFeedbackList ───────────────────────────────────────────────────────────

class _MyFeedbackList extends StatelessWidget {
  final List<TutorFeedbackGivenData> feedbackList;

  const _MyFeedbackList({required this.feedbackList});

  @override
  Widget build(BuildContext context) {
    if (feedbackList.isEmpty) {
      return const Center(
        child: Text(
          'No feedback given yet.',
          style: TextStyle(fontSize: 14, color: Colors.black45),
        ),
      );
    }
    return ListView.builder(
      itemCount: feedbackList.length,
      itemBuilder: (_, i) => MyFeedbackCard(feedback: feedbackList[i]),
    );
  }
}

// ── _StudentsFeedbackList ─────────────────────────────────────────────────────

class _StudentsFeedbackList extends StatelessWidget {
  final List<StudentRatingData> ratings;

  const _StudentsFeedbackList({required this.ratings});

  @override
  Widget build(BuildContext context) {
    if (ratings.isEmpty) {
      return const Center(
        child: Text(
          'No student ratings yet.',
          style: TextStyle(fontSize: 14, color: Colors.black45),
        ),
      );
    }
    return ListView.builder(
      itemCount: ratings.length,
      itemBuilder: (_, i) => StudentRatingCard(rating: ratings[i]),
    );
  }
}
