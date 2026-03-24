import 'package:flutter/material.dart';
import 'package:tutophia/login.dart';
import 'package:tutophia/TutorAccess/registration1-tutor.dart';
import 'package:tutophia/TutorAccess/terms-condition-tutor.dart';

class TutorRegistration2 extends StatefulWidget {
  final Map<String, dynamic> registrationData;

  const TutorRegistration2({super.key, required this.registrationData});

  @override
  State<TutorRegistration2> createState() => _TutorRegistration2State();
}

class _TutorRegistration2State extends State<TutorRegistration2> {
  final _formKey = GlobalKey<FormState>();

  final programController = TextEditingController();
  final specialization1Controller = TextEditingController();
  final specialization2Controller = TextEditingController();
  final tutoringExperienceController = TextEditingController();
  final universityController = TextEditingController();
  final teachingDescriptionController = TextEditingController();
  final sessionDurationController = TextEditingController();
  final sessionRateController = TextEditingController();
  final availableScheduleController = TextEditingController();
  final scheduleLinkController = TextEditingController();
  final contactController = TextEditingController();
  final messengerController = TextEditingController();
  final instagramController = TextEditingController();
  final othersController = TextEditingController();

  String? tutorType, department, yearSpent, sessionRateMode;
  bool isOnlineSelected = false,
      isFaceToFaceSelected = false,
      isHybridSelected = false;
  late List<TextEditingController> specializationControllers;

  static const _blue = Color(0xff3d6fa5);

  @override
  void initState() {
    super.initState();
    specializationControllers = [
      specialization1Controller,
      specialization2Controller,
    ];
  }

