import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tutophia/TutorAccess/registration2-tutor.dart';
import 'package:tutophia/services/authentication/auth_registration_validator.dart';
import 'package:tutophia/services/repository/authentication_repository/authentication_repository.dart';
import 'package:tutophia/services/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:tutophia/verify-email.dart';

class TermsandConditionsTutor extends StatefulWidget {
  final Map<String, dynamic> registrationData;

  const TermsandConditionsTutor({super.key, required this.registrationData});

  @override
  State<TermsandConditionsTutor> createState() =>
      TermsandConditionsTutorState();
}

class TermsandConditionsTutorState extends State<TermsandConditionsTutor> {
  final List<bool> isChecked = List.generate(11, (index) => false);
  bool _isCreatingAccount = false;

  Future<void> _createTutorAccount() async {
    if (_isCreatingAccount) return;

    final email = (widget.registrationData['email'] as String?)?.trim() ?? '';
    final password = widget.registrationData['password'] as String? ?? '';
    final profileImageFile =
        widget.registrationData['profileImageFile'] as File?;
    final emailError = AuthRegistrationValidator.validateRegistrationEmail(
      email,
    );
    final ageError = AuthRegistrationValidator.validateStudentAge(
      widget.registrationData['age'],
    );

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Missing email/password. Please complete registration.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailError), backgroundColor: Colors.red),
      );
      return;
    }

    if (ageError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ageError), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isCreatingAccount = true);

    try {
      final credential = await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
            role: 'tutor',
            profileData: widget.registrationData,
            profileImageFile: profileImageFile,
          );

      await AuthenticationRepository.instance.sendEmailVerification(
        user: credential.user,
      );

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (context) =>
              VerifyEmailScreen(email: credential.user?.email),
        ),
        (route) => false,
      );
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong while creating your account. Please try again.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isCreatingAccount = false);
      }
    }
  }

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
              MaterialPageRoute(
                builder: (context) => TutorRegistration2(
                  registrationData: widget.registrationData,
                ),
              ),
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
                      onPressed: (isChecked[10] && !_isCreatingAccount)
                          ? _createTutorAccount
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF386FA4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _isCreatingAccount
                            ? 'CREATING ACCOUNT...'
                            : 'CREATE ACCOUNT',
                        style: const TextStyle(
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
