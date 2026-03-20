import 'package:flutter/material.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';

// ── Constants ─────────────────────────────────────────────────────────────────

const Color kPrimaryBlue = Color(0xFF3D6FA5);
const Color kAmber = Color(0xFFE8A020);
const Color kBeigeBg = Color(0xFFFEF7F0);
const Color kBorderColor = Color(0xFFD8D8D8);
const Color kLightGrey = Color(0xFFF5F5F5);

// ── Upload Tab Enum ───────────────────────────────────────────────────────────

enum _UploadTab { file, link }

// ── UploadMaterialsScreen ─────────────────────────────────────────────────────

class UploadMaterialsScreen extends StatefulWidget {
  const UploadMaterialsScreen({super.key});

  @override
  State<UploadMaterialsScreen> createState() => _UploadMaterialsScreenState();
}

class _UploadMaterialsScreenState extends State<UploadMaterialsScreen> {
  int _selectedNavIndex = 0;

  _UploadTab _activeTab = _UploadTab.file;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedStudent; // populated after search selection
  final List<String> _uploadedFiles = []; // tracks added files

  @override
  void dispose() {
    _searchController.dispose();
    _linkController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // ── Simulate file pick ─────────────────────────────────────────────────────
  void _pickFile() {
    // Replace with actual file_picker integration
    setState(() {
      _uploadedFiles.add('document_${_uploadedFiles.length + 1}.pdf');
    });
  }

  void _addAnotherFile() => _pickFile();

  void _onUpload() {
    if (_selectedStudent == null) {
      _showSnack('Please select a student first.');
      return;
    }
    if (_activeTab == _UploadTab.file && _uploadedFiles.isEmpty) {
      _showSnack('Please choose at least one file.');
      return;
    }
    if (_activeTab == _UploadTab.link && _linkController.text.trim().isEmpty) {
      _showSnack('Please paste a material link.');
      return;
    }
    _showSnack('Uploaded successfully!');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ── AppBar ─────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UPLOAD MATERIALS',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3d6fa5),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Provide supplementary materials to\nenhance the learning session.',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/tutophia-logo-white-outline.png',
                  height: 60,
                  width: 60,
                  errorBuilder: (c, e, s) => const Icon(Icons.school, size: 40),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Sent to Student ───────────────────────────────────────────────
            const Text(
              'Sent to student',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Search bar
            _SearchBar(
              controller: _searchController,
              onStudentSelected: (name) {
                setState(() => _selectedStudent = name);
                _searchController.clear();
              },
            ),

            // Selected student chip
            if (_selectedStudent != null) ...[
              const SizedBox(height: 10),
              _SelectedStudentRow(
                studentName: _selectedStudent!,
                onClear: () => setState(() => _selectedStudent = null),
              ),
            ],

            const SizedBox(height: 20),

            // ── Tab Toggle ────────────────────────────────────────────────────
            _TabToggle(
              active: _activeTab,
              onTabChanged: (tab) => setState(() => _activeTab = tab),
            ),

            const SizedBox(height: 20),

            // ── Tab Content ───────────────────────────────────────────────────
            if (_activeTab == _UploadTab.file)
              _FileUploadSection(
                uploadedFiles: _uploadedFiles,
                onPickFile: _pickFile,
                onAddAnother: _addAnotherFile,
                onRemoveFile: (i) => setState(() => _uploadedFiles.removeAt(i)),
              )
            else
              _LinkUploadSection(controller: _linkController),

            const SizedBox(height: 20),

            // ── Note ──────────────────────────────────────────────────────────
            const Text(
              'Note',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _NoteField(controller: _noteController),

            const SizedBox(height: 30),

            // ── Upload Button ─────────────────────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _onUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'UPLOAD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // ── Bottom Nav ─────────────────────────────────────────────────────────
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        tabActions: [
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorDashboard()),
          ),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorNotificationScreen()),
          ),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorProfileScreen()),
          ),
        ],
      ),
    );
  }
}

