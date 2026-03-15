import 'package:flutter/material.dart';
import 'package:tutophia/login.dart';
import 'package:tutophia/TutorAccess/registration1-tutor.dart';
import 'package:tutophia/TutorAccess/terms-condition-tutor.dart';

class TutorRegistration2 extends StatefulWidget {
  const TutorRegistration2({super.key});

  @override
  State<TutorRegistration2> createState() => _TutorRegistration2State();
}

class _TutorRegistration2State extends State<TutorRegistration2> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController programController = TextEditingController();
  final TextEditingController specialization1Controller =
      TextEditingController();
  final TextEditingController specialization2Controller =
      TextEditingController();
  final TextEditingController tutoringExperienceController =
      TextEditingController();
  final TextEditingController teachingDescriptionController =
      TextEditingController();
  final TextEditingController sessionDurationController =
      TextEditingController();
  final TextEditingController sessionRateController = TextEditingController();
  final TextEditingController modeController = TextEditingController();
  final TextEditingController availableScheduleController =
      TextEditingController();
  final TextEditingController scheduleLinkController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController messengerController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController othersController = TextEditingController();

  // Dropdown values
  String? tutorType;
  String? department;
  String? yearSpent;
  String? sessionRateMode;

  // Multi-select for mode of tutoring
  bool isOnlineSelected = false;
  bool isFaceToFaceSelected = false;
  bool isHybridSelected = false;

  // For dynamic specialization fields
  List<TextEditingController> specializationControllers = [];

  final OutlineInputBorder borderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
  );

  @override
  void initState() {
    super.initState();
    // Initialize with the two specialization fields
    specializationControllers = [
      specialization1Controller,
      specialization2Controller,
    ];
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address is required';
    }

    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+(\.[a-zA-Z]+)?$',
    );

    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Contact number validation
  String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contact number is required';
    }

    String cleanedNumber = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    if (!RegExp(r'^[0-9]+$').hasMatch(cleanedNumber)) {
      return 'Contact number should only contain digits';
    }

    if (cleanedNumber.length < 10 || cleanedNumber.length > 13) {
      return 'Contact number should be 10-13 digits';
    }

    if (!RegExp(r'^(09|63|9)').hasMatch(cleanedNumber)) {
      return 'Please enter a valid contact number';
    }

    return null;
  }

  // Program validation
  String? validateProgram(String? value) {
    if (value == null || value.isEmpty) {
      return 'Program is required';
    }
    if (value.length < 2) {
      return 'Please enter a valid program';
    }
    return null;
  }

  // Specialization validation
  String? validateSpecialization(String? value, int index) {
    if (value == null || value.isEmpty) {
      return 'Specialization field ${index + 1} is required';
    }
    if (value.length < 3) {
      return 'Specialization must be at least 3 characters';
    }
    if (value.length > 100) {
      return 'Specialization must not exceed 100 characters';
    }
    return null;
  }

  // Tutoring experience validation
  String? validateExperience(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tutoring experience is required';
    }

    // Check format (e.g., "2 years", "6 months", "1 year")
    if (!RegExp(
      r'^\d+\s*(year|years|month|months|yr|yrs)?$',
      caseSensitive: false,
    ).hasMatch(value)) {
      return 'Please enter valid experience (e.g., 2 years, 6 months)';
    }

    return null;
  }

  // Teaching description validation
  String? validateTeachingDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Teaching description is required';
    }
    if (value.length < 30) {
      return 'Description must be at least 30 characters';
    }
    if (value.length > 1000) {
      return 'Description must not exceed 1000 characters';
    }
    return null;
  }

  // Session duration validation
  String? validateSessionDuration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Session duration is required';
    }

    // Check if it's a valid number (can be decimal)
    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
      return 'Please enter a valid number';
    }

    double duration = double.parse(value);
    if (duration < 0.5) {
      return 'Minimum session duration is 0.5 hour';
    }
    if (duration > 8) {
      return 'Maximum session duration is 8 hours';
    }

    return null;
  }

  // Session rate validation
  String? validateSessionRate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Session rate is required';
    }

    if (!RegExp(r'^\d+(\.\d{2})?$').hasMatch(value)) {
      return 'Please enter a valid amount';
    }

    double rate = double.parse(value);
    if (rate < 50) {
      return 'Minimum rate is ₱50';
    }
    if (rate > 10000) {
      return 'Maximum rate is ₱10,000';
    }

    return null;
  }

  // Mode validation
  String? validateMode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mode is required (e.g., per hour, per session)';
    }
    if (value.length < 3) {
      return 'Please enter a valid mode';
    }
    return null;
  }

  // Available schedule validation
  String? validateSchedule(String? value) {
    if (value == null || value.isEmpty) {
      return 'Available schedule is required';
    }
    if (value.length < 10) {
      return 'Please provide a detailed schedule';
    }
    return null;
  }

  // Optional field validation
  String? validateOptionalField(String? value, String fieldName) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return '$fieldName is too short';
      }
      if (value.length > 200) {
        return '$fieldName is too long';
      }

      // URL validation for links
      if (fieldName.contains('link') || fieldName.contains('Link')) {
        if (!value.contains(RegExp(r'^https?://|www\.'))) {
          return 'Please enter a valid URL';
        }
      }
    }
    return null;
  }

  // Dropdown validation
  String? validateDropdown(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please select $fieldName';
    }
    return null;
  }

  // Mode of tutoring validation
  String? validateModeOfTutoring() {
    if (!isOnlineSelected && !isFaceToFaceSelected && !isHybridSelected) {
      return 'Please select at least one mode of tutoring';
    }
    return null;
  }

  @override
  void dispose() {
    // Dispose all controllers
    programController.dispose();
    specialization1Controller.dispose();
    specialization2Controller.dispose();
    tutoringExperienceController.dispose();
    teachingDescriptionController.dispose();
    sessionDurationController.dispose();
    sessionRateController.dispose();
    modeController.dispose();
    availableScheduleController.dispose();
    scheduleLinkController.dispose();
    emailController.dispose();
    contactController.dispose();
    messengerController.dispose();
    instagramController.dispose();
    othersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      // back arrow (redirect to tutor registration 1)
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TutorRegistration1(),
              ),
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
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

              // tutor registration subtitle
              const Text(
                "Tutor Registration",
                style: TextStyle(color: Colors.black54, fontFamily: 'Arial'),
              ),

              const SizedBox(height: 25),

              // Academic & Professional Credentials text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Academic & Professional Credentials",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),

              // Tutor Type dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Tutor Type",
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
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff3d6fa5),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      hintText: 'Select a Tutor Type',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
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
                        value: "Expert Tutor",
                        child: Text("Expert Tutor"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        tutorType = value;
                      });
                    },
                    value: tutorType,
                    validator: (value) => validateDropdown(value, 'tutor type'),
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
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff3d6fa5),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      hintText: 'Select Department',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    items: const [
                      DropdownMenuItem(
                        value: "CEA",
                        child: Text("College of Eng & Arch"),
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
                        value: "CBM",
                        child: Text("College of Business"),
                      ),
                      DropdownMenuItem(
                        value: "CON",
                        child: Text("College of Nursing"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        department = value;
                      });
                    },
                    value: department,
                    validator: (value) => validateDropdown(value, 'department'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Program and Year Spent row
              Row(
                children: [
                  // Program
                  Expanded(
                    flex: 1,
                    child: Column(
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
                        TextFormField(
                          controller: programController,
                          validator: validateProgram,
                          decoration: InputDecoration(
                            border: borderStyle,
                            enabledBorder: borderStyle,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xff3d6fa5),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            hintText: "Enter Program",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Year Spent
                  Expanded(
                    flex: 1,
                    child: Column(
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
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: borderStyle,
                            enabledBorder: borderStyle,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xff3d6fa5),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            hintText: 'Select Year',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
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
                          onChanged: (value) {
                            setState(() {
                              yearSpent = value;
                            });
                          },
                          value: yearSpent,
                          validator: (value) =>
                              validateDropdown(value, 'year spent'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Area of Specialization text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Area of Specialization",
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

                  // Specialization fields
                  ...List.generate(specializationControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: specializationControllers[index],
                        validator: (value) =>
                            validateSpecialization(value, index),
                        decoration: InputDecoration(
                          border: borderStyle,
                          enabledBorder: borderStyle,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xff3d6fa5),
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          hintText: "Add your area of specialization",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    );
                  }),

                  // Add More button
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        TextEditingController newController =
                            TextEditingController();
                        specializationControllers.add(newController);
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xff3d6fa5),
                      size: 20,
                    ),
                    label: const Text(
                      "ADD MORE",
                      style: TextStyle(
                        color: Color(0xff3d6fa5),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
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
                  TextFormField(
                    controller: tutoringExperienceController,
                    validator: validateExperience,
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff3d6fa5),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      hintText: "Total tutoring experience (e.g., 2 years)",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Teaching Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Teaching Description",
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
                  TextFormField(
                    controller: teachingDescriptionController,
                    maxLines: 5,
                    validator: validateTeachingDescription,
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff3d6fa5),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      hintText:
                          "Share your area of specialization, years of experience, teaching methods, achievements, and why students should choose you as their tutor.",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Service Setup text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Service Setup",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),

              // Mode of Tutoring
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Mode of Tutoring",
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
                  const SizedBox(height: 10),
                  FormField<bool>(
                    validator: (value) {
                      if (!isOnlineSelected &&
                          !isFaceToFaceSelected &&
                          !isHybridSelected) {
                        return 'Please select at least one mode of tutoring';
                      }
                      return null;
                    },
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              // Online
                              Row(
                                children: [
                                  Checkbox(
                                    value: isOnlineSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        isOnlineSelected = value ?? false;
                                        field.didChange(true);
                                      });
                                    },
                                    activeColor: const Color(0xff3d6fa5),
                                  ),
                                  const Text("Online"),
                                ],
                              ),
                              const SizedBox(width: 20),

                              // Face-to-Face
                              Row(
                                children: [
                                  Checkbox(
                                    value: isFaceToFaceSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        isFaceToFaceSelected = value ?? false;
                                        field.didChange(true);
                                      });
                                    },
                                    activeColor: const Color(0xff3d6fa5),
                                  ),
                                  const Text("Face-to-Face"),
                                ],
                              ),
                              const SizedBox(width: 20),

                              // Hybrid
                              Row(
                                children: [
                                  Checkbox(
                                    value: isHybridSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        isHybridSelected = value ?? false;
                                        field.didChange(true);
                                      });
                                    },
                                    activeColor: const Color(0xff3d6fa5),
                                  ),
                                  const Text("Hybrid"),
                                ],
                              ),
                            ],
                          ),
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 12),
                              child: Text(
                                field.errorText!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
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
                  TextFormField(
                    controller: sessionDurationController,
                    keyboardType: TextInputType.number,
                    validator: validateSessionDuration,
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff3d6fa5),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      hintText:
                          "Enter your preferred session duration (in hour)",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                      suffixText: "hours",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Session Rate and Mode row
              Row(
                children: [
                  // Session Rate
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: "Session Rate",
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
                        TextFormField(
                          controller: sessionRateController,
                          keyboardType: TextInputType.number,
                          validator: validateSessionRate,
                          decoration: InputDecoration(
                            border: borderStyle,
                            enabledBorder: borderStyle,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xff3d6fa5),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            hintText: "₱ price",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Mode
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: "Mode",
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
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: borderStyle,
                            enabledBorder: borderStyle,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xff3d6fa5),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            hintText: 'Select Mode',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "per hour",
                              child: Text("per hour"),
                            ),
                            DropdownMenuItem(
                              value: "per session",
                              child: Text("per session"),
                            ),
                            DropdownMenuItem(
                              value: "per month",
                              child: Text("per month"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              sessionRateMode = value;
                            });
                          },
                          value: sessionRateMode,
                          validator: (value) => validateDropdown(value, 'mode'),
                        ),
                      ],
                    ),
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
                  TextFormField(
                    controller: availableScheduleController,
                    maxLines: 3,
                    validator: validateSchedule,
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff3d6fa5),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      hintText:
                          "Enter or list your preferred schedule for tutoring (eg., Monday - 1:00pm to 3:00pm)",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Links for documented schedule
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Links for documented schedule",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: scheduleLinkController,
                    validator: (value) =>
                        validateOptionalField(value, 'Schedule link'),
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff3d6fa5),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      hintText:
                          "You can put a link for excel/document regarding your detailed or updated schedule",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Contact Information text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Contact Information",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),

              // Email Address field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Email Address",
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
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff3d6fa5),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      hintText: "Enter your email address",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Contact Number field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Contact Number",
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
                  TextFormField(
                    controller: contactController,
                    keyboardType: TextInputType.phone,
                    validator: validateContactNumber,
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff3d6fa5),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      hintText: "Enter your contact number",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Other Accounts text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Other Accounts",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),

              // Messenger field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Messenger",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: messengerController,
                    validator: (value) =>
                        validateOptionalField(value, 'Messenger link'),
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff3d6fa5),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      hintText: "Enter messenger account link",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Instagram field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Instagram",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: instagramController,
                    validator: (value) =>
                        validateOptionalField(value, 'Instagram link'),
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff3d6fa5),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      hintText: "Enter instagram account link",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Others field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Others",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: othersController,
                    validator: (value) =>
                        validateOptionalField(value, 'Other accounts'),
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff3d6fa5),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      hintText: "Enter other accounts",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

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
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Validate mode of tutoring separately
                    if (!isOnlineSelected &&
                        !isFaceToFaceSelected &&
                        !isHybridSelected) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please select at least one mode of tutoring',
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                      return;
                    }

                    if (_formKey.currentState!.validate()) {
                      // All validations passed
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Information validated! Proceeding to next step...',
                          ),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // Navigate to next page after brief delay
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const TermsandConditionsTutor(),
                          ),
                        );
                      });
                    } else {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fix the invalid inputs before proceeding',
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "NEXT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
                      style: TextStyle(color: Colors.black54, fontSize: 14),
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
      ),
    );
  }
}
