import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutophia/models/student-model/booking_data.dart';
import 'package:tutophia/models/tutor-model/session-history-data.dart';

class TutorSessionHistoryRepository {
  TutorSessionHistoryRepository._();

  static final TutorSessionHistoryRepository instance =
      TutorSessionHistoryRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _bookingsRef =>
      _firestore.collection('bookings');

  Stream<List<SessionStudentData>> watchCompletedStudents(String tutorId) {
    return _bookingsRef
        .where('tutorId', isEqualTo: tutorId)
        .where('status', isEqualTo: BookingData.statusCompleted)
        .orderBy('sessionDateTime')
        .snapshots()
        .map((snapshot) {
          final bookings =
              snapshot.docs.map(BookingData.fromDoc).toList(growable: false)
                ..sort(
                  (left, right) =>
                      right.sessionDateTime.compareTo(left.sessionDateTime),
                );

          final latestByStudent = <String, BookingData>{};
          for (final booking in bookings) {
            if (booking.studentId.trim().isEmpty) {
              continue;
            }
            latestByStudent.putIfAbsent(booking.studentId, () => booking);
          }

          return latestByStudent.values
              .map(_mapBooking)
              .toList(growable: false);
        });
  }

  SessionStudentData _mapBooking(BookingData booking) {
    return SessionStudentData(
      id: booking.studentId,
      bookingId: booking.bookingId,
      name: booking.studentName.isNotEmpty ? booking.studentName : 'Student',
      program: _buildStudentSubtitle(booking),
      subject: booking.subject,
    );
  }

  String _buildStudentSubtitle(BookingData booking) {
    final parts = <String>[];
    if (booking.studentProgram.isNotEmpty) {
      parts.add(booking.studentProgram);
    }
    if (booking.subject.isNotEmpty) {
      parts.add(booking.subject);
    }
    if (parts.isEmpty) {
      parts.add(_formatShortDate(booking.sessionDateTime));
    }
    return parts.join(' • ');
  }

  String _formatShortDate(DateTime dateTime) {
    final year = (dateTime.year % 100).toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$month/$day/$year';
  }
}
