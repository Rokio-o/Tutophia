import 'package:flutter/material.dart';

// ── Constants ─────────────────────────────────────────────────────────────────

const Color kFeedbackBlue = Color(0xFF3D6FA5);
const Color kFeedbackBeige = Color(0xFFFEF7F0);
const Color kFeedbackBorder = Color(0xFFE0E0E0);

// ── StudentToRateData ─────────────────────────────────────────────────────────

class StudentToRateData {
  final String id;
  final String name;
  final String program;
  final String imagePath;

  const StudentToRateData({
    required this.id,
    required this.name,
    required this.program,
    this.imagePath = '',
  });
}

// ── FeedbackToRateCard ────────────────────────────────────────────────────────
// Reusable card showing a student with a "Rate" link.
// Tapping "Rate" triggers [onRate] — parent decides what to show next.

class FeedbackToRateCard extends StatelessWidget {
  final StudentToRateData student;
  final VoidCallback onRate;

  const FeedbackToRateCard({
    super.key,
    required this.student,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kFeedbackBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          _StudentAvatar(imagePath: student.imagePath, size: 44),

          const SizedBox(width: 12),

          // Name + Program
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  student.program,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),

          // Rate link
          GestureDetector(
            onTap: onRate,
            child: const Text(
              'Rate',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kFeedbackBlue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── _StudentAvatar ────────────────────────────────────────────────────────────
// Shared avatar widget used in both card types.

class StudentAvatar extends StatelessWidget {
  final String imagePath;
  final double size;

  const StudentAvatar({super.key, required this.imagePath, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return _StudentAvatar(imagePath: imagePath, size: size);
  }
}

class _StudentAvatar extends StatelessWidget {
  final String imagePath;
  final double size;

  const _StudentAvatar({required this.imagePath, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
        border: Border.all(color: kFeedbackBorder),
        image: imagePath.isNotEmpty
            ? DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover)
            : null,
      ),
      child: imagePath.isEmpty
          ? Icon(Icons.person, size: size * 0.55, color: Colors.grey)
          : null,
    );
  }
}
