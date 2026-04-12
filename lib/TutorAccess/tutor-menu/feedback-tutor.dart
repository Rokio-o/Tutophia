import 'package:firebase_auth/firebase_auth.dart';
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

enum FeedbackTutorInitialTab { giveFeedback, myFeedback, studentsFeedback }

// ── FeedbackTutorScreen ───────────────────────────────────────────────────────

class FeedbackTutorScreen extends StatefulWidget {
  final FeedbackTutorInitialTab initialTab;

  const FeedbackTutorScreen({
    super.key,
    this.initialTab = FeedbackTutorInitialTab.giveFeedback,
  });

  @override
  State<FeedbackTutorScreen> createState() => _FeedbackTutorScreenState();
}

class _FeedbackTutorScreenState extends State<FeedbackTutorScreen> {
  late FeedbackTutorInitialTab _activeTab;
  final TutorFeedbackRepository _repository = TutorFeedbackRepository.instance;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  Future<void> _openGiveFeedbackScreen(StudentToRateData student) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => GiveFeedbackScreen(
          student: student,
          onSave: (feedback) => _repository.submitTutorFeedback(
            student: student,
            advice: feedback,
          ),
        ),
      ),
    );

    if (saved == true && mounted) {
      setState(() => _activeTab = FeedbackTutorInitialTab.myFeedback);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Feedback saved!')));
    }
  }

  // ---------- BODY CONTENT ----------

  Widget _buildBodyContent(String tutorId) {
    switch (_activeTab) {
      case FeedbackTutorInitialTab.giveFeedback:
        return StreamBuilder<List<StudentToRateData>>(
          stream: _repository.watchStudentsPendingFeedback(tutorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading pending feedback: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }

            return _GiveFeedbackList(
              students: snapshot.data ?? const <StudentToRateData>[],
              onGiveFeedback: _openGiveFeedbackScreen,
            );
          },
        );
      case FeedbackTutorInitialTab.myFeedback:
        return StreamBuilder<List<TutorFeedbackGivenData>>(
          stream: _repository.watchFeedbackGiven(tutorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading feedback given: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }

            return _MyFeedbackList(
              feedbackList: snapshot.data ?? const <TutorFeedbackGivenData>[],
            );
          },
        );
      case FeedbackTutorInitialTab.studentsFeedback:
        return StreamBuilder<List<StudentRatingData>>(
          stream: _repository.watchStudentRatings(tutorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading student ratings: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }

            return _StudentsFeedbackList(
              ratings: snapshot.data ?? const <StudentRatingData>[],
            );
          },
        );
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
            const HeaderTutorWdgt.feedback(),
            const SizedBox(height: 20),

            // ── 3-Tab Bar ──
            _FeedbackTabBar(
              active: _activeTab,
              onTabChanged: (tab) => setState(() => _activeTab = tab),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: tutorId == null
                  ? const Center(
                      child: Text(
                        'Please log in to access feedback.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                      ),
                    )
                  : _buildBodyContent(tutorId),
            ),
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
  final FeedbackTutorInitialTab active;
  final ValueChanged<FeedbackTutorInitialTab> onTabChanged;

  const _FeedbackTabBar({required this.active, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabButton(
            label: 'Give Feedback',
            isActive: active == FeedbackTutorInitialTab.giveFeedback,
            position: _TabPosition.left,
            onTap: () => onTabChanged(FeedbackTutorInitialTab.giveFeedback),
          ),
        ),
        Expanded(
          child: _TabButton(
            label: 'My Feedback',
            isActive: active == FeedbackTutorInitialTab.myFeedback,
            position: _TabPosition.middle,
            onTap: () => onTabChanged(FeedbackTutorInitialTab.myFeedback),
          ),
        ),
        Expanded(
          child: _TabButton(
            label: "Student's Feedback",
            isActive: active == FeedbackTutorInitialTab.studentsFeedback,
            position: _TabPosition.right,
            onTap: () => onTabChanged(FeedbackTutorInitialTab.studentsFeedback),
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
