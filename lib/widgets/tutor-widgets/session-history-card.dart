import 'package:flutter/material.dart';

// ── Constants ─────────────────────────────────────────────────────────────────

const Color kSessionBlue = Color(0xFF3D6FA5);
const Color kSessionBeige = Color(0xFFFEF7F0);
const Color kSessionBorder = Color(0xFFE0E0E0);

// ── SessionStudentData ────────────────────────────────────────────────────────

class SessionStudentData {
  final String id;
  final String name;
  final String program;
  final String imagePath;

  const SessionStudentData({
    required this.id,
    required this.name,
    required this.program,
    this.imagePath = '',
  });
}

// ── SessionHistoryCard ────────────────────────────────────────────────────────
// Card with two states:
//   • Collapsed — shows name, program, and a "Select Action" link
//   • Expanded  — shows name, program, and two action buttons:
//                 "Give feedback" and "Give materials"
//
// Tapping "Select Action" expands the card.
// [onGiveFeedback] and [onGiveMaterials] are called from the expanded state.

class SessionHistoryCard extends StatefulWidget {
  final SessionStudentData student;
  final VoidCallback? onGiveFeedback;
  final VoidCallback? onGiveMaterials;

  /// If true the card starts expanded. Default: false.
  final bool initiallyExpanded;

  const SessionHistoryCard({
    super.key,
    required this.student,
    this.onGiveFeedback,
    this.onGiveMaterials,
    this.initiallyExpanded = false,
  });

  @override
  State<SessionHistoryCard> createState() => _SessionHistoryCardState();
}

class _SessionHistoryCardState extends State<SessionHistoryCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kSessionBeige,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kSessionBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: name / program / action ────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Name + program
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.student.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.student.program,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // "Select Action" — only shown when collapsed
                if (!_expanded)
                  GestureDetector(
                    onTap: _toggle,
                    child: const Text(
                      'Select Action',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kSessionBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ),

            // ── Expanded: action buttons ─────────────────────────────────────
            if (_expanded) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  _ActionButton(
                    label: 'Give feedback',
                    onTap: () {
                      widget.onGiveFeedback?.call();
                    },
                  ),
                  const SizedBox(width: 10),
                  _ActionButton(
                    label: 'Give materials',
                    onTap: () {
                      widget.onGiveMaterials?.call();
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── _ActionButton ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kSessionBorder),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
