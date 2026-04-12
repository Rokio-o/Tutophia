import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutophia/models/student-model/feedback_data.dart';
import 'package:tutophia/data/student-data/feedback_repository.dart';
import 'package:tutophia/widgets/student-widgets/reviews_list.dart';
import 'package:tutophia/widgets/student-widgets/to_rate_list.dart';
import 'package:tutophia/widgets/student-widgets/tutor-advice_list.dart';
import 'package:tutophia/widgets/student-widgets/header-student-wgt.dart';
import 'package:tutophia/widgets/student-widgets/bottom-navigation-student.dart';
import 'package:tutophia/StudentAccess/notifications-student.dart';
import 'package:tutophia/StudentAccess/profile-student.dart';
import 'package:tutophia/StudentAccess/dashboard-student.dart';

// ── Tab Enum ──────────────────────────────────────────────────────────────────

enum _FeedbackTab { toRate, myReviews, tutorAdvice }

// ── FeedbackScreen ────────────────────────────────────────────────────────────

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  _FeedbackTab _activeTab = _FeedbackTab.toRate;
  final StudentFeedbackRepository _repository =
      StudentFeedbackRepository.instance;

  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0;

  bool _isRatingMode = false;
  bool _isSaving = false;
  ToRateData? _selectedTutor;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // ---------- RATING FLOW ----------

  void _startRating(ToRateData tutor) {
    setState(() {
      _isRatingMode = true;
      _selectedTutor = tutor;
      _selectedRating = 0;
      _commentController.clear();
    });
  }

  void _goBackFromRating() {
    setState(() {
      _isRatingMode = false;
      _selectedTutor = null;
      _selectedRating = 0;
      _commentController.clear();
    });
  }

  Future<void> _saveReview() async {
    if (_selectedTutor == null) return;
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating first.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _repository.submitReview(
        tutor: _selectedTutor!,
        rating: _selectedRating,
        comment: _commentController.text.trim(),
      );
      if (!mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xff3d6fa5), width: 1),
            ),
            content: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Your review has\nbeen saved!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff3d6fa5),
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.only(bottom: 20),
            actions: [
              SizedBox(
                width: 90,
                height: 36,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffbdbdbd),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Okay',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isRatingMode = false;
        _selectedTutor = null;
        _selectedRating = 0;
        _commentController.clear();
        _activeTab = _FeedbackTab.myReviews;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // ---------- STAR ROW ----------

  Widget _buildStarRow() {
    return Row(
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            setState(() {
              _selectedRating = starIndex;
            });
          },
          icon: Icon(
            _selectedRating >= starIndex ? Icons.star : Icons.star_border,
            color: _selectedRating >= starIndex
                ? Colors.amber
                : Colors.grey.shade500,
            size: 34,
          ),
        );
      }),
    );
  }

  // ---------- RATING FORM ----------

  Widget _buildRatingForm() {
    final tutor = _selectedTutor;
    if (tutor == null) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 24),
        const CircleAvatar(
          radius: 42,
          backgroundColor: Colors.transparent,
          child: Icon(Icons.account_circle, size: 90, color: Colors.black54),
        ),
        const SizedBox(height: 12),
        Text(
          tutor.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          tutor.role,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 42),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Rate the tutor performance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerLeft, child: _buildStarRow()),
        const SizedBox(height: 22),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Add a comment',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _commentController,
          maxLines: 4,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xff8a5a5a)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xff8a5a5a)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xff3d6fa5),
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: _goBackFromRating,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfff3ebeb),
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Go back',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3d6fa5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isSaving ? 'Saving...' : 'Save',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- BODY CONTENT ----------

  Widget _buildBodyContent(String studentId) {
    if (_activeTab == _FeedbackTab.toRate && _isRatingMode) {
      return _buildRatingForm();
    }
    if (_activeTab == _FeedbackTab.toRate) {
      return StreamBuilder<List<ToRateData>>(
        stream: _repository.watchToRate(studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'Error loading tutors to rate: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          return FeedbackToRateList(
            items: snapshot.data ?? const <ToRateData>[],
            onRateTap: _startRating,
          );
        },
      );
    }
    if (_activeTab == _FeedbackTab.myReviews) {
      return StreamBuilder<List<ReviewData>>(
        stream: _repository.watchMyReviews(studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'Error loading your reviews: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          return FeedbackReviewsList(
            reviews: snapshot.data ?? const <ReviewData>[],
          );
        },
      );
    }
    return StreamBuilder<List<TutorAdviceData>>(
      stream: _repository.watchTutorAdvice(studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Error loading tutor advice: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          );
        }

        return TutorAdviceList(
          adviceList: snapshot.data ?? const <TutorAdviceData>[],
        );
      },
    );
  }

  // ---------- BUILD ----------

  @override
  Widget build(BuildContext context) {
    final studentId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        backgroundColor: const Color(0xfff4f4f4),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_isRatingMode) {
              _goBackFromRating();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Feedback Header ──
              const HeaderStudentWdgt.feedback(),

              const SizedBox(height: 20),

              // ── 3-Tab Bar ──
              _FeedbackTabBar(
                active: _activeTab,
                onTabChanged: (tab) => setState(() {
                  _activeTab = tab;
                  _isRatingMode = false;
                }),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: studentId == null
                    ? const Center(
                        child: Text(
                          'Please log in to access feedback.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                      )
                    : SingleChildScrollView(
                        child: _buildBodyContent(studentId),
                      ),
              ),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation ──
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
            position: _TabPosition.left,
            onTap: () => onTabChanged(_FeedbackTab.toRate),
          ),
        ),
        Expanded(
          child: _TabButton(
            label: 'My Reviews',
            isActive: active == _FeedbackTab.myReviews,
            position: _TabPosition.middle,
            onTap: () => onTabChanged(_FeedbackTab.myReviews),
          ),
        ),
        Expanded(
          child: _TabButton(
            label: "Tutor's Advice",
            isActive: active == _FeedbackTab.tutorAdvice,
            position: _TabPosition.right,
            onTap: () => onTabChanged(_FeedbackTab.tutorAdvice),
          ),
        ),
      ],
    );
  }
}

// ── Tab Position Enum ─────────────────────────────────────────────────────────

enum _TabPosition { left, middle, right }

// ── _TabButton ────────────────────────────────────────────────────────────────

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
            color: isActive ? const Color(0xff3d6fa5) : const Color(0xFFE0E0E0),
            width: isActive ? 1.5 : 1.0,
          ),
          borderRadius: borderRadius,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? const Color(0xff3d6fa5) : Colors.black87,
          ),
        ),
      ),
    );
  }
}
