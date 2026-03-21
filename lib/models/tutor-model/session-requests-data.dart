// ── SessionRequestStudentData ─────────────────────────────────────────────────

class SessionRequestStudentData {
  final String id;
  final String name;
  final String course;
  final String imagePath;

  const SessionRequestStudentData({
    required this.id,
    required this.name,
    required this.course,
    this.imagePath = '',
  });
}
