import 'package:flutter/material.dart';
import 'package:tutophia/widgets/tutor-widgets/feedback-to-rate-card.dart';

// ── ReviewData ────────────────────────────────────────────────────────────────

class ReviewData {
  final String id;
  final String studentName;
  final String program;
  final String imagePath;
  final int rating; // 1–5
  final String comment;

  const ReviewData({
    required this.id,
    required this.studentName,
    required this.program,
    required this.rating,
    required this.comment,
    this.imagePath = '',
  });
}

// ── MyReviewsCard ─────────────────────────────────────────────────────────────
// Reusable card displaying a completed review: avatar, name, star rating,
// and comment box. Used in the "My Reviews" tab of FeedbackTutorScreen.

class MyReviewsCard extends StatelessWidget {
  final ReviewData review;

  const MyReviewsCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Student info row ──────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StudentAvatar(imagePath: review.imagePath, size: 44),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.studentName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    review.program,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  // Star row inline with "Rate:"
                  Row(
                    children: [
                      const Text(
                        'Rate:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      _StarDisplay(rating: review.rating),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Comment label ─────────────────────────────────────────────────
          const Text(
            'Comment',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),

          // ── Comment box ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kFeedbackBeige,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kFeedbackBorder),
            ),
            child: Text(
              review.comment,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── _StarDisplay ──────────────────────────────────────────────────────────────
// Read-only filled star row for displaying a completed rating.

class _StarDisplay extends StatelessWidget {
  final int rating;

  const _StarDisplay({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          color: const Color(0xFFFFC107),
          size: 18,
        );
      }),
    );
  }
}
