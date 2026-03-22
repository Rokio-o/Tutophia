import 'package:flutter/material.dart';
import 'package:tutophia/models/tutor-model/feedback-tutor-data.dart';
import 'package:tutophia/widgets/tutor-widgets/feedback-to-rate-card.dart';
import 'package:tutophia/widgets/tutor-widgets/feedback_constants.dart';

class MyFeedbackCard extends StatelessWidget {
  final TutorFeedbackGivenData feedback;

  const MyFeedbackCard({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xfff7f1eb),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Student info row ──
            Row(
              children: [
                StudentAvatar(imagePath: feedback.imagePath, size: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback.studentName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        feedback.program,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Feedback label ──
            const Text(
              'Feedback Given',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: kFeedbackBlue,
              ),
            ),

            const SizedBox(height: 10),

            // ── Feedback content box ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(minHeight: 96),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kFeedbackBlue),
              ),
              child: Text(
                feedback.feedback,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
