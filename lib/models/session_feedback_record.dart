import 'package:cloud_firestore/cloud_firestore.dart';

class SessionFeedbackRecord {
  static const String collectionName = 'sessionFeedback';
  static const String directionStudentToTutor = 'student_to_tutor';
  static const String directionTutorToStudent = 'tutor_to_student';

  final String feedbackId;
  final String bookingId;
  final String direction;
  final String authorId;
  final String authorRole;
  final String recipientId;
  final String recipientRole;
  final String studentId;
  final String tutorId;
  final int? rating;
  final String comment;
  final String advice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SessionFeedbackRecord({
    required this.feedbackId,
    required this.bookingId,
    required this.direction,
    required this.authorId,
    required this.authorRole,
    required this.recipientId,
    required this.recipientRole,
    required this.studentId,
    required this.tutorId,
    this.rating,
    this.comment = '',
    this.advice = '',
    this.createdAt,
    this.updatedAt,
  });

  factory SessionFeedbackRecord.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return SessionFeedbackRecord(
      feedbackId: _asString(data['feedbackId']).isNotEmpty
          ? _asString(data['feedbackId'])
          : doc.id,
      bookingId: _asString(data['bookingId']),
      direction: _asString(data['direction']),
      authorId: _asString(data['authorId']),
      authorRole: _asString(data['authorRole']),
      recipientId: _asString(data['recipientId']),
      recipientRole: _asString(data['recipientRole']),
      studentId: _asString(data['studentId']),
      tutorId: _asString(data['tutorId']),
      rating: _asNullableInt(data['rating']),
      comment: _asString(data['comment']),
      advice: _asString(data['advice']),
      createdAt: _asDateTime(data['createdAt']),
      updatedAt: _asDateTime(data['updatedAt']),
    );
  }

  static String studentReviewDocumentId(String bookingId) {
    return 'studentReview_$bookingId';
  }

  static String tutorAdviceDocumentId(String bookingId) {
    return 'tutorAdvice_$bookingId';
  }

  static String _asString(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }

  static int? _asNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(_asString(value));
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}

class SessionFeedbackException implements Exception {
  final String message;

  const SessionFeedbackException(this.message);

  @override
  String toString() => message;
}
