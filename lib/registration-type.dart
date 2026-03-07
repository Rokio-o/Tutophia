import 'package:flutter/material.dart';
import 'StudentAccess/registration1-student.dart';
import 'TutorAccess/registration1-tutor.dart';
import 'login.dart';

class RegistrationType extends StatelessWidget {
  const RegistrationType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      // App Bar with back arrow
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;

            // Calculate responsive sizes
            double titleSize = screenWidth * 0.08;
            double imageSize = screenWidth * 0.45;
            double buttonWidth = screenWidth * 0.7;

            // Ensure minimum and maximum sizes
            if (imageSize > 200) imageSize = 200;
            if (buttonWidth > 300) buttonWidth = 300;
            if (titleSize > 36) titleSize = 36;

            return Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        "REGISTRATION",
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          color: const Color(0xFF386FA4),
                          fontWeight: FontWeight.bold,
                          fontSize: titleSize,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Select Registration Type",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Color(0xFF0F0F0F),
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      // Student Option
                      _buildOption(
                        context: context,
                        image: 'assets/images/student.png',
                        buttonText: "REGISTER AS A STUDENT",
                        imageSize: imageSize,
                        buttonWidth: buttonWidth,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const StudentRegistration1(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      // Tutor Option
                      _buildOption(
                        context: context,
                        image: 'assets/images/tutor.png',
                        buttonText: "REGISTER AS A TUTOR",
                        imageSize: imageSize,
                        buttonWidth: buttonWidth,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TutorRegistration1(),
                            ),
                          );
                        },
                      ),

                      // Extra bottom padding for small screens
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Reusable option widget
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
        // Image - no circle shape, just square/rectangle
        SizedBox(
          width: imageSize,
          height: imageSize,
          child: Image.asset(
            image,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade200,
                child: Icon(
                  buttonText.contains("STUDENT") ? Icons.school : Icons.person,
                  size: imageSize * 0.4,
                  color: const Color(0xFF386FA4).withOpacity(0.5),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Button
        SizedBox(
          width: buttonWidth,
          height: 50,
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
