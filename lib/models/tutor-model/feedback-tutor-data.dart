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
