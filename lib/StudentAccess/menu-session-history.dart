import 'package:flutter/material.dart';

class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({super.key});

  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  bool _isExpanded = false;

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

              // Back button — black, above title
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
              ),

              const SizedBox(height: 12),

              // Header title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SESSION HISTORY",
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3d6fa5),
                        ),
                      ),
                      Text(
                        "View your study sessions for reference",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                  Image.asset(
                    "assets/images/tutophia-logo-white-outline.png",
                    height: 50,
                    errorBuilder: (c, e, s) =>
                        const Icon(Icons.school, size: 35),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Tab bar (static UI)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xffe0e0e0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Session History",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Single session card — Jeancess Gallo
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xfffff8f2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xffe0d6cc)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffcccccc),
                            ),
                            child: const Icon(Icons.person,
                                size: 35, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Jeancess Gallo",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              Text("Student Tutor",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54)),
                              Text("Program: Computer Science",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54)),
                              Text("Date Completed: 02/23/26",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54)),
                            ],
                          ),
                        ],
                      ),

                      if (_isExpanded) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffcccccc),
                          ),
                          child: const Icon(Icons.person,
                              size: 50, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Jeancess Gallo",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const Text("Student Tutor",
                            style: TextStyle(
                                fontSize: 12, color: Colors.black54)),
                        const Text("Program: Computer Science",
                            style: TextStyle(
                                fontSize: 12, color: Colors.black54)),
                        const SizedBox(height: 16),
                        _detailRow("Mode:", "Online Tutoring"),
                        const SizedBox(height: 8),
                        _detailRow("Subject:", "Linear Algebra"),
                        const SizedBox(height: 8),
                        _detailRow("Date:", "Monday, February 23 2026"),
                        const SizedBox(height: 8),
                        _detailRow("Session Duration:", "2 hours"),
                        const SizedBox(height: 8),
                        _detailRow("Time:", "5:00 pm - 7:00 pm"),
                        const SizedBox(height: 8),
                        _detailRow("Fee:", "₱ 120.00"),
                      ],

                      const SizedBox(height: 10),
                      Text(
                        _isExpanded ? "Click to Collapse" : "Click to expand",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black38,
                          fontStyle: FontStyle.italic,
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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xfff4a24c),
        unselectedItemColor: Colors.grey,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notification"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xfff4a24c),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xffe0e0e0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}