// ── _SearchBar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onStudentSelected;

  const _SearchBar({required this.controller, required this.onStudentSelected});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  // Mock student list — replace with real data source
  final List<String> _allStudents = [
    'Isaac Rei Aniceta',
    'Wenifredo Santos',
    'Maria Clara Reyes',
    'Jose Pablo Dela Cruz',
  ];

  List<String> _filtered = [];
  bool _showSuggestions = false;

  void _onChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = [];
        _showSuggestions = false;
      } else {
        _filtered = _allStudents
            .where((s) => s.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _showSuggestions = _filtered.isNotEmpty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: kLightGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: widget.controller,
            onChanged: _onChanged,
            decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 13,
              ),
            ),
          ),
        ),

        // Dropdown suggestions
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: kBorderColor),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _filtered.map((name) {
                return InkWell(
                  onTap: () {
                    setState(() => _showSuggestions = false);
                    widget.onStudentSelected(name);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(name, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

// ── _SelectedStudentRow ───────────────────────────────────────────────────────

class _SelectedStudentRow extends StatelessWidget {
  final String studentName;
  final VoidCallback onClear;

  const _SelectedStudentRow({required this.studentName, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kBeigeBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kBorderColor),
      ),
      child: Row(
        children: [
          const Text(
            'Sending to',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              studentName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close, size: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ── _TabToggle ────────────────────────────────────────────────────────────────

class _TabToggle extends StatelessWidget {
  final _UploadTab active;
  final ValueChanged<_UploadTab> onTabChanged;

  const _TabToggle({required this.active, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabButton(
            label: 'File Upload',
            isActive: active == _UploadTab.file,
            isLeft: true,
            onTap: () => onTabChanged(_UploadTab.file),
          ),
        ),
        Expanded(
          child: _TabButton(
            label: 'Link',
            isActive: active == _UploadTab.link,
            isLeft: false,
            onTap: () => onTabChanged(_UploadTab.link),
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isLeft;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.isLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromARGB(255, 191, 223, 253)
              : Colors.white,
          border: Border.all(color: kBorderColor),
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(8) : Radius.zero,
            right: !isLeft ? const Radius.circular(8) : Radius.zero,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

// ── _FileUploadSection ────────────────────────────────────────────────────────

class _FileUploadSection extends StatelessWidget {
  final List<String> uploadedFiles;
  final VoidCallback onPickFile;
  final VoidCallback onAddAnother;
  final ValueChanged<int> onRemoveFile;

  const _FileUploadSection({
    required this.uploadedFiles,
    required this.onPickFile,
    required this.onAddAnother,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drop zone
        GestureDetector(
          onTap: onPickFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: kBorderColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // File icon
                SizedBox(
                  width: 60,
                  height: 72,
                  child: Stack(
                    children: [
                      Container(
                        width: 54,
                        height: 68,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: kAmber, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: kAmber,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomLeft: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      // Lined paper effect
                      Positioned(
                        top: 24,
                        left: 10,
                        child: Column(
                          children: List.generate(
                            4,
                            (_) => Container(
                              width: 34,
                              height: 1.5,
                              margin: const EdgeInsets.only(bottom: 5),
                              color: kAmber.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Uploaded file chips
                if (uploadedFiles.isNotEmpty) ...[
                  ...List.generate(uploadedFiles.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.insert_drive_file_outlined,
                            size: 14,
                            color: kPrimaryBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            uploadedFiles[i],
                            style: const TextStyle(
                              fontSize: 12,
                              color: kPrimaryBlue,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => onRemoveFile(i),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 6),
                ],

                GestureDetector(
                  onTap: onPickFile,
                  child: const Text(
                    'Choose a file to upload',
                    style: TextStyle(
                      fontSize: 13,
                      color: kPrimaryBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Add Another File
        GestureDetector(
          onTap: onAddAnother,
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kAmber, width: 1.5),
                ),
                child: const Icon(Icons.add, size: 14, color: kAmber),
              ),
              const SizedBox(width: 8),
              const Text(
                'Add Another File',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── _LinkUploadSection ────────────────────────────────────────────────────────

class _LinkUploadSection extends StatelessWidget {
  final TextEditingController controller;

  const _LinkUploadSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Material Link',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Paste the link of the material',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kPrimaryBlue),
            ),
          ),
        ),
      ],
    );
  }
}

// ── _NoteField ────────────────────────────────────────────────────────────────

class _NoteField extends StatelessWidget {
  final TextEditingController controller;

  const _NoteField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Add a description or comment about the file',
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kPrimaryBlue),
        ),
      ),
    );
  }
}
