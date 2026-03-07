import 'package:flutter/material.dart';
import 'package:tutophia/TutorAccess/registration2-tutor.dart';
import 'package:tutophia/registration-type.dart';

class TutorRegistration1 extends StatefulWidget {
  const TutorRegistration1({super.key});

  @override
  State<TutorRegistration1> createState() => _TutorRegistration1State();
}

class _TutorRegistration1State extends State<TutorRegistration1> {
  String? gender;
  String? tutorType;
  String? department;
  String? yearSpent;
  DateTime? selectedDate;
  int? age;

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
              MaterialPageRoute(builder: (context) => const RegistrationType()),
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

            const SizedBox(height: 25),

            // Profile picture section
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black54),
                    ),
                    child: const Center(child: Icon(Icons.add)),
                  ),

                  const SizedBox(width: 15),

                  const Text("+ Add Profile Picture"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Personal Information section
            const Text(
              "Personal Information",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // full name row (first name, MI, last name)
            Row(
              children: [
                // First Name
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "First Name",
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: "First Name",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: borderStyle,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // MI
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "MI",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 4),
                          hintText: "MI",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Last Name
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Last Name",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
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
                          hintText: "Last Name",
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Gender dropdown (full width)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Gender",
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
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Select Gender',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Male", child: Text("Male")),
                    DropdownMenuItem(value: "Female", child: Text("Female")),
                    DropdownMenuItem(value: "Others", child: Text("Others")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      gender = value as String?;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Birthdate and Age in the same row
            Row(
              children: [
                // Birthdate
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Birthdate",
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
                        readOnly: true,
                        controller: TextEditingController(
                          text: selectedDate == null
                              ? ""
                              : "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
                        ),
                        decoration: InputDecoration(
                          border: borderStyle,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          hintText: "MM/DD/YYYY",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;

                              // Age calculation
                              DateTime today = DateTime.now();
                              age = today.year - pickedDate.year;
                              if (today.month < pickedDate.month ||
                                  (today.month == pickedDate.month &&
                                      today.day < pickedDate.day)) {
                                age = age! - 1;
                              }
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Age
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Age",
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
                        readOnly: true,
                        controller: TextEditingController(
                          text: age == null ? "" : age.toString(),
                        ),
                        decoration: InputDecoration(
                          border: borderStyle,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          hintText: "Age",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Address (text area)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Address",
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
                    hintText: "Enter your address (City / Area)",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Academic & Professional Credentials section
            const Text(
              "Academic & Professional Credentials",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // Tutor Type dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Tutor Type",
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
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Select a Tutor Type',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Student Tutor",
                      child: Text("Student Tutor"),
                    ),
                    DropdownMenuItem(
                      value: "Professional Tutor",
                      child: Text("Professional Tutor"),
                    ),
                    DropdownMenuItem(
                      value: "Graduate Tutor",
                      child: Text("Graduate Tutor"),
                    ),
                    DropdownMenuItem(
                      value: "Peer Tutor",
                      child: Text("Peer Tutor"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      tutorType = value as String?;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Department dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Department",
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
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Select Department',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "CEA",
                      child: Text("College of Engr & Arch"),
                    ),
                    DropdownMenuItem(
                      value: "CCS",
                      child: Text("College of Computer Studies"),
                    ),
                    DropdownMenuItem(
                      value: "CE",
                      child: Text("College of Education"),
                    ),
                    DropdownMenuItem(
                      value: "CA",
                      child: Text("College of Arts"),
                    ),
                    DropdownMenuItem(
                      value: "CB",
                      child: Text("College of Business"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      department = value as String?;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Program (single column)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Program",
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
                    hintText: "Enter Program (e.g. BSCS, BSIT, etc.)",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Year Spent dropdown (single column)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Year Spent",
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
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Select Year',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "1st Year",
                      child: Text("1st Year"),
                    ),
                    DropdownMenuItem(
                      value: "2nd Year",
                      child: Text("2nd Year"),
                    ),
                    DropdownMenuItem(
                      value: "3rd Year",
                      child: Text("3rd Year"),
                    ),
                    DropdownMenuItem(
                      value: "4th Year",
                      child: Text("4th Year"),
                    ),
                    DropdownMenuItem(
                      value: "5th Year +",
                      child: Text("5th Year +"),
                    ),
                    DropdownMenuItem(
                      value: "Graduate",
                      child: Text("Graduate"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      yearSpent = value as String?;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Area of Specialization section
            const Text(
              "Area of Specialization",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // Specialization input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Specialization",
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
                    hintText: "Enter course/topic/area you specialize teaching",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Tutoring Experience
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Tutoring Experience",
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
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter years of experience (e.g. 2)",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Teaching Description (text area)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Teaching Description",
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
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    hintText:
                        "Share your area of specialization, years of experience, teaching methods, achievements, and why students should choose you as their tutor.",
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
                      builder: (context) => const TutorRegistration2(),
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