  @override
  void dispose() {
    for (final c in [
      programController,
      specialization1Controller,
      specialization2Controller,
      tutoringExperienceController,
      universityController,
      teachingDescriptionController,
      sessionDurationController,
      sessionRateController,
      availableScheduleController,
      scheduleLinkController,
      contactController,
      messengerController,
      instagramController,
      othersController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  InputDecoration _dec(String hint, {String? suffix}) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400),
    suffixText: suffix,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    border: _border(Colors.black),
    enabledBorder: _border(Colors.black),
    focusedBorder: _border(_blue, width: 2),
    errorBorder: _border(Colors.red),
    focusedErrorBorder: _border(Colors.red, width: 2),
  );

  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: width),
      );

  Widget _label(String text, {bool required = true}) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 14,
        ),
        children: required
            ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ]
            : [],
      ),
    ),
  );

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
  );

  Widget _field(
    String label,
    TextEditingController controller,
    String hint, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? suffix,
    bool required = true,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(label, required: required),
      TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: _dec(hint, suffix: suffix),
      ),
    ],
  );

  Widget _dropdown(
    String label,
    String hint,
    String? value,
    List<DropdownMenuItem<String>> items,
    void Function(String?) onChanged,
    String? Function(String?)? validator,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(label),
      DropdownButtonFormField<String>(
        value: value,
        decoration: _dec(hint).copyWith(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    ],
  );

  // ── Validators ───────────────────────────────────────────────────────────────

  String? validateContactNumber(String? v) {
    if (v == null || v.isEmpty) return 'Contact number is required';
    final c = v.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (!RegExp(r'^[0-9]+$').hasMatch(c))
      return 'Contact number should only contain digits';
    if (c.length < 10 || c.length > 13)
      return 'Contact number should be 10-13 digits';
    if (!RegExp(r'^(09|63|9)').hasMatch(c))
      return 'Please enter a valid contact number';
    return null;
  }

  String? validateSpecialization(String? v, int i) {
    if (v == null || v.isEmpty)
      return 'Specialization field ${i + 1} is required';
    if (v.length < 3) return 'Specialization must be at least 3 characters';
    if (v.length > 100) return 'Specialization must not exceed 100 characters';
    return null;
  }

  String? validateExperience(String? v) {
    if (v == null || v.isEmpty) return 'Tutoring experience is required';
    if (!RegExp(
      r'^\d+\s*(year|years|month|months|yr|yrs)?$',
      caseSensitive: false,
    ).hasMatch(v))
      return 'Please enter valid experience (e.g., 2 years, 6 months)';
    return null;
  }

  String? validateTeachingDescription(String? v) {
    if (v == null || v.isEmpty) return 'Teaching description is required';
    if (v.length < 30) return 'Description must be at least 30 characters';
    if (v.length > 1000) return 'Description must not exceed 1000 characters';
    return null;
  }

  String? validateSessionDuration(String? v) {
    if (v == null || v.isEmpty) return 'Session duration is required';
    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(v))
      return 'Please enter a valid number';
    final d = double.parse(v);
    if (d < 0.5) return 'Minimum session duration is 0.5 hour';
    if (d > 8) return 'Maximum session duration is 8 hours';
    return null;
  }

  String? validateSessionRate(String? v) {
    if (v == null || v.isEmpty) return 'Session rate is required';
    if (!RegExp(r'^\d+(\.\d{2})?$').hasMatch(v))
      return 'Please enter a valid amount';
    final r = double.parse(v);
    if (r < 50) return 'Minimum rate is ₱50';
    if (r > 10000) return 'Maximum rate is ₱10,000';
    return null;
  }

  String? validateSchedule(String? v) {
    if (v == null || v.isEmpty) return 'Available schedule is required';
    if (v.length < 10) return 'Please provide a detailed schedule';
    return null;
  }

  String? validateOptionalField(String? v, String name) {
    if (v != null && v.isNotEmpty) {
      if (v.length < 3) return '$name is too short';
      if (v.length > 200) return '$name is too long';
      if (name.toLowerCase().contains('link') &&
          !v.contains(RegExp(r'^https?://|www\.')))
        return 'Please enter a valid URL';
    }
    return null;
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorRegistration1()),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CREATE ACCOUNT',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: _blue,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Tutor Registration',
                style: TextStyle(color: Colors.black54, fontFamily: 'Arial'),
              ),
              const SizedBox(height: 25),

              // ── Academic & Professional Credentials ──
              _section('Academic & Professional Credentials'),

              _dropdown(
                'Tutor Type',
                'Select a Tutor Type',
                tutorType,
                const [
                  DropdownMenuItem(
                    value: 'Student Tutor',
                    child: Text('Student Tutor'),
                  ),
                  DropdownMenuItem(
                    value: 'Professional Tutor',
                    child: Text('Professional Tutor'),
                  ),
                  DropdownMenuItem(
                    value: 'Graduate Tutor',
                    child: Text('Graduate Tutor'),
                  ),
                  DropdownMenuItem(
                    value: 'Expert Tutor',
                    child: Text('Expert Tutor'),
                  ),
                ],
                (v) => setState(() => tutorType = v),
                (v) => v == null ? 'Please select tutor type' : null,
              ),
              const SizedBox(height: 20),

              _field(
                'University / Institution',
                universityController,
                'Enter your current university/Institution',
                validator: (v) => (v == null || v.isEmpty || v.length < 2)
                    ? 'University/Institution is required'
                    : null,
              ),
              const SizedBox(height: 20),

              _dropdown(
                'Department',
                'Select Department',
                department,
                const [
                  DropdownMenuItem(
                    value: 'CEA',
                    child: Text('College of Eng & Arch'),
                  ),
                  DropdownMenuItem(
                    value: 'CCS',
                    child: Text('College of Computer Studies'),
                  ),
                  DropdownMenuItem(
                    value: 'CE',
                    child: Text('College of Education'),
                  ),
                  DropdownMenuItem(value: 'CA', child: Text('College of Arts')),
                  DropdownMenuItem(
                    value: 'CBM',
                    child: Text('College of Business'),
                  ),
                  DropdownMenuItem(
                    value: 'CON',
                    child: Text('College of Nursing'),
                  ),
                ],
                (v) => setState(() => department = v),
                (v) => v == null ? 'Please select department' : null,
              ),
              const SizedBox(height: 20),

              // Program + Year row
              Row(
                children: [
                  Expanded(
                    child: _field(
                      'Program',
                      programController,
                      'Enter Program',
                      validator: (v) => (v == null || v.isEmpty || v.length < 2)
                          ? 'Program is required'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _dropdown(
                      'Year Spent',
                      'Select Year',
                      yearSpent,
                      const [
                        DropdownMenuItem(
                          value: '1st Year',
                          child: Text('1st Year'),
                        ),
                        DropdownMenuItem(
                          value: '2nd Year',
                          child: Text('2nd Year'),
                        ),
                        DropdownMenuItem(
                          value: '3rd Year',
                          child: Text('3rd Year'),
                        ),
                        DropdownMenuItem(
                          value: '4th Year',
                          child: Text('4th Year'),
                        ),
                        DropdownMenuItem(
                          value: '5th Year +',
                          child: Text('5th Year +'),
                        ),
                      ],
                      (v) => setState(() => yearSpent = v),
                      (v) => v == null ? 'Please select year spent' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Area of Specialization
              _label('Area of Specialization'),
              ...List.generate(
                specializationControllers.length,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: specializationControllers[i],
                    validator: (v) => validateSpecialization(v, i),
                    decoration: _dec('Add your area of specialization'),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(
                  () => specializationControllers.add(TextEditingController()),
                ),
                icon: const Icon(Icons.add, color: _blue, size: 20),
                label: const Text(
                  'ADD MORE',
                  style: TextStyle(
                    color: _blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _field(
                'Tutoring Experience',
                tutoringExperienceController,
                'Total tutoring experience (e.g., 2 years)',
                validator: validateExperience,
              ),
              const SizedBox(height: 20),

              _field(
                'Teaching Description',
                teachingDescriptionController,
                'Share your area of specialization, years of experience, teaching methods, achievements, and why students should choose you as their tutor.',
                validator: validateTeachingDescription,
                maxLines: 5,
              ),
              const SizedBox(height: 30),

              // ── Service Setup ──
              _section('Service Setup'),

              // Mode of Tutoring
              _label('Mode of Tutoring'),
              FormField<bool>(
                validator: (_) =>
                    (!isOnlineSelected &&
                        !isFaceToFaceSelected &&
                        !isHybridSelected)
                    ? 'Please select at least one mode of tutoring'
                    : null,
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entry in [
                      (
                        'Online',
                        isOnlineSelected,
                        (v) => setState(() {
                          isOnlineSelected = v!;
                          field.didChange(true);
                        }),
                      ),
                      (
                        'Face-to-Face',
                        isFaceToFaceSelected,
                        (v) => setState(() {
                          isFaceToFaceSelected = v!;
                          field.didChange(true);
                        }),
                      ),
                      (
                        'Hybrid',
                        isHybridSelected,
                        (v) => setState(() {
                          isHybridSelected = v!;
                          field.didChange(true);
                        }),
                      ),
                    ])
                      Row(
                        children: [
                          Checkbox(
                            value: entry.$2,
                            onChanged: entry.$3,
                            activeColor: _blue,
                          ),
                          Text(entry.$1),
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
                ),
              ),
              const SizedBox(height: 20),

              _field(
                'Preferred Session Duration',
                sessionDurationController,
                'Enter your preferred session duration (in hour)',
                validator: validateSessionDuration,
                keyboardType: TextInputType.number,
                suffix: 'hours',
              ),
              const SizedBox(height: 20),

              // Session Rate + Mode row
              Row(
                children: [
                  Expanded(
                    child: _field(
                      'Session Rate',
                      sessionRateController,
                      '₱ price',
                      validator: validateSessionRate,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _dropdown(
                      'Mode',
                      'Select Mode',
                      sessionRateMode,
                      const [
                        DropdownMenuItem(
                          value: 'per hour',
                          child: Text('per hour'),
                        ),
                        DropdownMenuItem(
                          value: 'per session',
                          child: Text('per session'),
                        ),
                        DropdownMenuItem(
                          value: 'per month',
                          child: Text('per month'),
                        ),
                      ],
                      (v) => setState(() => sessionRateMode = v),
                      (v) => v == null ? 'Please select mode' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _field(
                'Available Schedule',
                availableScheduleController,
                'Enter or list your preferred schedule for tutoring (eg., Monday - 1:00pm to 3:00pm)',
                validator: validateSchedule,
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              _field(
                'Links for documented schedule',
                scheduleLinkController,
                'You can put a link for excel/document regarding your detailed or updated schedule',
                validator: (v) => validateOptionalField(v, 'Schedule link'),
                required: false,
              ),
              const SizedBox(height: 30),

              // ── Contact Information ──
              _section('Contact Information'),

              _field(
                'Contact Number',
                contactController,
                'Enter your contact number',
                validator: validateContactNumber,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 25),

              // ── Other Accounts ──
              _section('Other Accounts'),

              _field(
                'Messenger',
                messengerController,
                'Enter messenger account link',
                validator: (v) => validateOptionalField(v, 'Messenger link'),
                required: false,
              ),
              const SizedBox(height: 20),
              _field(
                'Instagram',
                instagramController,
                'Enter instagram account link',
                validator: (v) => validateOptionalField(v, 'Instagram link'),
                required: false,
              ),
              const SizedBox(height: 20),
              _field(
                'Others',
                othersController,
                'Enter other accounts',
                validator: (v) => validateOptionalField(v, 'Other accounts'),
                required: false,
              ),
              const SizedBox(height: 30),

              // Next button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Information validated! Proceeding to next step...',
                          ),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Future.delayed(
                        const Duration(seconds: 2),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TermsandConditionsTutor(
                              registrationData: {
                                ...widget.registrationData,
                                'tutorType': tutorType,
                                'university': universityController.text.trim(),
                                'department': department,
                                'program': programController.text.trim(),
                                'yearSpent': yearSpent,
                                'specializations': specializationControllers
                                    .map((c) => c.text.trim())
                                    .where((value) => value.isNotEmpty)
                                    .toList(),
                                'tutoringExperience':
                                    tutoringExperienceController.text.trim(),
                                'teachingDescription':
                                    teachingDescriptionController.text.trim(),
                                'modeOfTutoring': [
                                  if (isOnlineSelected) 'online',
                                  if (isFaceToFaceSelected) 'face_to_face',
                                  if (isHybridSelected) 'hybrid',
                                ],
                                'sessionDurationHours':
                                    sessionDurationController.text.trim(),
                                'sessionRate': sessionRateController.text
                                    .trim(),
                                'sessionRateMode': sessionRateMode,
                                'availableSchedule': availableScheduleController
                                    .text
                                    .trim(),
                                'scheduleLink': scheduleLinkController.text
                                    .trim(),
                                'contactNumber': contactController.text.trim(),
                                'messenger': messengerController.text.trim(),
                                'instagram': instagramController.text.trim(),
                                'otherAccounts': othersController.text.trim(),
                              },
                            ),
                          ),
                        ),
                      );
                    } else {
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
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: _blue,
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
