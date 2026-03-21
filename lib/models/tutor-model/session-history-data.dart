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
