import 'package:flutter/material.dart';
import 'package:tutophia/TutorAccess/registration3-tutor.dart';
import 'package:tutophia/TutorAccess/registration1-tutor.dart';

class TutorRegistration2 extends StatefulWidget {
  const TutorRegistration2({super.key});

  @override
  State<TutorRegistration2> createState() => _TutorRegistration2State();
}

class _TutorRegistration2State extends State<TutorRegistration2> {
  String? selectedTutoringMode;
  String? sessionRateMode = 'Per Hour';
  bool onlineSelected = false;
  bool faceToFaceSelected = false;
  bool hybridSelected = false;

  final OutlineInputBorder borderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  );

  List<String> rateModes = ['Per Hour', 'Per Session', 'Per Day', 'Per Month'];

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
              MaterialPageRoute(builder: (context) => TutorRegistration1()),
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

            const SizedBox(height: 30),

            // Service Setup section
            const Text(
              "Service Setup",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // Mode of Tutoring
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Mode of Tutoring",
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
                const SizedBox(height: 10),

                // Online checkbox
                Row(
                  children: [
                    Checkbox(
                      value: onlineSelected,
                      activeColor: Color(0xFFF9AB55),
                      onChanged: (value) {
                        setState(() {
                          onlineSelected = value ?? false;
                        });
                      },
                    ),
                    const Text("Online", style: TextStyle(fontSize: 14)),
                  ],
                ),

                // Face-to-Face checkbox
                Row(
                  children: [
                    Checkbox(
                      value: faceToFaceSelected,
                      activeColor: Color(0xFFF9AB55),
                      onChanged: (value) {
                        setState(() {
                          faceToFaceSelected = value ?? false;
                        });
                      },
                    ),
                    const Text("Face-to-Face", style: TextStyle(fontSize: 14)),
                  ],
                ),

                // Hybrid checkbox
                Row(
                  children: [
                    Checkbox(
                      value: hybridSelected,
                      activeColor: Color(0xFFF9AB55),
                      onChanged: (value) {
                        setState(() {
                          hybridSelected = value ?? false;
                        });
                      },
                    ),
                    const Text("Hybrid", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Preferred Session Duration
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Preferred Session Duration",
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
                    hintText:
                        "Enter your preferred session duration (in hours)",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // session rate
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Session Rate",
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

                // Row with text field and mode dropdown
                Row(
                  children: [
                    // Rate input field - takes half
                    Expanded(
                      flex: 1,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: borderStyle,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          hintText: "Enter amount",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixText: '₱ ',
                          prefixStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Mode dropdown - takes half (no default value)
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: borderStyle,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          hintText: 'Select mode',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        value: null, // No default value
                        items: rateModes.map((mode) {
                          return DropdownMenuItem(
                            value: mode,
                            child: Text(mode),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            sessionRateMode = value as String;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Available Schedule
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Available Schedule",
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
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    hintText:
                        "Enter or list your preferred schedule for tutoring (eg., Monday - 1:00pm to 3:00pm)",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Links for documented schedule
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Links for documented schedule",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText:
                        "You can put a link for excel/document regarding your detailed or updated schedule",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Contact Information section
            const Text(
              "Contact Information",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // Email Address
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Email Address",
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter your email address",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Contact Number
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Contact Number",
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
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter your contact number",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Other Accounts text
            const Text(
              "Other Accounts",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 15),

            // Messenger
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Messenger",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter messenger account link",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Instagram
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Instagram",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter instagram account link",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Others
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Others",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter other accounts",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
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
                      builder: (context) => TutorRegistration3(),
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
