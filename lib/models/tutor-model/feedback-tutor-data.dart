// ── StudentToRateData ─────────────────────────────────────────────────────────
// Students pending feedback from tutor

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

// ── TutorFeedbackGivenData ────────────────────────────────────────────────────
// Text feedback that the tutor gave to a student (no stars)

class TutorFeedbackGivenData {
  final String id;
  final String studentName;
  final String program;
  final String imagePath;
  final String feedback;

  const TutorFeedbackGivenData({
    required this.id,
    required this.studentName,
    required this.program,
    required this.feedback,
    this.imagePath = '',
  });
}

// ── StudentRatingData ─────────────────────────────────────────────────────────
// Star rating + comment that a student gave to the tutor

class StudentRatingData {
  final String id;
  final String studentName;
  final String program;
  final String imagePath;
  final int rating; // 1–5
  final String comment;

  const StudentRatingData({
    required this.id,
    required this.studentName,
    required this.program,
    required this.rating,
    required this.comment,
    this.imagePath = '',
  });
}
