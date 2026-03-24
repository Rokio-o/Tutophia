import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tutophia/widgets/tutor-widgets/profile-nav-tutor-wdgt.dart';
import 'package:tutophia/models/tutor-model/profile-tutor-data.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/services/repository/user_repository/user_repository.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/login.dart';

class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({super.key});

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  final TutorProfileModel profile = TutorProfileModel();
  String university = '';

  File? profileImage;
  String? profileImageUrl;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileFromFirestore();
  }

  String _asString(dynamic value) {
    if (value is String) return value;
    return '';
  }

  String _joinIfList(dynamic value) {
    if (value is Iterable) {
      return value
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .join(', ');
    }
    return _asString(value);
  }

  Future<void> _loadProfileFromFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final data = await UserRepository.instance.getUserProfile(uid);
    if (!mounted || data == null) return;

    final tutorType = _asString(data['tutorType']);
    final description = _asString(data['teachingDescription']).isNotEmpty
        ? _asString(data['teachingDescription'])
        : _asString(data['description']);
    final specialization = _joinIfList(data['specializations']);
    final mode = _joinIfList(data['modeOfTutoring']);
    final sessionRate = _asString(data['sessionRate']);
    final sessionRateMode = _asString(data['sessionRateMode']);
    final sessionDuration = _asString(data['sessionDurationHours']);

    setState(() {
      profile.firstName = _asString(data['firstName']).isNotEmpty
          ? _asString(data['firstName'])
          : profile.firstName;
      profile.lastName = _asString(data['lastName']).isNotEmpty
          ? _asString(data['lastName'])
          : profile.lastName;
      profile.selectedTutorType = tutorType.isNotEmpty
          ? tutorType
          : profile.selectedTutorType;
      profile.specialization = specialization.isNotEmpty
          ? specialization
          : profile.specialization;
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
      profile.tutorExp = _asString(data['tutoringExperience']).isNotEmpty
          ? _asString(data['tutoringExperience'])
          : profile.tutorExp;
      profile.mode = mode.isNotEmpty ? mode : profile.mode;
      profile.sessionDuration = sessionDuration.isNotEmpty
          ? '$sessionDuration hour(s)'
          : profile.sessionDuration;
      profile.sessionRate = sessionRate.isNotEmpty
          ? (sessionRateMode.isNotEmpty
                ? '$sessionRate ($sessionRateMode)'
                : sessionRate)
          : profile.sessionRate;
      profile.schedule = _asString(data['availableSchedule']).isNotEmpty
          ? _asString(data['availableSchedule'])
          : profile.schedule;
      profile.linkSchedule = _asString(data['scheduleLink']).isNotEmpty
          ? _asString(data['scheduleLink'])
          : profile.linkSchedule;
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
  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
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
                        (route) => false,
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

  // ---------- CONFIRM CHANGES DIALOG ----------
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
                  backgroundColor: const Color(0xFFEDEDED),
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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: profile.selectedTutorType,
                  isExpanded: true,
                  items: profile.tutorTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      profile.selectedTutorType = value!;
                    });
                  },
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
              'tutorType': profile.selectedTutorType,
            });
          }),
        ],
      ),
    );
  }

  // ---------- EDIT SPECIALIZATION ----------
  void editSpecialization() {
    TextEditingController specC = TextEditingController(
      text: profile.specialization,
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
            controller: specC,
            maxLines: 3,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        actions: [
          _dialogActions(() async {
            setState(() {
              profile.specialization = specC.text;
            });
            Navigator.pop(context);
            await _saveProfileChanges({
              'specializations': [profile.specialization],
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
              'teachingDescription': profile.description,
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
    TextEditingController tutorExpC = TextEditingController(
      text: profile.tutorExp,
    );
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
              const SizedBox(height: 12),
              buildBox(tutorExpC, "Tutoring Experience"),
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
              profile.tutorExp = tutorExpC.text;
            });
            Navigator.pop(context);
            await _saveProfileChanges({
              'university': university,
              'department': profile.department,
              'program': profile.program,
              'yearSpent': profile.year,
              'tutoringExperience': profile.tutorExp,
            });
          }),
        ],
      ),
    );
  }

  // ---------- EDIT TUTORING SERVICE ----------
  void editTutorService() {
    TextEditingController modeC = TextEditingController(text: profile.mode);
    TextEditingController sessionDurationC = TextEditingController(
      text: profile.sessionDuration,
    );
    TextEditingController sessionRateC = TextEditingController(
      text: profile.sessionRate,
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
        content: SingleChildScrollView(
          child: Column(
            children: [
              buildBox(modeC, "Mode"),
              const SizedBox(height: 12),
              buildBox(sessionDurationC, "Session Duration"),
              const SizedBox(height: 12),
              buildBox(sessionRateC, "Session Rate"),
            ],
          ),
        ),
        actions: [
          _dialogActions(() async {
            setState(() {
              profile.mode = modeC.text;
              profile.sessionDuration = sessionDurationC.text;
              profile.sessionRate = sessionRateC.text;
            });
            Navigator.pop(context);
            await _saveProfileChanges({
              'modeOfTutoring': [profile.mode],
              'sessionDurationHours': profile.sessionDuration,
              'sessionRate': profile.sessionRate,
            });
          }),
        ],
      ),
    );
  }

  // ---------- EDIT SCHEDULE ----------
  void editSchedule() {
    TextEditingController scheduleC = TextEditingController(
      text: profile.schedule,
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
        content: SingleChildScrollView(
          child: Column(children: [buildBox(scheduleC, "Available Schedule")]),
        ),
        actions: [
          _dialogActions(() async {
            setState(() {
              profile.schedule = scheduleC.text;
            });
            Navigator.pop(context);
            await _saveProfileChanges({'availableSchedule': profile.schedule});
          }),
        ],
      ),
    );
  }

  // ---------- EDIT LINK SCHEDULE ----------
  void editLinkSchedule() {
    TextEditingController linkScheduleC = TextEditingController(
      text: profile.linkSchedule,
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
        content: SingleChildScrollView(
          child: Column(
            children: [buildBox(linkScheduleC, "Link for Documented Schedule")],
          ),
        ),
        actions: [
          _dialogActions(() async {
            setState(() {
              profile.linkSchedule = linkScheduleC.text;
            });
            Navigator.pop(context);
            await _saveProfileChanges({'scheduleLink': profile.linkSchedule});
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
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
              onTap: pickImage,
              child: CircleAvatar(
                radius: 62,
                backgroundColor: const Color(0xFF000000),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : const AssetImage("assets/image/default_profile.jpg")
                            as ImageProvider,
                ),
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

            // TUTOR TYPE
            Text(
              profile.selectedTutorType,
              style: const TextStyle(color: Color(0xFF386FA4)),
            ),

            // AREA OF SPECIALIZATION
            centeredSectionCard(
              "Area of Specializations",
              profile.specialization,
              editSpecialization,
            ),

            // DESCRIPTION
            sectionCard(
              "Student Description",
              profile.description,
              editDescription,
            ),

            // ACADEMIC CREDENTIALS
            sectionCard(
              "Academic & Professional Credentials",
              "Institution/University: ${university.isEmpty ? 'N/A' : university}\nDepartment: ${profile.department}\nProgram: ${profile.program}\nYear: ${profile.year}\nTutoring Experience: ${profile.tutorExp}",
              editAcademic,
            ),

            // TUTORING SERVICES
            sectionCard(
              "Tutoring Services",
              "Mode: ${profile.mode}\nSession Duration: ${profile.sessionDuration}\nSession Rate: ${profile.sessionRate}",
              editTutorService,
            ),

            // AVAILABLE SCHEDULE
            sectionCard("Available Schedule", profile.schedule, editSchedule),

            // LINK FOR DOCUMENTED SCHEDULE
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Link for Documented Schedule",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF386FA4),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () => editLinkSchedule(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: Text(
                      profile.linkSchedule,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 25,
                    thickness: 1,
                    color: Colors.black12,
                  ),
                ],
              ),
            ),

            // CONTACT INFORMATION
            sectionCard(
              "Contact Information",
              "Email: ${profile.email}\nPhone: ${profile.phone}\nMessenger: ${profile.messenger}\nInstagram: ${profile.instagram}\nOthers: ${profile.others}",
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

      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (_) {},
        tabActions: [
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorDashboard()),
          ),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorNotificationScreen()),
          ),
          () {}, // already on profile
        ],
      ),
    );
  }
}
