import 'package:flutter/material.dart';
import 'package:tutophia/StudentAccess/registration2-student.dart';
import 'package:tutophia/successful-reg.dart';

class TermsandConditionsStudent extends StatefulWidget {
  const TermsandConditionsStudent({super.key});

  @override
  State<TermsandConditionsStudent> createState() =>
      TermsandConditionsStudentState();
}

class TermsandConditionsStudentState extends State<TermsandConditionsStudent> {
  final List<bool> isChecked = List.generate(10, (index) => false);

  // List of terms and conditions content
  final List<Map<String, String>> termsContent = [
    {
      'Term': 'Eligibility',
      'Condition':
          'You must be a currently enrolled college student and provide valid academic information for verification.',
    },
    {
      'Term': 'Accurate Information',
      'Condition':
          'You must provide true, complete, and updated personal and academic details. False information may lead to account suspension.',
    },
    {
      'Term': 'One Account Per Student',
      'Condition':
          'Each student is allowed only one account. Duplicate or shared accounts are strictly prohibited.',
    },
    {
      'Term': 'Responsible Booking',
      'Condition':
          'You agree to book sessions responsibly, attend scheduled sessions on time, and avoid repeated cancellations or no-shows.',
    },
    {
      'Term': 'Proper Conduct',
      'Condition':
          'You must communicate respectfully with tutors. Harassment, academic dishonesty, or misuse of the platform is not allowed.',
    },
    {
      'Term': 'Use of Learning Modules',
      'Condition':
          'Materials shared by tutors are for personal academic use only. Redistribution or unauthorized sharing is prohibited.',
    },
    {
      'Term': 'Payment Compliance (If Applicable)',
      'Condition':
          'All payments must be processed through the official Tutophia system. Off-platform transactions are discouraged.',
    },
    {
      'Term': 'Feedback Integrity',
      'Condition':
          'You may leave honest and respectful feedback. False, abusive, or misleading reviews are prohibited.',
    },
    {
      'Term': 'Privacy Agreement',
      'Condition':
          'Your personal information will be used only for educational and platform-related purposes.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // back arrow
      appBar: AppBar(
        backgroundColor: const Color(0xfff3f3f3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentRegistration2()),
            );
          },
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const Text(
                  'TERMS & CONDITIONS',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF386FA4),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'By registering as a student on TUTOPHIA, you agree to the following terms:',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                const SizedBox(height: 20),

                // Generate list of terms
                ...termsContent.asMap().entries.map((entry) {
                  int index = entry.key;
                  return buildTermItem(
                    index,
                    entry.value['Term']!,
                    entry.value['Condition']!,
                  );
                }).toList(),

                // Final agreement checkbox (Index 9)
                buildTermItem(
                  9,
                  'I AGREE TO ALL TERMS AND CONDITIONS',
                  'By checking this, you agree to all terms and conditions.',
                ),

                // Create account button scrollable list
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isChecked[9]
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SuccessfulRegistration(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF386FA4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'CREATE ACCOUNT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTermItem(int index, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: isChecked[index],
              activeColor: const Color(0xFFF9AB55),
              checkColor: Colors.white,
              onChanged: (val) {
                setState(() {
                  isChecked[index] = val!;
                  if (index == 9) {
                    // Global toggle logic
                    for (int i = 0; i < isChecked.length; i++) {
                      isChecked[i] = val;
                    }
                  } else {
                    // If one is unchecked, "Agree All" becomes unchecked
                    if (val == false) isChecked[9] = false;

                    // If all 0-8 are checked manually, check index 9 automatically
                    if (isChecked.take(9).every((e) => e == true)) {
                      isChecked[9] = true;
                    }
                  }
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
