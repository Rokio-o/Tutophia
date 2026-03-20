import 'package:flutter/material.dart';
import 'package:tutophia/widgets/tutor-widgets/feedback-to-rate-card.dart';
import 'package:tutophia/widgets/tutor-widgets/header-tutor-wdgt.dart';

// ── RateStudentScreen ─────────────────────────────────────────────────────────

class RateStudentScreen extends StatefulWidget {
  final StudentToRateData student;
  final void Function(int rating, String comment) onSave;

  const RateStudentScreen({
    super.key,
    required this.student,
    required this.onSave,
  });

  @override
  State<RateStudentScreen> createState() => _RateStudentScreenState();
}

class _RateStudentScreenState extends State<RateStudentScreen> {
  int _hoveredStar = 0;
  int _selectedStar = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_selectedStar == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating.')),
      );
      return;
    }
    widget.onSave(_selectedStar, _commentController.text.trim());
    Navigator.pop(context);
  }

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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            const HeaderTutorWdgt.feedback(),

            const SizedBox(height: 32),

            // ── Student Avatar + Name ─────────────────────────────────────
            Center(
              child: Column(
                children: [
                  StudentAvatar(imagePath: widget.student.imagePath, size: 72),
                  const SizedBox(height: 12),
                  Text(
                    widget.student.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.student.program,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Rate the student ──────────────────────────────────────────
            const Text(
              'Rate the student performance',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // Interactive star rating
            Row(
              children: List.generate(5, (i) {
                final starIndex = i + 1;
                final filled =
                    starIndex <=
                    (_hoveredStar > 0 ? _hoveredStar : _selectedStar);
                return GestureDetector(
                  onTap: () => setState(() => _selectedStar = starIndex),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _hoveredStar = starIndex),
                    onExit: (_) => setState(() => _hoveredStar = 0),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        filled
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: filled
                            ? const Color(0xFFFFC107)
                            : Colors.grey[400],
                        size: 32,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // ── Add a comment ─────────────────────────────────────────────
            const Text(
              'Add a comment',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '',
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: kFeedbackBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: kFeedbackBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: kFeedbackBlue),
                ),
              ),
            ),

            const Spacer(),

            // ── Go back / Save buttons ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: kFeedbackBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Go back',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kFeedbackBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
