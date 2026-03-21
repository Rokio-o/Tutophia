// ── UploadMaterialData ────────────────────────────────────────────────────────
// Represents a material upload transaction sent to a student.

class UploadMaterialData {
  final String studentName;
  final List<String> files;
  final String link;
  final String note;

  const UploadMaterialData({
    required this.studentName,
    this.files = const [],
    this.link = '',
    this.note = '',
  });
}
