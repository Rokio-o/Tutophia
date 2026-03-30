import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutophia/models/notification/app_notification.dart';
import 'package:tutophia/models/student-model/booking_data.dart';
import 'package:tutophia/services/repository/notification_repository/notification_repository.dart';

class BookingRepository {
  BookingRepository._();

  static final BookingRepository instance = BookingRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _bookingsRef =>
      _firestore.collection('bookings');

  Future<String> createBooking(BookingData booking) async {
    final docRef = _bookingsRef.doc();
    final now = FieldValue.serverTimestamp();

    await docRef.set({
      ...booking.copyWith(bookingId: docRef.id).toMap(),
      'bookingId': docRef.id,
      'status': BookingData.statusPending,
      'createdAt': now,
      'updatedAt': now,
      'completedAt': null,
      'cancelledBy': '',
      'meetingLink': booking.meetingLink,
    });

    await NotificationRepository.instance.createNotification(
      recipientId: booking.tutorId,
      senderId: booking.studentId,
      bookingId: docRef.id,
      type: AppNotification.typeNewBookingRequest,
      title: 'New Booking Request',
      body:
          '${booking.studentName} requested a ${booking.subject} session on ${_formatSessionDateTime(booking.sessionDateTime)}.',
      targetScreen: AppNotification.targetTutorSessionRequests,
      sessionDateTime: booking.sessionDateTime,
    );

    return docRef.id;
  }

  Stream<List<BookingData>> watchStudentBookings(String studentId) {
    return _bookingsRef
        .where('studentId', isEqualTo: studentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_mapSnapshotToBookings);
  }

  Stream<List<BookingData>> watchTutorBookings(String tutorId) {
    return _bookingsRef
        .where('tutorId', isEqualTo: tutorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_mapSnapshotToBookings);
  }

  Stream<List<BookingData>> watchTutorPendingBookings(String tutorId) {
    return _bookingsRef
        .where('tutorId', isEqualTo: tutorId)
        .where('status', isEqualTo: BookingData.statusPending)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_mapSnapshotToBookings);
  }

  Stream<List<BookingData>> watchBookingsByStatus({
    required String userId,
    required bool forTutor,
    required String status,
  }) {
    final field = forTutor ? 'tutorId' : 'studentId';

    return _bookingsRef
        .where(field, isEqualTo: userId)
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_mapSnapshotToBookings);
  }

  Future<void> approveBooking(
    String bookingId, {
    String meetingLink = '',
  }) async {
    final bookingSnap = await _bookingsRef.doc(bookingId).get();
    final booking = bookingSnap.exists
        ? BookingData.fromDoc(bookingSnap)
        : null;

    await _bookingsRef.doc(bookingId).update({
      'status': BookingData.statusApproved,
      'meetingLink': meetingLink,
      'updatedAt': FieldValue.serverTimestamp(),
      'cancelledBy': '',
    });

    if (booking != null) {
      await NotificationRepository.instance.createNotification(
        recipientId: booking.studentId,
        senderId: booking.tutorId,
        bookingId: booking.bookingId,
        type: AppNotification.typeBookingApproved,
        title: 'Booking Approved',
        body:
            '${booking.tutorName} approved your booking for ${booking.subject} on ${_formatSessionDateTime(booking.sessionDateTime)}.',
        targetScreen: AppNotification.targetStudentBookings,
        sessionDateTime: booking.sessionDateTime,
      );
    }
  }

  Future<void> cancelBooking(String bookingId, String cancelledBy) async {
    final bookingSnap = await _bookingsRef.doc(bookingId).get();
    final booking = bookingSnap.exists
        ? BookingData.fromDoc(bookingSnap)
        : null;

    await _bookingsRef.doc(bookingId).update({
      'status': BookingData.statusCancelled,
      'cancelledBy': cancelledBy,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (booking == null) {
      return;
    }

    if (cancelledBy == 'student') {
      await NotificationRepository.instance.createNotification(
        recipientId: booking.tutorId,
        senderId: booking.studentId,
        bookingId: booking.bookingId,
        type: AppNotification.typeStudentCancelledBooking,
        title: 'Booking Cancelled by Student',
        body:
            '${booking.studentName} cancelled the session for ${booking.subject} on ${_formatSessionDateTime(booking.sessionDateTime)}.',
        targetScreen: AppNotification.targetTutorSessionRequests,
        sessionDateTime: booking.sessionDateTime,
      );
      return;
    }

    await NotificationRepository.instance.createNotification(
      recipientId: booking.studentId,
      senderId: booking.tutorId,
      bookingId: booking.bookingId,
      type: AppNotification.typeBookingDeclined,
      title: 'Booking Declined',
      body:
          '${booking.tutorName} declined or cancelled your booking for ${booking.subject} on ${_formatSessionDateTime(booking.sessionDateTime)}.',
      targetScreen: AppNotification.targetStudentBookings,
      sessionDateTime: booking.sessionDateTime,
    );
  }

  Future<void> completeBooking(String bookingId) async {
    await _bookingsRef.doc(bookingId).update({
      'status': BookingData.statusCompleted,
      'completedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> hasApprovedOverlap({
    required String tutorId,
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      final snapshot = await _bookingsRef
          .where('tutorId', isEqualTo: tutorId)
          .where('status', isEqualTo: BookingData.statusApproved)
          .where('sessionDateTime', isLessThan: Timestamp.fromDate(end))
          .get();

      for (final doc in snapshot.docs) {
        final booking = BookingData.fromDoc(doc);
        if (booking.endDateTime.isAfter(start) &&
            booking.sessionDateTime.isBefore(end)) {
          return true;
        }
      }

      return false;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        // If rules block this read, do not block booking creation.
        // Prefer server-side conflict validation in production.
        return false;
      }
      rethrow;
    }
  }

  Stream<int> watchStudentPendingCount(String studentId) {
    return watchBookingsByStatus(
      userId: studentId,
      forTutor: false,
      status: BookingData.statusPending,
    ).map((items) => items.length);
  }

  Stream<int> watchStudentUpcomingApprovedCount(String studentId) {
    return watchBookingsByStatus(
      userId: studentId,
      forTutor: false,
      status: BookingData.statusApproved,
    ).map(
      (items) => items
          .where((item) => item.sessionDateTime.isAfter(DateTime.now()))
          .length,
    );
  }

  Stream<int> watchTutorPendingCount(String tutorId) {
    return watchTutorPendingBookings(tutorId).map((items) => items.length);
  }

  Stream<int> watchTutorUpcomingApprovedCount(String tutorId) {
    return watchBookingsByStatus(
      userId: tutorId,
      forTutor: true,
      status: BookingData.statusApproved,
    ).map(
      (items) => items
          .where((item) => item.sessionDateTime.isAfter(DateTime.now()))
          .length,
    );
  }

  List<BookingData> _mapSnapshotToBookings(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return snapshot.docs.map(BookingData.fromDoc).toList();
  }

  String _formatSessionDateTime(DateTime value) {
    final hour = value.hour == 0 ? 12 : (value.hour > 12 ? value.hour - 12 : value.hour);
    final minute = value.minute.toString().padLeft(2, '0');
    final suffix = value.hour >= 12 ? 'pm' : 'am';
    return '${value.month}/${value.day}/${value.year} $hour:$minute $suffix';
  }
}
