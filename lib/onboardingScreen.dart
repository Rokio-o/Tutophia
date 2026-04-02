import 'package:flutter/material.dart';
import 'package:tutophia/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? const Color(0xFF3E72A7) : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: _onPageChanged,
                children: [_buildPage1(context), _buildPage2(context)],
              ),
            ),

            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_buildDot(0), _buildDot(1)],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ================= PAGE 1 =================
  Widget _buildPage1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          Center(
            child: Image.asset(
              'assets/images/onboard1-pic.png',
              height: MediaQuery.of(context).size.height * 0.35,
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Welcome to Tutophia',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A7DA5),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'A centralized platform where students and tutors connect to make learning easier, smarter, and more accessible.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF555555),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 30),

          _bullet('Students find the right tutors'),
          const SizedBox(height: 12),
          _bullet('Tutors share knowledge and guide learners'),

          const Spacer(),

          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E72A7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("NEXT"),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= PAGE 2 =================
  Widget _buildPage2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          Center(
            child: Image.asset(
              'assets/images/onboard2-pic.png',
              height: MediaQuery.of(context).size.height * 0.30,
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Learn, Teach, and Grow',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A7DA5),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Tutophia supports both students and tutors with tools to manage sessions, stay organized, and achieve better results.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF555555),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 30),

          _bullet('Book and manage tutoring sessions'),
          const SizedBox(height: 12),
          _bullet('Tutors can accept and handle bookings'),

          const Spacer(),

          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: _goToLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E72A7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("GET STARTED"),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Icon(Icons.circle, size: 5),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    );
  }
}
