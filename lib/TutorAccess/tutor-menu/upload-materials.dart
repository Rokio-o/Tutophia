import 'package:flutter/material.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/header-tutor-wdgt.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';
import 'package:tutophia/models/tutor-model/upload-materials-data.dart';
import 'package:tutophia/widgets/tutor-widgets/upload-materials-widget.dart';

// ── Upload Tab Enum ───────────────────────────────────────────────────────────

enum UploadTab { file, link }

// ── UploadMaterialsScreen ─────────────────────────────────────────────────────

class UploadMaterialsScreen extends StatefulWidget {
  const UploadMaterialsScreen({super.key});

  @override
  State<UploadMaterialsScreen> createState() => _UploadMaterialsScreenState();
}

class _UploadMaterialsScreenState extends State<UploadMaterialsScreen> {
  int _selectedNavIndex = 0;

  UploadTab _activeTab = UploadTab.file;

  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedStudent;
  final List<String> _uploadedFiles = [];

  @override
  void dispose() {
    _linkController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _pickFile() {
    setState(() {
      _uploadedFiles.add('document_${_uploadedFiles.length + 1}.pdf');
    });
  }

  void _onUpload() {
    if (_selectedStudent == null) {
      _showSnack('Please select a student first.');
      return;
    }
    if (_activeTab == UploadTab.file && _uploadedFiles.isEmpty) {
      _showSnack('Please choose at least one file.');
      return;
    }
    if (_activeTab == UploadTab.link && _linkController.text.trim().isEmpty) {
      _showSnack('Please paste a material link.');
      return;
    }

    final upload = UploadMaterialData(
      studentName: _selectedStudent!,
      files: List.from(_uploadedFiles),
      link: _linkController.text.trim(),
      note: _noteController.text.trim(),
    );

    debugPrint('Uploading: ${upload.studentName}, files: ${upload.files}');
    _showSnack('Uploaded successfully!');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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
            const HeaderTutorWdgt.uploadMaterials(),

            const SizedBox(height: 24),

            // ── Student Selector ──────────────────────────────────────────────
            StudentSelector(
              selectedStudent: _selectedStudent,
              onStudentSelected: (name) =>
                  setState(() => _selectedStudent = name),
              onClear: () => setState(() => _selectedStudent = null),
            ),

            const SizedBox(height: 20),

            // ── Tab + File/Link Content ───────────────────────────────────────
            MaterialTabSection(
              activeTab: _activeTab,
              uploadedFiles: _uploadedFiles,
              linkController: _linkController,
              onTabChanged: (tab) => setState(() => _activeTab = tab),
              onPickFile: _pickFile,
              onAddAnother: _pickFile,
              onRemoveFile: (i) => setState(() => _uploadedFiles.removeAt(i)),
            ),

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
            NoteField(controller: _noteController),

            const SizedBox(height: 30),

            // ── Upload Button ─────────────────────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _onUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D6FA5),
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
