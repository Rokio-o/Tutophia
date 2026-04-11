import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/header-tutor-wdgt.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';
import 'package:tutophia/data/tutor-data/upload-materials-repository.dart';
import 'package:tutophia/models/student-model/session-material_data.dart';
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
  final UploadMaterialsRepository _repository =
      UploadMaterialsRepository.instance;

  int _selectedNavIndex = 0;

  UploadTab _activeTab = UploadTab.file;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  MaterialRecipient? _selectedRecipient;
  final List<PlatformFile> _uploadedFiles = [];
  late final Future<List<MaterialRecipient>> _recipientsFuture;
  bool _isUploading = false;

  String? get _currentTutorId => FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _recipientsFuture = _repository.fetchRecipientsForCurrentTutor();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.any,
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final files = result.files
        .where((file) => file.bytes != null && file.bytes!.isNotEmpty)
        .toList();

    if (files.isEmpty) {
      _showSnack('The selected files could not be read. Please try again.');
      return;
    }

    setState(() {
      _uploadedFiles.addAll(files);
    });

    if (_titleController.text.trim().isEmpty) {
      _titleController.text = _stripExtension(files.first.name);
    }
  }

  Future<void> _onUpload() async {
    if (_selectedRecipient == null) {
      _showSnack('Please select a booking or student first.');
      return;
    }

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _showSnack('Please enter a title first.');
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

    setState(() => _isUploading = true);

    try {
      if (_activeTab == UploadTab.file) {
        for (var index = 0; index < _uploadedFiles.length; index += 1) {
          final file = _uploadedFiles[index];
          final uploadTitle = _uploadedFiles.length == 1
              ? title
              : '$title (${index + 1})';

          await _repository.uploadMaterial(
            UploadMaterialData(
              title: uploadTitle,
              description: _noteController.text.trim(),
              recipient: _selectedRecipient!,
              fileName: file.name,
              fileBytes: file.bytes,
              contentType: _guessContentType(file.name),
              fileSizeBytes: file.size,
            ),
          );
        }
      } else {
        final link = _linkController.text.trim();
        await _repository.uploadMaterial(
          UploadMaterialData(
            title: title,
            description: _noteController.text.trim(),
            recipient: _selectedRecipient!,
            fileName: _fileNameFromLink(link),
            contentType: 'text/uri-list',
            externalUrl: link,
          ),
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _uploadedFiles.clear();
        _linkController.clear();
        _noteController.clear();
        _titleController.clear();
      });

      _showSnack('Material uploaded successfully.');
    } catch (error) {
      _showSnack(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _archiveMaterial(SessionMaterialData material) async {
    try {
      await _repository.archiveMaterial(material.materialId);
      if (!mounted) {
        return;
      }
      _showSnack('Material archived.');
    } catch (error) {
      _showSnack('Failed to archive material.');
    }
  }

  Future<void> _deleteMaterial(SessionMaterialData material) async {
    try {
      await _repository.deleteMaterial(material);
      if (!mounted) {
        return;
      }
      _showSnack('Material deleted.');
    } catch (error) {
      _showSnack(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  String _guessContentType(String fileName) {
    final extension = _extensionFrom(fileName);
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      default:
        return 'application/octet-stream';
    }
  }

  String _extensionFrom(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex < 0 || dotIndex == fileName.length - 1) {
      return '';
    }
    return fileName.substring(dotIndex + 1).toLowerCase();
  }

  String _stripExtension(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex <= 0) {
      return fileName;
    }
    return fileName.substring(0, dotIndex);
  }

  String _fileNameFromLink(String link) {
    final uri = Uri.tryParse(link);
    if (uri == null || uri.pathSegments.isEmpty) {
      return 'external-link';
    }
    final lastSegment = uri.pathSegments.last.trim();
    return lastSegment.isEmpty ? 'external-link' : lastSegment;
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

            const Text(
              'Title',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter the material title',
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

            const SizedBox(height: 20),

            // ── Student Selector ──────────────────────────────────────────────
            FutureBuilder<List<MaterialRecipient>>(
              future: _recipientsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return StudentSelector(
                  recipients: snapshot.data ?? const [],
                  selectedRecipient: _selectedRecipient,
                  onStudentSelected: (recipient) =>
                      setState(() => _selectedRecipient = recipient),
                  onClear: () => setState(() => _selectedRecipient = null),
                );
              },
            ),

            const SizedBox(height: 20),

            // ── Tab + File/Link Content ───────────────────────────────────────
            MaterialTabSection(
              activeTab: _activeTab,
              uploadedFiles: _uploadedFiles
                  .map((file) => file.name)
                  .toList(growable: false),
              linkController: _linkController,
              onTabChanged: (tab) => setState(() => _activeTab = tab),
              onPickFile: () => _pickFile(),
              onAddAnother: () => _pickFile(),
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
                onPressed: _isUploading ? null : _onUpload,
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
                child: _isUploading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
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

            if (_currentTutorId != null) ...[
              const Text(
                'Uploaded Materials',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<SessionMaterialData>>(
                stream: _repository.watchTutorMaterials(_currentTutorId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Unable to load uploaded materials right now.',
                      style: TextStyle(color: Colors.black54),
                    );
                  }

                  final materials = snapshot.data ?? const [];
                  if (materials.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kLightGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'No materials uploaded yet.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  return Column(
                    children: materials
                        .map((material) {
                          final isArchived =
                              material.status ==
                              SessionMaterialData.statusArchived;

                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kBorderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        material.title,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isArchived
                                            ? Colors.grey.shade200
                                            : const Color(0xFFD9E8F7),
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                      child: Text(
                                        isArchived ? 'Archived' : 'Active',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isArchived
                                              ? Colors.black54
                                              : kPrimaryBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Student: ${material.studentName.isNotEmpty ? material.studentName : 'Not specified'}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                                if (material.subject.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Subject: ${material.subject}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    material.fileName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (!isArchived)
                                      TextButton(
                                        onPressed: () =>
                                            _archiveMaterial(material),
                                        child: const Text('Archive'),
                                      ),
                                    TextButton(
                                      onPressed: () =>
                                          _deleteMaterial(material),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red.shade600,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        })
                        .toList(growable: false),
                  );
                },
              ),
            ],

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
