import 'package:flutter/material.dart';
import 'package:tutophia/TutorAccess/registration2-tutor.dart';
import 'package:tutophia/successful-reg.dart';

class TermsandConditionsTutor extends StatefulWidget {
  const TermsandConditionsTutor({super.key});

  @override
  State<TermsandConditionsTutor> createState() =>
      TermsandConditionsTutorState();
}

class TermsandConditionsTutorState extends State<TermsandConditionsTutor> {
  final List<bool> isChecked = List.generate(11, (index) => false);

  final List<Map<String, String>> termsContent = [
    {
      'Term': 'Qualification Verification',
      'Condition':
          'You must provide valid credentials, academic qualifications, and relevant experience. Tutophia reserves the right to verify submitted documents.',
    },
    {
      'Term': 'Accurate Professional Information',
      'Condition':
          'All details regarding expertise, courses handled, and availability must be truthful and updated regularly.',
    },
    {
      'Term': 'One Account Per Tutor',
      'Condition':
          'Each tutor may register only one account. Account sharing or duplicate registrations are prohibited.',
    },
    {
      'Term': 'Professional Conduct',
      'Condition':
          'You must maintain professionalism, respect students, and provide quality tutoring services at all times.',
    },
    {
      'Term': 'Availability Commitment',
      'Condition':
          'You agree to honor confirmed bookings and manage your schedule responsibly. Repeated cancellations may affect account status.',
    },
    {
      'Term': 'Learning Material Responsibility',
      'Condition':
          'Materials shared must be original or properly cited. Tutors must not distribute copyrighted content without permission.',
    },
    {
      'Term': 'Payment Policy Compliance (If Applicable)',
      'Condition':
          'Tutors must follow the platform’s official payment and transaction system.',
    },
    {
      'Term': 'Fair Rating System',
      'Condition':
          'Tutors may respond professionally to student feedback but must not manipulate ratings or reviews.',
    },
    {
      'Term': 'Data Privacy and Confidentiality',
      'Condition':
          'Student information must be kept confidential and used only for tutoring purposes.',
    },
    {
      'Term': 'System Integrity',
      'Condition':
          'Any attempt to manipulate bookings, ratings, or platform features may result in account termination.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  'By registering as a tutor on TUTOPHIA, you agree to the following terms:',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                const SizedBox(height: 20),

                ...termsContent.asMap().entries.map((entry) {
                  int index = entry.key;
                  return buildTermItem(
                    index,
                    entry.value['Term']!,
                    entry.value['Condition']!,
                  );
                }).toList(),

                buildTermItem(
                  10,
                  'I AGREE TO ALL TERMS AND CONDITIONS',
                  'By checking this, you agree to all terms and conditions.',
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isChecked[10]
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

                  if (index == 10) {
                    for (int i = 0; i < isChecked.length; i++) {
                      isChecked[i] = val;
                    }
                  } else {
                    if (val == false) isChecked[10] = false;

                    if (isChecked.take(10).every((e) => e == true)) {
                      isChecked[10] = true;
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
