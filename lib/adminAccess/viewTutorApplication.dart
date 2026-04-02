import 'package:flutter/material.dart';
import 'package:tutophia/models/admin-model/applications-data.dart';
import 'package:tutophia/widgets/admin-widgets/applicationDialogues.dart';

// ── Read-only section card (mirrors sectionCard from profile-nav-tutor-wdgt) ──

Widget _sectionCard(String title, String content) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black54),
          ),
          child: Text(
            content.isEmpty ? '—' : content,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const Divider(height: 25, thickness: 1, color: Colors.black12),
      ],
    ),
  );
}

// ── Centered specializations card ─────────────────────────────────────────────

Widget _centeredSectionCard(String title, String content) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black54),
          ),
          child: Text(
            content.isEmpty ? '—' : content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const Divider(height: 25, thickness: 1, color: Colors.black12),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  AdminViewTutorApplication
// ─────────────────────────────────────────────────────────────────────────────

class AdminViewTutorApplication extends StatefulWidget {
  final TutorApplicationModel application;
  final void Function(ApplicationStatus status, {String? rejectReason})
  onStatusChanged;

  const AdminViewTutorApplication({
    super.key,
    required this.application,
    required this.onStatusChanged,
  });

  @override
  State<AdminViewTutorApplication> createState() =>
      _AdminViewTutorApplicationState();
}

class _AdminViewTutorApplicationState extends State<AdminViewTutorApplication> {
  late ApplicationStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.application.status;
  }

  // ── APPROVE FLOW ─────────────────────────────────────────────────────────────
  void _handleApprove() {
    ConfirmApproveDialog.show(
      context,
      onConfirm: () {
        ApprovedSuccessDialog.show(
          context,
          onOkay: () {
            setState(() => _currentStatus = ApplicationStatus.approved);
            widget.onStatusChanged(ApplicationStatus.approved);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // ── REJECT FLOW ──────────────────────────────────────────────────────────────
  void _handleReject() {
    RejectReasonDialog.show(
      context,
      onReject: (reason) {
        RejectedResultDialog.show(
          context,
          onOkay: () {
            setState(() => _currentStatus = ApplicationStatus.rejected);
            widget.onStatusChanged(
              ApplicationStatus.rejected,
              rejectReason: reason,
            );
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // ── STATUS BADGE ─────────────────────────────────────────────────────────────
  Widget _statusBadge() {
    Color color;
    String label;
    switch (_currentStatus) {
      case ApplicationStatus.approved:
        color = const Color(0xFF2E7D32);
        label = 'Approved';
        break;
      case ApplicationStatus.rejected:
        color = const Color(0xFFEF1C0D);
        label = 'Rejected';
        break;
      default:
        color = const Color(0xFF3D6FA5);
        label = 'Pending';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  // ── BUILD ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final app = widget.application;
    final isPending = _currentStatus == ApplicationStatus.pending;

    return Scaffold(
      backgroundColor: Colors.white,

      // ── AppBar ───────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "TUTOR APPLICATION",
          style: TextStyle(
            fontFamily: 'Arimo',
            color: Color(0xFF386FA4),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                'assets/images/tutophia-logo-white-outline.png',
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const Icon(
                  Icons.school,
                  color: Color(0xFF386FA4),
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Body ─────────────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Profile Picture ───────────────────────────────────────────────
            CircleAvatar(
              radius: 62,
              backgroundColor: const Color(0xFF000000),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFFE8F0FB),
                child: app.hasImage && app.image.isNotEmpty
                    ? ClipOval(
                        child: Image.asset(
                          app.image,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                          errorBuilder: (c, e, s) => const Icon(
                            Icons.person,
                            size: 60,
                            color: Color(0xFF386FA4),
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFF386FA4),
                      ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Name ─────────────────────────────────────────────────────────
            Text(
              app.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // ── Tutor type subtitle ───────────────────────────────────────────
            Text(
              'Tutor · ${app.specialization}',
              style: const TextStyle(color: Color(0xFF386FA4)),
            ),

            const SizedBox(height: 8),
            _statusBadge(),
            const SizedBox(height: 20),

            // ── Area of Specializations ───────────────────────────────────────
            _centeredSectionCard("Area of Specializations", app.specialization),

            // ── Tutor Description ─────────────────────────────────────────────
            _sectionCard("Tutor Description", app.bio),

            // ── Academic & Professional Credentials ───────────────────────────
            _sectionCard(
              "Academic & Professional Credentials",
              "Institution: ${app.academicInstitution}"
                  "\nDegree: ${app.degree}"
                  "\nTutoring Experience: ${app.yearsOfExperience}",
            ),

            // ── Subjects Taught ───────────────────────────────────────────────
            _sectionCard(
              "Subjects Taught",
              app.subjectsTaught.isEmpty ? '—' : app.subjectsTaught.join(', '),
            ),

            // ── Tutoring Services (placeholder — no model fields yet) ─────────
            _sectionCard(
              "Tutoring Services",
              "Mode: —\nSession Duration: —\nSession Rate: —",
            ),

            // ── Available Schedule ────────────────────────────────────────────
            _sectionCard("Available Schedule", app.availability),

            // ── Link for Portfolio or Source of Tutoring Evidence ─────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Link for Portfolio or Source of Tutoring Evidence",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF386FA4),
                    ),
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
                      app.portfolioLink.isEmpty ? '—' : app.portfolioLink,
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

            // ── Contact Information ───────────────────────────────────────────
            _sectionCard(
              "Contact Information",
              "Email: ${app.email}"
                  "\nPhone: ${app.contactNumber}"
                  "\nMessenger: ${app.messengerHandle}"
                  "\nInstagram: ${app.instagramHandle}",
            ),

            // ── Uploaded ID (placeholder) ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Uploaded ID",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF386FA4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 52,
                          color: Colors.black38,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "ID image will appear here",
                          style: TextStyle(fontSize: 13, color: Colors.black38),
                        ),
                      ],
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

            // ── Rejection Reason (shown when rejected) ────────────────────────
            if (_currentStatus == ApplicationStatus.rejected &&
                (app.rejectReason?.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rejection Reason",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEF1C0D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFEF9A9A)),
                      ),
                      child: Text(
                        app.rejectReason!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFB71C1C),
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

            const SizedBox(height: 8),

            // ── Approve / Reject Buttons (pending only) ───────────────────────
            if (isPending)
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _handleReject,
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text(
                          "Reject",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF1C0D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _handleApprove,
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text(
                          "Approve",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
