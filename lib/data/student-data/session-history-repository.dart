import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutophia/models/student-model/booking_data.dart';
import 'package:tutophia/models/student-model/session-history-data.dart';

class StudentSessionHistoryRepository {
  StudentSessionHistoryRepository._();

  static final StudentSessionHistoryRepository instance =
      StudentSessionHistoryRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _bookingsRef =>
      _firestore.collection('bookings');

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('Users');

  Stream<List<SessionHistoryData>> watchCompletedSessions(String studentId) {
    return _bookingsRef
        .where('studentId', isEqualTo: studentId)
        .where('status', isEqualTo: BookingData.statusCompleted)
        .orderBy('sessionDateTime')
        .snapshots()
        .asyncMap((snapshot) async {
          final bookings =
              snapshot.docs.map(BookingData.fromDoc).toList(growable: false)
                ..sort(
                  (left, right) =>
                      right.sessionDateTime.compareTo(left.sessionDateTime),
                );

          final tutorProfiles = await _loadUserProfiles(
            bookings.map((booking) => booking.tutorId).toSet(),
          );

          return bookings
              .map(
                (booking) =>
                    _mapBooking(booking, tutorProfiles[booking.tutorId]),
              )
              .toList(growable: false);
        });
  }

  Future<Map<String, Map<String, dynamic>>> _loadUserProfiles(
    Set<String> userIds,
  ) async {
    final validIds = userIds.where((userId) => userId.trim().isNotEmpty);
    if (validIds.isEmpty) {
      return const <String, Map<String, dynamic>>{};
    }

    final docs = await Future.wait(
      validIds.map((userId) => _usersRef.doc(userId).get()),
    );

    final result = <String, Map<String, dynamic>>{};
    for (final doc in docs) {
      final data = doc.data();
      if (data != null) {
        result[doc.id] = data;
      }
    }
    return result;
  }

  SessionHistoryData _mapBooking(
    BookingData booking,
    Map<String, dynamic>? tutorProfile,
  ) {
    final completedAt = booking.completedAt ?? booking.sessionDateTime;
    final tutorName = booking.tutorName.isNotEmpty
        ? booking.tutorName
        : _displayNameFromProfile(tutorProfile, fallback: 'Tutor');
    final tutorRole = booking.tutorType.isNotEmpty
        ? booking.tutorType
        : _asString(tutorProfile?['tutorType']).isNotEmpty
        ? _asString(tutorProfile?['tutorType'])
        : 'Tutor';
    final tutorProgram = _asString(tutorProfile?['program']).isNotEmpty
        ? _asString(tutorProfile?['program'])
        : 'Not specified';

    return SessionHistoryData(
      tutorName: tutorName,
      tutorRole: tutorRole,
      program: tutorProgram,
      dateCompleted: _formatShortDate(completedAt),
      mode: booking.mode.isNotEmpty ? booking.mode : 'Not specified',
      subject: booking.subject.isNotEmpty
          ? booking.subject
          : booking.topic.isNotEmpty
          ? booking.topic
          : 'Not specified',
      date: _formatLongDate(booking.sessionDateTime),
      sessionDuration: _formatDuration(booking.durationMinutes),
      time: _formatTimeRange(booking.sessionDateTime, booking.endDateTime),
      fee: _formatCurrency(booking.totalPrice),
    );
  }

  String _displayNameFromProfile(
    Map<String, dynamic>? profile, {
    required String fallback,
  }) {
    if (profile == null) {
      return fallback;
    }

    final firstName = _asString(profile['firstName']);
    final lastName = _asString(profile['lastName']);
    final fullName = '$firstName $lastName'.trim();
    if (fullName.isNotEmpty) {
      return fullName;
    }

    final displayName = _asString(profile['displayName']);
    return displayName.isNotEmpty ? displayName : fallback;
  }

  String _formatShortDate(DateTime dateTime) {
    final year = (dateTime.year % 100).toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$month/$day/$year';
  }

  String _formatLongDate(DateTime dateTime) {
    return '${_weekdayNames[dateTime.weekday - 1]}, '
        '${_monthNames[dateTime.month - 1]} ${dateTime.day} ${dateTime.year}';
  }

  String _formatDuration(int durationMinutes) {
    if (durationMinutes <= 0) {
      return 'Not specified';
    }

    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '$hours hour${hours == 1 ? '' : 's'} $minutes min';
    }
    if (hours > 0) {
      return '$hours hour${hours == 1 ? '' : 's'}';
    }
    return '$minutes min';
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    return '${_formatTime(start)} - ${_formatTime(end)}';
  }

  String _formatTime(DateTime dateTime) {
    final period = dateTime.hour >= 12 ? 'pm' : 'am';
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String _formatCurrency(double amount) {
    return '₱ ${amount.toStringAsFixed(2)}';
  }

  String _asString(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }
}

const List<String> _monthNames = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const List<String> _weekdayNames = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
