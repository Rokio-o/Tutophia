import 'package:cloud_firestore/cloud_firestore.dart';

class SessionMaterialData {
  static const String collectionName = 'sessionMaterials';

  static const String statusActive = 'active';
  static const String statusArchived = 'archived';

  static const String visibilityStudentOnly = 'student_only';
  static const String visibilityBookingParticipants = 'booking_participants';
  static const String visibilityTutorOnly = 'tutor_only';

  final String materialId;
  final String tutorId;
  final String tutorName;
  final String studentId;
  final String studentName;
  final String bookingId;
  final String subject;
  final String title;
  final String description;
  final String fileName;
  final String storagePath;
  final String downloadUrl;
  final String contentType;
  final String fileType;
  final int fileSizeBytes;
  final String visibility;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SessionMaterialData({
    required this.materialId,
    required this.tutorId,
    required this.tutorName,
    this.studentId = '',
    this.studentName = '',
    this.bookingId = '',
    this.subject = '',
    required this.title,
    this.description = '',
    required this.fileName,
    this.storagePath = '',
    this.downloadUrl = '',
    this.contentType = '',
    this.fileType = '',
    this.fileSizeBytes = 0,
    this.visibility = visibilityStudentOnly,
    this.status = statusActive,
    required this.createdAt,
    required this.updatedAt,
  });

  String get id => materialId;

  String get uploaderName => tutorName;

  String get uploaderId => tutorId;

  String get fileUrl => downloadUrl;

  DateTime get uploadedAt => createdAt;

  bool get hasStorageFile => storagePath.trim().isNotEmpty;

  bool get hasDirectUrl => downloadUrl.trim().isNotEmpty;

  factory SessionMaterialData.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return SessionMaterialData.fromMap(
      doc.data() ?? <String, dynamic>{},
      fallbackMaterialId: doc.id,
    );
  }

  factory SessionMaterialData.fromMap(
    Map<String, dynamic> map, {
    String fallbackMaterialId = '',
  }) {
    final createdAt = _asDateTime(map['createdAt']) ?? DateTime.now();
    final updatedAt = _asDateTime(map['updatedAt']) ?? createdAt;

    return SessionMaterialData(
      materialId: _asString(map['materialId']).isNotEmpty
          ? _asString(map['materialId'])
          : fallbackMaterialId,
      tutorId: _asString(map['tutorId']),
      tutorName: _asString(map['tutorName']),
      studentId: _asString(map['studentId']),
      studentName: _asString(map['studentName']),
      bookingId: _asString(map['bookingId']),
      subject: _asString(map['subject']),
      title: _asString(map['title']),
      description: _asString(map['description']),
      fileName: _asString(map['fileName']),
      storagePath: _asString(map['storagePath']),
      downloadUrl: _asString(map['downloadUrl']),
      contentType: _asString(map['contentType']),
      fileType: _asString(map['fileType']),
      fileSizeBytes: _asInt(map['fileSizeBytes']),
      visibility: _asString(map['visibility']).isEmpty
          ? visibilityStudentOnly
          : _asString(map['visibility']),
      status: _asString(map['status']).isEmpty
          ? statusActive
          : _asString(map['status']),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'materialId': materialId,
      'tutorId': tutorId,
      'tutorName': tutorName,
      'studentId': studentId,
      'studentName': studentName,
      'bookingId': bookingId,
      'subject': subject,
      'title': title,
      'description': description,
      'fileName': fileName,
      'storagePath': storagePath,
      'downloadUrl': downloadUrl,
      'contentType': contentType,
      'fileType': fileType,
      'fileSizeBytes': fileSizeBytes,
      'visibility': visibility,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(_asString(value)) ?? 0;
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
