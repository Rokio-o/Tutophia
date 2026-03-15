import 'package:flutter/material.dart';

class TutorDashboard extends StatefulWidget {
  const TutorDashboard({super.key});

  @override
  State<TutorDashboard> createState() => _TutorDashboardState();
}

class _TutorDashboardState extends State<TutorDashboard> {
  int _selectedIndex = 0;

  // placeholder stats - in app, these would be dynamic based on user data
  int upcomingSessions = 0;
  int bookingRequests = 0;

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
                        "Empower Minds Through Mentorship",
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
                    // profile
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
                              "assets/icons/tutor_profile.png",
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
                              "Tutor Name",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            Text(
                              "Student Tutor",
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

                    // stats
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            upcomingSessions.toString(),
                            "Upcoming\nSessions",
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: _statCard(
                            bookingRequests.toString(),
                            "Booking\nRequests",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // menu grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.2,
                children: [
                  _menuButton("Session Requests", Icons.class_),

                  _menuButton("Upload Materials", Icons.upload_file),

                  _menuButton("Session History", Icons.history),

                  _menuButton("Feedback", Icons.star_outline),
                ],
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // bottom navigation bar
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
            label: "Notifications",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // stats
  Widget _statCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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

          const SizedBox(height: 6),

          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  // menu buttons
  Widget _menuButton(String title, IconData icon) {
    return GestureDetector(
      onTap: () {},

      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff3d6fa5),
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),

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
