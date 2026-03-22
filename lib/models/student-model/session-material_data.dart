class SessionMaterialData {
  final String id; // backend document ID
  final String title;
  final String uploaderName; // tutor's display name
  final String uploaderId; // tutor's backend user ID
  final String fileUrl; // download/storage URL from backend
  final String fileType; // e.g. "pdf", "docx", "pptx", "png"
  final DateTime uploadedAt;

  const SessionMaterialData({
    required this.id,
    required this.title,
    required this.uploaderName,
    required this.uploaderId,
    required this.fileUrl,
    required this.fileType,
    required this.uploadedAt,
  });

  // ── For when backend returns JSON ──
  factory SessionMaterialData.fromJson(Map<String, dynamic> json) {
    return SessionMaterialData(
      id: json['id'] as String,
      title: json['title'] as String,
      uploaderName: json['uploaderName'] as String,
      uploaderId: json['uploaderId'] as String,
      fileUrl: json['fileUrl'] as String,
      fileType: json['fileType'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'uploaderName': uploaderName,
    'uploaderId': uploaderId,
    'fileUrl': fileUrl,
    'fileType': fileType,
    'uploadedAt': uploadedAt.toIso8601String(),
  };
}
