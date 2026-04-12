import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  static const String statusUnread = 'unread';
  static const String statusRead = 'read';

  static const String typeNewBookingRequest = 'new_booking_request';
  static const String typeStudentCancelledBooking = 'student_cancelled_booking';
  static const String typeBookingApproved = 'booking_approved';
  static const String typeBookingDeclined = 'booking_declined';
  static const String typeSessionReminder = 'session_reminder';
  static const String typeMaterialUploaded = 'material_uploaded';
  static const String typeTutorFeedbackReceived = 'tutor_feedback_received';
  static const String typeStudentReviewReceived = 'student_review_received';
  static const String typeBookingCompleted = 'booking_completed';

  static const String targetTutorSessionRequests = 'tutor_session_requests';
  static const String targetStudentBookings = 'student_my_bookings';
  static const String targetStudentSessionMaterials =
      'student_session_materials';
  static const String targetStudentTutorAdvice = 'student_feedback_advice';
  static const String targetTutorStudentReviews = 'tutor_feedback_reviews';
  static const String targetStudentSessionHistory = 'student_session_history';

  final String id;
  final String type;
  final String title;
  final String body;
  final String recipientId;
  final String? senderId;
  final String? bookingId;
  final String status;
  final String targetScreen;
  final DateTime? createdAt;
  final DateTime? sessionDateTime;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.recipientId,
    required this.status,
    required this.targetScreen,
    this.senderId,
    this.bookingId,
    this.createdAt,
    this.sessionDateTime,
  });

  bool get isRead => status == statusRead;

  factory AppNotification.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return AppNotification.fromMap(data, fallbackId: doc.id);
  }

  factory AppNotification.fromMap(
    Map<String, dynamic> map, {
    String fallbackId = '',
  }) {
    final statusText = _asString(map['status']).toLowerCase();

    return AppNotification(
      id: _asString(map['id']).isNotEmpty ? _asString(map['id']) : fallbackId,
      type: _asString(map['type']),
      title: _asString(map['title']),
      body: _asString(map['body']),
      recipientId: _asString(map['recipientId']),
      senderId: _asNullableString(map['senderId']),
      bookingId: _asNullableString(map['bookingId']),
      status: statusText == statusRead ? statusRead : statusUnread,
      targetScreen: _asString(map['targetScreen']),
      createdAt: _asDateTime(map['createdAt']),
      sessionDateTime: _asDateTime(map['sessionDateTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'body': body,
      'recipientId': recipientId,
      'senderId': senderId,
      'bookingId': bookingId,
      'status': status,
      'targetScreen': targetScreen,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'sessionDateTime': sessionDateTime == null
          ? null
          : Timestamp.fromDate(sessionDateTime!),
    };
  }

  AppNotification copyWith({
    String? id,
    String? type,
    String? title,
    String? body,
    String? recipientId,
    String? senderId,
    String? bookingId,
    String? status,
    String? targetScreen,
    DateTime? createdAt,
    DateTime? sessionDateTime,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      recipientId: recipientId ?? this.recipientId,
      senderId: senderId ?? this.senderId,
      bookingId: bookingId ?? this.bookingId,
      status: status ?? this.status,
      targetScreen: targetScreen ?? this.targetScreen,
      createdAt: createdAt ?? this.createdAt,
      sessionDateTime: sessionDateTime ?? this.sessionDateTime,
    );
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static String? _asNullableString(dynamic value) {
    final text = _asString(value).trim();
    if (text.isEmpty) return null;
    return text;
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
