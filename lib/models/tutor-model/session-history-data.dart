// ── SessionStudentData ────────────────────────────────────────────────────────

class SessionStudentData {
  final String id;
  final String bookingId;
  final String name;
  final String program;
  final String subject;
  final String imagePath;

  const SessionStudentData({
    required this.id,
    this.bookingId = '',
    required this.name,
    required this.program,
    this.subject = '',
    this.imagePath = '',
  });
}
