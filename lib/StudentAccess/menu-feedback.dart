import 'package:flutter/material.dart';
import 'package:tutophia/widgets/student-widgets/reviews_list.dart';
import 'package:tutophia/widgets/student-widgets/to_rate_list.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _selectedTab = 0; // 0 = To Rate, 1 = My Reviews
  int _selectedBottomNavIndex = 0;

  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0;

  // Controls if user is currently rating someone
  bool _isRatingMode = false;

  // Selected tutor for rating
  Map<String, String>? _selectedTutor;

  // Sample tutors to rate
  final List<Map<String, String>> _toRateList = [
    {'name': 'Jeancess Gallo', 'role': 'Student Tutor'},
    {'name': 'Lawrence Malaga', 'role': 'Student Tutor'},
  ];

  // Sample reviews
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Juliana Aura Fortu',
      'rating': 5,
      'comment': 'Attentive and interested to the session',
    },
    {
      'name': 'Chilldon Paul Carreon',
      'rating': 4,
      'comment': 'A little bit late to the session but it ends very well',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _startRating(Map<String, String> tutor) {
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

  void _saveReview() {
    if (_selectedTutor == null) return;

    showDialog(
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
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _reviews.insert(0, {
                      'name': _selectedTutor!['name']!,
                      'rating': _selectedRating,
                      'comment': _commentController.text.trim(),
                    });

                    _toRateList.removeWhere(
                      (item) => item['name'] == _selectedTutor!['name'],
                    );

                    _isRatingMode = false;
                    _selectedTutor = null;
                    _selectedRating = 0;
                    _commentController.clear();
                    _selectedTab = 1;
                  });
                },
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
  }

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

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FEEDBACK',
                style: TextStyle(
                  color: Color(0xff3d6fa5),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Review tutor advice and put your rating',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
        Image.asset(
          'assets/images/tutophia-logo-white-outline.png',
          height: 55,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.school, size: 48, color: Color(0xfff4a24c));
          },
        ),
      ],
    );
  }

  Widget _buildTabButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildTabButton(
            label: 'To Rate',
            isActive: _selectedTab == 0,
            onTap: () {
              setState(() {
                _selectedTab = 0;
                _isRatingMode = false;
              });
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildTabButton(
            label: 'My Reviews',
            isActive: _selectedTab == 1,
            onTap: () {
              setState(() {
                _selectedTab = 1;
                _isRatingMode = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 42,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: isActive ? const Color(0xffdbe5f1) : Colors.white,
          side: const BorderSide(color: Color(0xff8a5a5a)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
    );
  }

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
          tutor['name'] ?? '',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          tutor['role'] ?? '',
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
                  onPressed: _saveReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3d6fa5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBodyContent() {
    if (_selectedTab == 0 && _isRatingMode) {
      return _buildRatingForm();
    }

    if (_selectedTab == 0) {
      return FeedbackToRateList(items: _toRateList, onRateTap: _startRating);
    }

    return FeedbackReviewsList(reviews: _reviews);
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTabButtons(),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(child: _buildBodyContent()),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
        },
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
