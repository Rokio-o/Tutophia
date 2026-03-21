import 'package:flutter/material.dart';
import 'package:tutophia/models/tutor-model/feedback-tutor-data.dart';
import 'package:tutophia/widgets/tutor-widgets/feedback_constants.dart';

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
          StudentAvatar(imagePath: student.imagePath, size: 44),
          const SizedBox(width: 12),
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

// ── StudentAvatar ─────────────────────────────────────────────────────────────

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
