import 'package:flutter/material.dart';
import 'package:tutophia/adminAccess/studentApplicationList.dart';
import 'package:tutophia/adminAccess/tutorApplicationList.dart';
import 'package:tutophia/login.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;

            double imageSize = screenWidth * 0.55;
            double buttonWidth = screenWidth * 0.75;

            if (imageSize > 220) imageSize = 220;
            if (buttonWidth > 320) buttonWidth = 320;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row: ADMIN title + owl logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ADMIN title + subtitle
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ADMIN",
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                color: const Color(0xFF386FA4),
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                              ),
                            ),
                            const Text(
                              "Manage Tutor and Student Applications",
                              style: TextStyle(
                                fontFamily: 'Arial',
                                color: Color(0xFF555555),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        // Owl logo
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: Image.asset(
                            'assets/images/tutophia-logo-white-outline.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF386FA4,
                                  ).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.school,
                                  color: Color(0xFF386FA4),
                                  size: 32,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    // Manage Student Applications
                    Center(
                      child: _buildOption(
                        context: context,
                        image: 'assets/images/student.png',
                        buttonText: "MANAGE STUDENT\nAPPLICATIONS",
                        imageSize: imageSize,
                        buttonWidth: buttonWidth,
                        onPressed: () {
                          // Navigate to manage student applications screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const StudentApplicationListScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Manage Tutor Applications
                    Center(
                      child: _buildOption(
                        context: context,
                        image: 'assets/images/tutor.png',
                        buttonText: "MANAGE TUTOR\nAPPLICATIONS",
                        imageSize: imageSize,
                        buttonWidth: buttonWidth,
                        onPressed: () {
                          // Navigate to manage tutor applications screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TutorApplicationListScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.06),

                    // Logout button aligned to bottom-right
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 110,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            _showLogoutConfirmation(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8622A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom padding for comfortable scrolling
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required String image,
    required String buttonText,
    required double imageSize,
    required double buttonWidth,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        // Illustration image
        SizedBox(
          width: imageSize,
          height: imageSize,
          child: Image.asset(
            image,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  buttonText.contains("STUDENT")
                      ? Icons.laptop_mac
                      : Icons.groups,
                  size: imageSize * 0.4,
                  color: const Color(0xFF386FA4).withOpacity(0.5),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Action button
        SizedBox(
          width: buttonWidth,
          height: 56,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF386FA4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Confirm Logout",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF386FA4),
            ),
          ),
          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _logout(context); // Perform logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8622A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
