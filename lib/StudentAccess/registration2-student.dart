import 'package:flutter/material.dart';
import 'package:tutophia/login.dart';
import 'package:tutophia/StudentAccess/registration1-student.dart';
import 'package:tutophia/registration-type.dart';

class StudentRegistration2 extends StatefulWidget {
  const StudentRegistration2({super.key});

  @override
  State<StudentRegistration2> createState() => _StudentRegistration2State();
}

class _StudentRegistration2State extends State<StudentRegistration2> {
  String? gender;
  String? department;
  String? year;
  String? selectedGender;
  DateTime? selectedDate;
  int? age;

  final OutlineInputBorder borderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),

      // back arrow (redirect to login screen)
      appBar: AppBar(
        backgroundColor: const Color(0xfff3f3f3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StudentRegistration1()),
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // create account text title
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

            // student registration subtitle
            const Text(
              "Student Registration",
              style: TextStyle(color: Colors.black54, fontFamily: 'Arial'),
            ),

            const SizedBox(height: 25),

            // profile picture decoration only
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

                  const Text("Add Profile Picture"),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Personal Information text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),

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
                          border: borderStyle,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: "First Name",
                          hintStyle: TextStyle(color: Colors.grey),
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

            // Gender drop down button
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label with asterisk
                RichText(
                  text: const TextSpan(
                    text: "Gender",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
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

                // gender dropdown
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    hintText: 'Select Gender',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Male", child: Text("Male")),
                    DropdownMenuItem(value: "Female", child: Text("Female")),
                    DropdownMenuItem(value: "Others", child: Text("Others")),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // birthdate and age row
            Row(
              children: [
                // birthdate - calendar
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Birthdate",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
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

                              // age calculation
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

                // age (auto compute)
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Age",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
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
                        readOnly: true,
                        controller: TextEditingController(
                          text: age == null ? "" : age.toString(),
                        ),
                        decoration: InputDecoration(
                          border: borderStyle,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
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

            // address text area
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Address",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
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
            const SizedBox(height: 30),

            // academic credentials text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Academic Credentials",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15), // optional spacing below
              ],
            ),

            // department label and dropdownbox
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Department",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
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

                // department dropdown
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    hintText: 'Select Department',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "CEA",
                      child: Text("College of Eng & Arch"),
                    ),
                    DropdownMenuItem(
                      value: "CCS",
                      child: Text("Collge of Computer Studies"),
                    ),
                    DropdownMenuItem(
                      value: "CE",
                      child: Text("College of Education"),
                    ),
                    DropdownMenuItem(
                      value: "CA",
                      child: Text("College of Arts"),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
            SizedBox(height: 20),

            // program text label and filed
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Program",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter your program (e.g. BSCS)",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // year spent drop down
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Year Spent",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
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

                // year spent dropdown
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    hintText: 'Select Year Spent',
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
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
            SizedBox(height: 20),

            // student description text area
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label with asterisk
                RichText(
                  text: const TextSpan(
                    text: "Student Description",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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

                // Multi-line TextField
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    hintText:
                        "Provide a short description about yourself as a student",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // next button
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
                      builder: (context) => StudentRegistration2(),
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

            // login text
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigate to login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
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
