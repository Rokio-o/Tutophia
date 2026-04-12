import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tutophia/models/student-model/profile-student_data.dart';
import 'package:tutophia/services/repository/user_repository/user_repository.dart';
import 'package:tutophia/widgets/student-widgets/bottom-navigation-student.dart';
import 'package:tutophia/widgets/student-widgets/profile-nav-student-wdgt.dart';
import 'package:tutophia/StudentAccess/dashboard-student.dart';
import 'package:tutophia/StudentAccess/notifications-student.dart';
import 'package:tutophia/login.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final StudentProfileModel profile = StudentProfileModel();
  String university = '';

  String? profileImageUrl;
  final ImagePicker picker = ImagePicker();
  bool _isUploadingProfileImage = false;

  @override
  void initState() {
    super.initState();
    _loadProfileFromFirestore();
  }

  String _asString(dynamic value) {
    if (value is String) return value;
    return '';
  }

  String _displayValue(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? 'Not provided' : trimmed;
  }

  Future<void> _loadProfileFromFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final data = await UserRepository.instance.getUserProfile(uid);
    if (!mounted || data == null) return;

    final description = _asString(data['studentDescription']).isNotEmpty
        ? _asString(data['studentDescription'])
        : _asString(data['description']);

    setState(() {
      profile.firstName = _asString(data['firstName']).isNotEmpty
          ? _asString(data['firstName'])
          : profile.firstName;
      profile.lastName = _asString(data['lastName']).isNotEmpty
          ? _asString(data['lastName'])
          : profile.lastName;
      profile.description = description.isNotEmpty
          ? description
          : profile.description;
      profile.department = _asString(data['department']).isNotEmpty
          ? _asString(data['department'])
          : profile.department;
      profile.program = _asString(data['program']).isNotEmpty
          ? _asString(data['program'])
          : profile.program;
      profile.year = _asString(data['yearSpent']).isNotEmpty
          ? _asString(data['yearSpent'])
          : profile.year;
      university = _asString(data['university']).isNotEmpty
          ? _asString(data['university'])
          : university;
      profile.email = _asString(data['email']).isNotEmpty
          ? _asString(data['email'])
          : profile.email;
      profile.phone = _asString(data['contactNumber']).isNotEmpty
          ? _asString(data['contactNumber'])
          : profile.phone;
      profile.messenger = _asString(data['messenger']).isNotEmpty
          ? _asString(data['messenger'])
          : profile.messenger;
      profile.instagram = _asString(data['instagram']).isNotEmpty
          ? _asString(data['instagram'])
          : profile.instagram;
      profile.others = _asString(data['otherAccounts']).isNotEmpty
          ? _asString(data['otherAccounts'])
          : profile.others;

      final imageUrl = _asString(data['profileImageUrl']);
      profileImageUrl = imageUrl.isNotEmpty ? imageUrl : null;
    });
  }

  Future<void> _saveProfileChanges(Map<String, dynamic> updates) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await UserRepository.instance.updateUserProfile(
        uid: uid,
        updates: updates,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ---------- PICK IMAGE ----------
  Future<void> pickImage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || _isUploadingProfileImage) return;

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
    );
    if (picked == null) return;

    setState(() => _isUploadingProfileImage = true);

    try {
      final imageData = await UserRepository.instance.updateProfileImage(
        uid: uid,
        imageFile: File(picked.path),
      );

      if (!mounted) return;

      setState(() {
        profileImageUrl = imageData['profileImageUrl'];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile picture. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploadingProfileImage = false);
      }
    }
  }

  // ---------- LOGOUT DIALOG ----------
  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            "Are you sure you\nwant to logout?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEDEDED),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                        (route) => false, // clears entire nav stack
                      );
                    },
                    child: const Text("Logout"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- CONFIRM SAVE DIALOG ----------
  void confirmSave() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const SizedBox(
            width: 300,
            height: 100,
            child: Center(
              child: Text("Save Changes?", style: TextStyle(fontSize: 20)),
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text("No", style: TextStyle(fontSize: 18)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text("Yes", style: TextStyle(fontSize: 18)),
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SizedBox(
                              width: 300,
                              height: 100,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    "Profile Saved!",
                                    style: TextStyle(
                                      color: Color(0xFF007D13),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              Center(
                                child: TextButton(
                                  child: const Text(
                                    "Okay",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------- SHARED DIALOG ACTIONS ----------
  Widget _dialogActions(Future<void> Function() onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Go back"),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A6EA5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await onSave();
                },
                child: const Text("Save"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- EDIT NAME ----------
  void editName() {
    TextEditingController first = TextEditingController(
      text: profile.firstName,
    );
    TextEditingController last = TextEditingController(text: profile.lastName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "EDIT",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF386FA4),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: first,
                decoration: const InputDecoration(
                  labelText: "First Name",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: last,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          _dialogActions(() async {
            setState(() {
              profile.firstName = first.text;
              profile.lastName = last.text;
            });
            Navigator.pop(context);
            await _saveProfileChanges({
              'firstName': profile.firstName,
              'lastName': profile.lastName,
            });
          }),
        ],
      ),
    );
  }

  // ---------- EDIT DESCRIPTION ----------
  void editDescription() {
    TextEditingController desc = TextEditingController(
      text: profile.description,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "EDIT",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF386FA4),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: desc,
            maxLines: 4,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        actions: [
          _dialogActions(() async {
            setState(() {
              profile.description = desc.text;
            });
            Navigator.pop(context);
            await _saveProfileChanges({
              'studentDescription': profile.description,
            });
          }),
        ],
      ),
    );
  }

  // ---------- EDIT ACADEMIC CREDENTIALS ----------
  void editAcademic() {
    TextEditingController departmentC = TextEditingController(
      text: profile.department,
    );
    TextEditingController programC = TextEditingController(
      text: profile.program,
    );
    TextEditingController yearC = TextEditingController(text: profile.year);
    TextEditingController universityC = TextEditingController(text: university);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "EDIT",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF386FA4),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              buildBox(universityC, "Institution / University"),
              const SizedBox(height: 12),
              buildBox(departmentC, "Department"),
              const SizedBox(height: 12),
              buildBox(programC, "Program"),
              const SizedBox(height: 12),
              buildBox(yearC, "Year"),
            ],
          ),
        ),
        actions: [
          _dialogActions(() async {
            setState(() {
              university = universityC.text;
              profile.department = departmentC.text;
              profile.program = programC.text;
              profile.year = yearC.text;
            });
            Navigator.pop(context);
            await _saveProfileChanges({
              'university': university,
              'department': profile.department,
              'program': profile.program,
              'yearSpent': profile.year,
            });
          }),
        ],
      ),
    );
  }

  // ---------- EDIT CONTACT ----------
  void editContact() {
    TextEditingController emailC = TextEditingController(text: profile.email);
    TextEditingController phoneC = TextEditingController(text: profile.phone);
    TextEditingController messengerC = TextEditingController(
      text: profile.messenger,
    );
    TextEditingController instaC = TextEditingController(
      text: profile.instagram,
    );
    TextEditingController othersC = TextEditingController(text: profile.others);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "EDIT",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF386FA4),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              buildBox(emailC, "Email"),
              const SizedBox(height: 12),
              buildBox(phoneC, "Phone"),
              const SizedBox(height: 12),
              buildBox(messengerC, "Messenger"),
              const SizedBox(height: 12),
              buildBox(instaC, "Instagram"),
              const SizedBox(height: 12),
              buildBox(othersC, "Others"),
            ],
          ),
        ),
        actions: [
          _dialogActions(() async {
            setState(() {
              profile.email = emailC.text;
              profile.phone = phoneC.text;
              profile.messenger = messengerC.text;
              profile.instagram = instaC.text;
              profile.others = othersC.text;
            });
            Navigator.pop(context);
            await _saveProfileChanges({
              'email': profile.email,
              'contactNumber': profile.phone,
              'messenger': profile.messenger,
              'instagram': profile.instagram,
              'otherAccounts': profile.others,
            });
          }),
        ],
      ),
    );
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          "PROFILE",
          style: TextStyle(
            fontFamily: 'Arimo',
            color: Color(0xFF386FA4),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFD32F2F)),
            tooltip: 'Logout',
            onPressed: _showLogoutDialog,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PROFILE PICTURE
            GestureDetector(
              onTap: _isUploadingProfileImage ? null : pickImage,
              child: Stack(
                alignment: Alignment.center,
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
                  if (_isUploadingProfileImage)
                    const CircleAvatar(
                      radius: 62,
                      backgroundColor: Color(0x88000000),
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // NAME + EDIT ICON
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${profile.firstName} ${profile.lastName}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: editName,
                  child: const Icon(Icons.edit, size: 18, color: Colors.grey),
                ),
              ],
            ),

            // PROGRAM SUBTITLE
            Text(
              profile.program,
              style: const TextStyle(color: Color(0xFF386FA4)),
            ),

            const SizedBox(height: 20),

            // STUDENT DESCRIPTION
            sectionCard(
              "Student Description",
              profile.description,
              editDescription,
            ),

            // ACADEMIC CREDENTIALS
            sectionCard(
              "Academic & Professional Credentials",
              "Institution/University: ${university.isEmpty ? 'N/A' : university}\nDepartment: ${profile.department}\nProgram: ${profile.program}\nYear: ${profile.year}",
              editAcademic,
            ),

            // CONTACT INFORMATION
            sectionCard(
              "Contact Information",
              "Email: ${_displayValue(profile.email)}\nPhone: ${_displayValue(profile.phone)}\nMessenger: ${_displayValue(profile.messenger)}\nInstagram: ${_displayValue(profile.instagram)}\nOthers: ${_displayValue(profile.others)}",
              editContact,
            ),

            const SizedBox(height: 20),

            // LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _showLogoutDialog,
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavStudent(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const StudentDashboard()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const StudentNotificationsScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}
