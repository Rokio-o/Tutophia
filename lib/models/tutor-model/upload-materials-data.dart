import 'dart:typed_data';

class MaterialRecipient {
  final String bookingId;
  final String studentId;
  final String studentName;
  final String subject;
  final String studentProgram;
  final DateTime? sessionDateTime;

  const MaterialRecipient({
    required this.bookingId,
    required this.studentId,
    required this.studentName,
    this.subject = '',
    this.studentProgram = '',
    this.sessionDateTime,
  });

  String get subtitle {
    if (subject.isNotEmpty && studentProgram.isNotEmpty) {
      return '$subject • $studentProgram';
    }
    if (subject.isNotEmpty) {
      return subject;
    }
    return studentProgram;
  }
}

class UploadMaterialData {
  final String title;
  final String description;
  final MaterialRecipient recipient;
  final String fileName;
  final Uint8List? fileBytes;
  final String contentType;
  final int fileSizeBytes;
  final String externalUrl;

  const UploadMaterialData({
    required this.title,
    required this.description,
    required this.recipient,
    required this.fileName,
    this.fileBytes,
    this.contentType = '',
    this.fileSizeBytes = 0,
    this.externalUrl = '',
  });

  bool get isLink => externalUrl.trim().isNotEmpty;
}
