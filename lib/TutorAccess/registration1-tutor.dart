import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutophia/login.dart';
import 'package:tutophia/TutorAccess/registration2-tutor.dart';
import 'package:tutophia/registration-type.dart';
import 'package:tutophia/services/authentication/auth_registration_validator.dart';

class TutorRegistration1 extends StatefulWidget {
  const TutorRegistration1({super.key});

  @override
  State<TutorRegistration1> createState() => _TutorRegistration1State();
}

class _TutorRegistration1State extends State<TutorRegistration1> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final programController = TextEditingController();
  final tutorDescriptionController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? gender, department, year;
  DateTime? selectedDate;
  int? age;
  bool isPasswordVisible = false, isConfirmPasswordVisible = false;

  // ── Profile image state ──────────────────────────────────────────────────────
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  static const _blue = Color(0xff3d6fa5);

  @override
  void dispose() {
    for (final c in [
      firstNameController,
      lastNameController,
      addressController,
      programController,
      tutorDescriptionController,
      emailController,
      usernameController,
      passwordController,
      confirmPasswordController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Image Picker ─────────────────────────────────────────────────────────────

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 600,
    );
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sheet handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Profile Photo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F0FE),
                  child: Icon(Icons.camera_alt, color: _blue),
                ),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F0FE),
                  child: Icon(Icons.photo_library, color: _blue),
                ),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              // Show remove option only if a photo is already selected
              if (_profileImage != null)
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFEBEE),
                    child: Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  title: const Text(
                    'Remove photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _profileImage = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: width),
      );

  InputDecoration _dec(String hint, {Widget? suffix, EdgeInsets? padding}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        suffixIcon: suffix,
        errorMaxLines: 2,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        border: _border(Colors.black),
        enabledBorder: _border(Colors.black),
        focusedBorder: _border(_blue, width: 2),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red, width: 2),
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
    bool required = true,
    EdgeInsets? padding,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(label, required: required),
      TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: _dec(hint, padding: padding),
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

  String? validateName(String? v, String field) {
    if (v == null || v.isEmpty) return '$field is required';
    if (v.length < 2) return '$field must be at least 2 characters';
    if (!RegExp(r'^[a-zA-Z\s\-]+$').hasMatch(v))
      return '$field can only contain letters, spaces, and hyphens';
    return null;
  }

  String? validateEmail(String? v) {
    return AuthRegistrationValidator.validateRegistrationEmail(v);
  }

  String? validateUsername(String? v) {
    if (v == null || v.isEmpty) return 'Username is required';
    if (v.length < 4) return 'Username must be at least 4 characters';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v))
      return 'Username can only contain letters, numbers, and underscores';
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    if (!v.contains(RegExp(r'[A-Z]')))
      return 'Password must contain at least one uppercase letter';
    if (!v.contains(RegExp(r'[0-9]')))
      return 'Password must contain at least one number';
    if (!v.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')))
      return 'Password must contain at least one special character';
    return null;
  }

  String? validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != passwordController.text) return 'Passwords do not match';
    return null;
  }

  String? validateAge() {
    if (age == null) return 'Age is required';
    if (age! < 15 || age! > 100) return 'Age must be between 15 and 100';
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
            MaterialPageRoute(builder: (_) => RegistrationType()),
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

              // ── Profile Picture ──────────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: _showImageSourceSheet,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          // Avatar circle
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black54),
                              color: Colors.grey.shade100,
                            ),
                            child: ClipOval(
                              child: _profileImage != null
                                  ? Image.file(
                                      _profileImage!,
                                      fit: BoxFit.cover,
                                      width: 70,
                                      height: 70,
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.black38,
                                    ),
                            ),
                          ),
                          // Edit badge
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 22,
                              width: 22,
                              decoration: const BoxDecoration(
                                color: _blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Text(
                        _profileImage != null
                            ? 'Change Profile Picture'
                            : 'Add Profile Picture',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // ── Personal Information ──
              _section('Personal Information'),

              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _field(
                      'First Name',
                      firstNameController,
                      'Enter First Name',
                      validator: (v) => validateName(v, 'First name'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: _field(
                      'Last Name',
                      lastNameController,
                      'Enter Last Name',
                      validator: (v) => validateName(v, 'Last name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _dropdown(
                'Gender',
                'Select Gender',
                gender,
                const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Others', child: Text('Others')),
                ],
                (v) => setState(() => gender = v),
                (v) => v == null ? 'Please select gender' : null,
              ),
              const SizedBox(height: 20),

              // Birthdate + Age row
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Birthdate'),
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: selectedDate == null
                                ? ''
                                : '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}',
                          ),
                          validator: (_) => selectedDate == null
                              ? 'Birthdate is required'
                              : null,
                          decoration: _dec(
                            'Birthday',
                            suffix: const Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                                final today = DateTime.now();
                                age = today.year - picked.year;
                                if (today.month < picked.month ||
                                    (today.month == picked.month &&
                                        today.day < picked.day))
                                  age = age! - 1;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Age'),
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: age == null ? '' : age.toString(),
                          ),
                          textAlign: TextAlign.center,
                          validator: (_) => validateAge(),
                          decoration: _dec(
                            'Age',
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _field(
                'Address',
                addressController,
                'Enter your address (City / Area)',
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Address is required'
                    : v.length < 5
                    ? 'Please enter a complete address'
                    : null,
                maxLines: 3,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
              ),
              const SizedBox(height: 30),

              // ── Account Creation ──
              _section('Account Creation'),

              _field(
                'School/Institution Email Address',
                emailController,
                'Enter your school email address',
                validator: validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              _field(
                'Username',
                usernameController,
                'Enter your username',
                validator: validateUsername,
              ),
              const SizedBox(height: 20),

              _label('Password'),
              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                validator: validatePassword,
                decoration: _dec(
                  'Enter your password',
                  suffix: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => isPasswordVisible = !isPasswordVisible),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _label('Confirm Password'),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible,
                validator: validateConfirmPassword,
                decoration: _dec(
                  'Confirm your password',
                  suffix: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () => setState(
                      () =>
                          isConfirmPasswordVisible = !isConfirmPasswordVisible,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ── Next Button ──────────────────────────────────────────────────
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
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'First step completed! Proceeding to next step...',
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
                            builder: (_) => TutorRegistration2(
                              registrationData: {
                                'accountType': 'tutor',
                                'firstName': firstNameController.text.trim(),
                                'lastName': lastNameController.text.trim(),
                                'gender': gender,
                                'birthdate': selectedDate?.toIso8601String(),
                                'age': age,
                                'address': addressController.text.trim(),
                                'email': emailController.text.trim(),
                                'userName': usernameController.text.trim(),
                                'password': passwordController.text,
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
