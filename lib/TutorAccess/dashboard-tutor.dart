import 'package:flutter/material.dart';

class TutorDashboard extends StatefulWidget {
  const TutorDashboard({super.key});

  @override
  State<TutorDashboard> createState() => _TutorDashboardState();
}

class _TutorDashboardState extends State<TutorDashboard> {
  int _selectedIndex = 0;

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

              // Header with Dashboard title and subtitle
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DASHBOARD",
                    style: TextStyle(
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

              const SizedBox(height: 30),

              // Tutor Profile Section
              Row(
                children: [
                  // Profile Image Placeholder
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icons/tutor_profile_placeholder.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  // Tutor Info
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jeanne Galle",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Student Tutor",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Computer Science",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Stats Cards Row
              Row(
                children: [
                  // Upcoming Sessions Card
                  Expanded(
                    child: _buildStatCard(
                      "2",
                      "Upcoming Sessions",
                      Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Booking Requests Card
                  Expanded(
                    child: _buildStatCard(
                      "4",
                      "Booking Requests",
                      Icons.pending_actions,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Menu Grid Section with custom icons
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.2,
                children: [
                  _buildMenuItemWithCustomIcon(
                    "Session Requests",
                    'assets/icons/find-tutors.png',
                    () {},
                  ),
                  _buildMenuItemWithCustomIcon(
                    "Upload Materials",
                    'assets/icons/upload_materials.png',
                    () {},
                  ),
                  _buildMenuItemWithCustomIcon(
                    "Session History",
                    'assets/icons/session_history.png',
                    () {},
                  ),
                  _buildMenuItemWithCustomIcon(
                    "Feedback",
                    'assets/icons/feedback.png',
                    () {},
                  ),
                ],
              ),

              const SizedBox(height: 80), // Extra space for bottom navigation
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar with custom icons
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFF9AB55),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/home_icon.png',
                width: 24,
                height: 24,
                color: _selectedIndex == 0 ? null : Colors.grey,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.home,
                    color: _selectedIndex == 0
                        ? const Color(0xFFF9AB55)
                        : Colors.grey,
                  );
                },
              ),
              activeIcon: Image.asset(
                'assets/icons/home_icon.png',
                width: 24,
                height: 24,
                color: const Color(0xFFF9AB55),
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.home, color: Color(0xFFF9AB55));
                },
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/notification_icon.png',
                width: 24,
                height: 24,
                color: _selectedIndex == 1 ? null : Colors.grey,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.notifications,
                    color: _selectedIndex == 1
                        ? const Color(0xFFF9AB55)
                        : Colors.grey,
                  );
                },
              ),
              activeIcon: Image.asset(
                'assets/icons/notification_icon.png',
                width: 24,
                height: 24,
                color: const Color(0xFFF9AB55),
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.notifications,
                    color: Color(0xFFF9AB55),
                  );
                },
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/profile_icon.png',
                width: 24,
                height: 24,
                color: _selectedIndex == 2 ? null : Colors.grey,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    color: _selectedIndex == 2
                        ? const Color(0xFFF9AB55)
                        : Colors.grey,
                  );
                },
              ),
              activeIcon: Image.asset(
                'assets/icons/profile_icon.png',
                width: 24,
                height: 24,
                color: const Color(0xFFF9AB55),
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, color: Color(0xFFF9AB55));
                },
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build stat cards
  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xff3d6fa5), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xff3d6fa5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // Helper method to build menu items with custom icons
  Widget _buildMenuItemWithCustomIcon(
    String title,
    String iconPath,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 40,
              height: 40,
              color: const Color(0xff3d6fa5),
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 32, color: Colors.grey.shade400);
              },
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
