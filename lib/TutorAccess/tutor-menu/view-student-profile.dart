import 'package:flutter/material.dart';
import 'package:tutophia/services/repository/user_repository/user_repository.dart';

class TutorStudentProfileScreen extends StatefulWidget {
  final String studentId;
  final String fallbackName;
  final String fallbackProgram;

  const TutorStudentProfileScreen({
    super.key,
    required this.studentId,
    this.fallbackName = '',
    this.fallbackProgram = '',
  });

  @override
  State<TutorStudentProfileScreen> createState() =>
      _TutorStudentProfileScreenState();
}

class _TutorStudentProfileScreenState extends State<TutorStudentProfileScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  String firstName = '';
  String lastName = '';
  String program = '';
  String description = '';
  String university = '';
  String department = '';
  String year = '';
  String gender = '';
  String age = '';
  String address = '';
  String email = '';
  String phone = '';
  String messenger = '';
  String instagram = '';
  String others = '';
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadStudentProfile();
  }

  String _asString(dynamic value) {
    if (value is String) return value.trim();
    if (value is num) return value.toString();
    return '';
  }

  String _displayValue(String value) {
    return value.trim().isEmpty ? 'Not provided' : value.trim();
  }

  Future<void> _loadStudentProfile() async {
    if (widget.studentId.trim().isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Student profile is unavailable for this booking.';
      });
      return;
    }

    try {
      final data = await UserRepository.instance.getUserProfile(
        widget.studentId,
      );
      if (!mounted) return;

      if (data == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Student profile could not be found.';
        });
        return;
      }

      setState(() {
        firstName = _asString(data['firstName']);
        lastName = _asString(data['lastName']);
        program = _asString(data['program']).isNotEmpty
            ? _asString(data['program'])
            : widget.fallbackProgram;
        description = _asString(data['studentDescription']).isNotEmpty
            ? _asString(data['studentDescription'])
            : _asString(data['description']);
        university = _asString(data['university']);
        department = _asString(data['department']);
        year = _asString(data['yearSpent']);
        gender = _asString(data['gender']);
        age = _asString(data['age']);
        address = _asString(data['address']);
        email = _asString(data['email']);
        phone = _asString(data['contactNumber']);
        messenger = _asString(data['messenger']);
        instagram = _asString(data['instagram']);
        others = _asString(data['otherAccounts']);
        final imageUrl = _asString(data['profileImageUrl']);
        profileImageUrl = imageUrl.isEmpty ? null : imageUrl;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load student profile right now.';
      });
    }
  }

  Widget _sectionCard(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F1E8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF386FA4),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullName = ([
      firstName,
      lastName,
    ]..removeWhere((part) => part.trim().isEmpty)).join(' ').trim();
    final displayName = fullName.isNotEmpty ? fullName : widget.fallbackName;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'STUDENT PROFILE',
          style: TextStyle(
            color: Color(0xFF386FA4),
            fontWeight: FontWeight.bold,
            fontFamily: 'Arimo',
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 62,
                      backgroundColor: const Color(0xFF000000),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: profileImageUrl != null
                            ? NetworkImage(profileImageUrl!)
                            : null,
                        child: profileImageUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      displayName.isEmpty ? 'Student' : displayName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _displayValue(program),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF386FA4),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _sectionCard(
                      'Student Description',
                      _displayValue(description),
                    ),
                    _sectionCard(
                      'Academic Information',
                      'Institution/University: ${_displayValue(university)}\n'
                          'Department: ${_displayValue(department)}\n'
                          'Program: ${_displayValue(program)}\n'
                          'Year: ${_displayValue(year)}',
                    ),
                    _sectionCard(
                      'Personal Information',
                      'Gender: ${_displayValue(gender)}\n'
                          'Age: ${_displayValue(age)}\n'
                          'Address: ${_displayValue(address)}',
                    ),
                    _sectionCard(
                      'Contact Information',
                      'Email: ${_displayValue(email)}\n'
                          'Phone: ${_displayValue(phone)}\n'
                          'Messenger: ${_displayValue(messenger)}\n'
                          'Instagram: ${_displayValue(instagram)}\n'
                          'Others: ${_displayValue(others)}',
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
