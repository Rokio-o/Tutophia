import 'package:cloud_firestore/cloud_firestore.dart';

class BookingData {
  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusCancelled = 'cancelled';
  static const String statusCompleted = 'completed';

  final String bookingId;
  final String studentId;
  final String studentName;
  final String studentProgram;
  final String tutorId;
  final String tutorName;
  final String tutorType;
  final String tutorImagePath;
  final String subject;
  final String topic;
  final String mode;
  final String location;
  final DateTime sessionDateTime;
  final DateTime endDateTime;
  final int durationMinutes;
  final double hourlyRate;
  final double totalPrice;
  final String studentNotes;
  final String status;
  final String meetingLink;
  final String cancelledBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  const BookingData({
    required this.bookingId,
    required this.studentId,
    required this.studentName,
    this.studentProgram = '',
    required this.tutorId,
    required this.tutorName,
    this.tutorType = '',
    this.tutorImagePath = '',
    required this.subject,
    required this.topic,
    required this.mode,
    this.location = '',
    required this.sessionDateTime,
    required this.endDateTime,
    required this.durationMinutes,
    required this.hourlyRate,
    required this.totalPrice,
    this.studentNotes = '',
    this.status = statusPending,
    this.meetingLink = '',
    this.cancelledBy = '',
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  factory BookingData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return BookingData.fromMap(data, fallbackBookingId: doc.id);
  }

  factory BookingData.fromMap(
    Map<String, dynamic> map, {
    String fallbackBookingId = '',
  }) {
    final session = _asDateTime(map['sessionDateTime']) ?? DateTime.now();
    final end =
        _asDateTime(map['endDateTime']) ?? session.add(const Duration(hours: 1));

    return BookingData(
      bookingId: _asString(map['bookingId']).isNotEmpty
          ? _asString(map['bookingId'])
          : fallbackBookingId,
      studentId: _asString(map['studentId']),
      studentName: _asString(map['studentName']),
      studentProgram: _asString(map['studentProgram']),
      tutorId: _asString(map['tutorId']),
      tutorName: _asString(map['tutorName']),
      tutorType: _asString(map['tutorType']),
      tutorImagePath: _asString(map['tutorImagePath']),
      subject: _asString(map['subject']),
      topic: _asString(map['topic']),
      mode: _asString(map['mode']),
      location: _asString(map['location']),
      sessionDateTime: session,
      endDateTime: end,
      durationMinutes: _asInt(map['durationMinutes']),
      hourlyRate: _asDouble(map['hourlyRate']),
      totalPrice: _asDouble(map['totalPrice']),
      studentNotes: _asString(map['studentNotes']),
      status: _asString(map['status']).isEmpty
          ? statusPending
          : _asString(map['status']).toLowerCase(),
      meetingLink: _asString(map['meetingLink']),
      cancelledBy: _asString(map['cancelledBy']),
      createdAt: _asDateTime(map['createdAt']),
      updatedAt: _asDateTime(map['updatedAt']),
      completedAt: _asDateTime(map['completedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'studentId': studentId,
      'studentName': studentName,
      'studentProgram': studentProgram,
      'tutorId': tutorId,
      'tutorName': tutorName,
      'tutorType': tutorType,
      'tutorImagePath': tutorImagePath,
      'subject': subject,
      'topic': topic,
      'mode': mode,
      'location': location,
      'sessionDateTime': Timestamp.fromDate(sessionDateTime),
      'endDateTime': Timestamp.fromDate(endDateTime),
      'durationMinutes': durationMinutes,
      'hourlyRate': hourlyRate,
      'totalPrice': totalPrice,
      'studentNotes': studentNotes,
      'status': status,
      'meetingLink': meetingLink,
      'cancelledBy': cancelledBy,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
      'completedAt':
          completedAt == null ? null : Timestamp.fromDate(completedAt!),
    };
  }

  BookingData copyWith({
    String? bookingId,
    String? studentId,
    String? studentName,
    String? studentProgram,
    String? tutorId,
    String? tutorName,
    String? tutorType,
    String? tutorImagePath,
    String? subject,
    String? topic,
    String? mode,
    String? location,
    DateTime? sessionDateTime,
    DateTime? endDateTime,
    int? durationMinutes,
    double? hourlyRate,
    double? totalPrice,
    String? studentNotes,
    String? status,
    String? meetingLink,
    String? cancelledBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return BookingData(
      bookingId: bookingId ?? this.bookingId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentProgram: studentProgram ?? this.studentProgram,
      tutorId: tutorId ?? this.tutorId,
      tutorName: tutorName ?? this.tutorName,
      tutorType: tutorType ?? this.tutorType,
      tutorImagePath: tutorImagePath ?? this.tutorImagePath,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      mode: mode ?? this.mode,
      location: location ?? this.location,
      sessionDateTime: sessionDateTime ?? this.sessionDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      totalPrice: totalPrice ?? this.totalPrice,
      studentNotes: studentNotes ?? this.studentNotes,
      status: status ?? this.status,
      meetingLink: meetingLink ?? this.meetingLink,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(_asString(value)) ?? 0;
  }

  static double _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(_asString(value)) ?? 0;
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
