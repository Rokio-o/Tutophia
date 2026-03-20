import 'package:flutter/material.dart';
import 'package:tutophia/login.dart';
import 'package:tutophia/StudentAccess/registration1-student.dart';
import 'package:tutophia/StudentAccess/terms-condition-student.dart';

class StudentRegistration2 extends StatefulWidget {
  const StudentRegistration2({super.key});

  @override
  State<StudentRegistration2> createState() => _StudentRegistration2State();
}

class _StudentRegistration2State extends State<StudentRegistration2> {
  final _formKey = GlobalKey<FormState>();

  final contactController = TextEditingController();
  final messengerController = TextEditingController();
  final instagramController = TextEditingController();
  final othersController = TextEditingController();

  static const _blue = Color(0xff3d6fa5);

  @override
  void dispose() {
    for (final c in [
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

  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: width),
      );

  InputDecoration _dec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
    bool required = true,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(label, required: required),
      TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: _dec(hint),
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

  String? validateOptionalField(String? v, String name) {
    if (v != null && v.isNotEmpty) {
      if (v.length < 3) return '$name is too short';
      if (v.length > 100) return '$name is too long (max 100 characters)';
      if ((name == 'Messenger' || name == 'Instagram') &&
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
            MaterialPageRoute(builder: (_) => const StudentRegistration1()),
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
                'Student Registration',
                style: TextStyle(color: Colors.black54, fontFamily: 'Arial'),
              ),
              const SizedBox(height: 25),

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
                validator: (v) => validateOptionalField(v, 'Messenger'),
                required: false,
              ),
              const SizedBox(height: 20),
              _field(
                'Instagram',
                instagramController,
                'Enter instagram account link',
                validator: (v) => validateOptionalField(v, 'Instagram'),
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
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Second step completed! Proceeding to next step...',
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
                            builder: (_) => const TermsandConditionsStudent(),
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
