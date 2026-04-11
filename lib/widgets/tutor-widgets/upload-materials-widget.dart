import 'package:flutter/material.dart';
import 'package:tutophia/TutorAccess/tutor-menu/upload-materials.dart';
import 'package:tutophia/models/tutor-model/upload-materials-data.dart';

// ── Constants ─────────────────────────────────────────────────────────────────

const Color kPrimaryBlue = Color(0xFF3D6FA5);
const Color kAmber = Color(0xFFE8A020);
const Color kBeigeBg = Color(0xFFFEF7F0);
const Color kBorderColor = Color(0xFFD8D8D8);
const Color kLightGrey = Color(0xFFF5F5F5);

// ── StudentSelector ───────────────────────────────────────────────────────────

class StudentSelector extends StatelessWidget {
  final List<MaterialRecipient> recipients;
  final MaterialRecipient? selectedRecipient;
  final ValueChanged<MaterialRecipient> onStudentSelected;
  final VoidCallback onClear;

  const StudentSelector({
    super.key,
    required this.recipients,
    required this.selectedRecipient,
    required this.onStudentSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sent to student',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        StudentSearchBar(
          recipients: recipients,
          onStudentSelected: onStudentSelected,
        ),

        if (selectedRecipient != null) ...[
          const SizedBox(height: 10),
          SelectedStudentRow(recipient: selectedRecipient!, onClear: onClear),
        ],
      ],
    );
  }
}

// ── StudentSearchBar ──────────────────────────────────────────────────────────

class StudentSearchBar extends StatefulWidget {
  final List<MaterialRecipient> recipients;
  final ValueChanged<MaterialRecipient> onStudentSelected;

  const StudentSearchBar({
    super.key,
    required this.recipients,
    required this.onStudentSelected,
  });

  @override
  State<StudentSearchBar> createState() => _StudentSearchBarState();
}

class _StudentSearchBarState extends State<StudentSearchBar> {
  final TextEditingController _controller = TextEditingController();

  List<MaterialRecipient> _filtered = [];
  bool _showSuggestions = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = [];
        _showSuggestions = false;
      } else {
        _filtered = widget.recipients.where((recipient) {
          final normalized = query.toLowerCase();
          return recipient.studentName.toLowerCase().contains(normalized) ||
              recipient.subject.toLowerCase().contains(normalized) ||
              recipient.studentProgram.toLowerCase().contains(normalized);
        }).toList();
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
            controller: _controller,
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
        if (!_showSuggestions &&
            _controller.text.isNotEmpty &&
            widget.recipients.isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'No matching student bookings found.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        if (widget.recipients.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'No approved or completed bookings are available yet.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: kBorderColor),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _filtered.map((recipient) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _showSuggestions = false;
                      _controller.clear();
                    });
                    widget.onStudentSelected(recipient);
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipient.studentName,
                                style: const TextStyle(fontSize: 14),
                              ),
                              if (recipient.subtitle.isNotEmpty)
                                Text(
                                  recipient.subtitle,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                            ],
                          ),
                        ),
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

// ── SelectedStudentRow ────────────────────────────────────────────────────────

class SelectedStudentRow extends StatelessWidget {
  final MaterialRecipient recipient;
  final VoidCallback onClear;

  const SelectedStudentRow({
    super.key,
    required this.recipient,
    required this.onClear,
  });

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipient.studentName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (recipient.subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      recipient.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (recipient.bookingId.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.bookmark_outline,
                size: 16,
                color: kPrimaryBlue,
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

// ── MaterialTabSection ────────────────────────────────────────────────────────

class MaterialTabSection extends StatelessWidget {
  final UploadTab activeTab;
  final List<String> uploadedFiles;
  final TextEditingController linkController;
  final ValueChanged<UploadTab> onTabChanged;
  final VoidCallback onPickFile;
  final VoidCallback onAddAnother;
  final ValueChanged<int> onRemoveFile;

  const MaterialTabSection({
    super.key,
    required this.activeTab,
    required this.uploadedFiles,
    required this.linkController,
    required this.onTabChanged,
    required this.onPickFile,
    required this.onAddAnother,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Tab Toggle ────────────────────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: UploadTabButton(
                label: 'File Upload',
                isActive: activeTab == UploadTab.file,
                isLeft: true,
                onTap: () => onTabChanged(UploadTab.file),
              ),
            ),
            Expanded(
              child: UploadTabButton(
                label: 'Link',
                isActive: activeTab == UploadTab.link,
                isLeft: false,
                onTap: () => onTabChanged(UploadTab.link),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ── Tab Content ───────────────────────────────────────────────────────
        if (activeTab == UploadTab.file)
          FileUploadSection(
            uploadedFiles: uploadedFiles,
            onPickFile: onPickFile,
            onAddAnother: onAddAnother,
            onRemoveFile: onRemoveFile,
          )
        else
          LinkUploadSection(controller: linkController),
      ],
    );
  }
}

// ── UploadTabButton ───────────────────────────────────────────────────────────

class UploadTabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isLeft;
  final VoidCallback onTap;

  const UploadTabButton({
    super.key,
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

// ── FileUploadSection ─────────────────────────────────────────────────────────

class FileUploadSection extends StatelessWidget {
  final List<String> uploadedFiles;
  final VoidCallback onPickFile;
  final VoidCallback onAddAnother;
  final ValueChanged<int> onRemoveFile;

  const FileUploadSection({
    super.key,
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
                          decoration: const BoxDecoration(
                            color: kAmber,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomLeft: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
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
                              color: kAmber.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                if (uploadedFiles.isNotEmpty) ...[
                  ...List.generate(uploadedFiles.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFD),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kBorderColor),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.insert_drive_file_outlined,
                              size: 14,
                              color: kPrimaryBlue,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                uploadedFiles[i],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: kPrimaryBlue,
                                ),
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

// ── LinkUploadSection ─────────────────────────────────────────────────────────

class LinkUploadSection extends StatelessWidget {
  final TextEditingController controller;

  const LinkUploadSection({super.key, required this.controller});

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

// ── NoteField ─────────────────────────────────────────────────────────────────

class NoteField extends StatelessWidget {
  final TextEditingController controller;

  const NoteField({super.key, required this.controller});

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
