import 'package:flutter/material.dart';
import 'package:tutophia/TutorAccess/terms-condition-tutor.dart';
import 'registration2-tutor.dart';

class TutorRegistration3 extends StatefulWidget {
  const TutorRegistration3({super.key});

  @override
  State<TutorRegistration3> createState() => _TutorRegistration3State();
}

class _TutorRegistration3State extends State<TutorRegistration3> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final OutlineInputBorder borderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),

      // back arrow
      appBar: AppBar(
        backgroundColor: const Color(0xfff3f3f3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TutorRegistration2()),
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CREATE ACCOUNT title
            const Text(
              "CREATE ACCOUNT",
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xff3d6fa5),
              ),
            ),

            const SizedBox(height: 5),

            // Tutor Registration subtitle
            const Text(
              "Tutor Registration",
              style: TextStyle(color: Colors.black54, fontFamily: 'Arial'),
            ),

            const SizedBox(height: 40),

            // Account Creation section
            const Text(
              "Account Creation",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 25),

            // Username
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Username",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter your username",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Password
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter your password",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Confirm Password
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Confirm Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  obscureText: obscureConfirmPassword,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Confirm your password",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Divider line
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),

            const SizedBox(height: 30),

            // NEXT button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3d6fa5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsandConditionsTutor(),
                    ),
                  );
                },
                child: const Text(
                  "NEXT",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Login link
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigate to login screen
                  Navigator.pop(context);
                },
                child: RichText(
                  text: const TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.black54),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          color: Color(0xff3d6fa5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
