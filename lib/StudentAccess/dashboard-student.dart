import 'package:flutter/material.dart';
import 'menu-my_booking.dart';
import 'menu-find_tutors_student.dart';
import 'menu-feedback.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;

  // placeholder stats - in real app, these would be dynamic based on user data
  int upcomingSessions = 0;
  int pendingBookings = 0;
  int newMaterials = 0;

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

              // dashboard header with logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DASHBOARD",
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3d6fa5),
                        ),
                      ),
                      Text(
                        "Learn Smarter. Achieve Greater",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                  Image.asset(
                    "assets/images/tutophia-logo-white-outline.png",
                    height: 60,
                    errorBuilder: (c, e, s) =>
                        const Icon(Icons.school, size: 35),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // profile card with statistics
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xfff4a24c),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // profile card
                    Row(
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/icons/student_profile_placeholder.png",
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) =>
                                  const Icon(Icons.person, size: 40),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Student Name",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Student",
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              "Course",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // stats - to be change to dynamic values in app
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            upcomingSessions.toString(),
                            "Upcoming\nSessions",
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _statCard(
                            pendingBookings.toString(),
                            "Pending\nBookings",
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _statCard(
                            newMaterials.toString(),
                            "New\nMaterials",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // menu option gridi
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.2,
                children: [
                  _menuButton("Find Tutors", Icons.search, () {
                    //Navogate to Find Tutors Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FindTutors()),
                    );
                  }),

                  _menuButton("My Bookings", Icons.calendar_today, () {
                    //Navigate to My Bookings Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentBookingsScreen(),
                      ),
                    );
                  }),

                  _menuButton("Session Materials", Icons.menu_book, () {
                    // Will add function later
                  }),

                  _menuButton("Feedback", Icons.feedback, () {
                    //Navigate to Feedback Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackScreen()),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 15),

              // session history button
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xff3d6fa5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Session History",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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

      // bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xfff4a24c),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // stat card widget
  Widget _statCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff3d6fa5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // menu button widget
  Widget _menuButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff3d6fa5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
