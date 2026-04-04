import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tutophia/models/student-model/booking_data.dart';

class BookingRepository {
  BookingRepository._();

  static final BookingRepository instance = BookingRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    app: Firebase.app(),
    region: 'us-central1',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _bookingsRef =>
      _firestore.collection('bookings');

  Future<void> _ensureAuthenticatedForCallable() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const BookingMutationException(
        'auth',
        'Please login first.',
        code: 'unauthenticated',
      );
    }

    await user.getIdToken(true);
  }

  Future<String> createBooking(BookingData booking) async {
    try {
      await _ensureAuthenticatedForCallable();
      final result = await _functions.httpsCallable('createBooking').call({
        'studentId': booking.studentId,
        'studentName': booking.studentName,
        'studentProgram': booking.studentProgram,
        'tutorId': booking.tutorId,
        'tutorName': booking.tutorName,
        'tutorType': booking.tutorType,
        'tutorImagePath': booking.tutorImagePath,
        'subject': booking.subject,
        'topic': booking.topic,
        'mode': booking.mode,
        'location': booking.location,
        'sessionDateTimeMs': booking.sessionDateTime.millisecondsSinceEpoch,
        'endDateTimeMs': booking.endDateTime.millisecondsSinceEpoch,
        'durationMinutes': booking.durationMinutes,
        'hourlyRate': booking.hourlyRate,
        'totalPrice': booking.totalPrice,
        'studentNotes': booking.studentNotes,
        'meetingLink': booking.meetingLink,
      });

      final data = _asResultMap(result.data);
      final bookingId = _readString(data, 'bookingId');

      if (bookingId.isEmpty) {
        throw const BookingMutationException(
          'createBooking',
          'The booking was created but no booking ID was returned.',
        );
      }

      return bookingId;
    } on FirebaseFunctionsException catch (error) {
      throw _mapFunctionsException('createBooking', error);
    }
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
    try {
      await _ensureAuthenticatedForCallable();
      await _functions.httpsCallable('approveBooking').call({
        'bookingId': bookingId,
        'meetingLink': meetingLink,
      });
    } on FirebaseFunctionsException catch (error) {
      throw _mapFunctionsException('approveBooking', error);
    }
  }

  Future<void> cancelBooking(String bookingId, String cancelledBy) async {
    assert(cancelledBy == 'student' || cancelledBy == 'tutor');

    try {
      await _ensureAuthenticatedForCallable();
      await _functions.httpsCallable('cancelBooking').call({
        'bookingId': bookingId,
      });
    } on FirebaseFunctionsException catch (error) {
      throw _mapFunctionsException('cancelBooking', error);
    }
  }

  Future<void> completeBooking(String bookingId) async {
    try {
      await _ensureAuthenticatedForCallable();
      await _functions.httpsCallable('completeBooking').call({
        'bookingId': bookingId,
      });
    } on FirebaseFunctionsException catch (error) {
      throw _mapFunctionsException('completeBooking', error);
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

  Map<String, dynamic> _asResultMap(dynamic data) {
    if (data is Map<Object?, Object?>) {
      return data.map(
        (key, value) => MapEntry(key.toString(), value),
      );
    }

    return <String, dynamic>{};
  }

  String _readString(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String) {
      return value.trim();
    }
    return '';
  }

  BookingMutationException _mapFunctionsException(
    String operation,
    FirebaseFunctionsException error,
  ) {
    final details = _asResultMap(error.details);

    if (details['reason'] == 'booking_overlap') {
      return BookingMutationException(
        operation,
        'The tutor already has an approved session during this time. Please choose another slot.',
        code: error.code,
        details: details,
      );
    }

    String message;
    switch (error.code) {
      case 'unauthenticated':
        message = 'Please login first.';
        break;
      case 'permission-denied':
        message = 'You are not allowed to perform this booking action.';
        break;
      case 'not-found':
        message = 'The booking could not be found.';
        break;
      case 'failed-precondition':
        message = error.message ?? 'This booking is no longer in a valid state for that action.';
        break;
      case 'invalid-argument':
        message = error.message ?? 'The booking request is missing required information.';
        break;
      default:
        message = error.message ?? 'Booking request failed. Please try again.';
    }

    return BookingMutationException(
      operation,
      message,
      code: error.code,
      details: details,
    );
  }
}

class BookingMutationException implements Exception {
  final String operation;
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const BookingMutationException(
    this.operation,
    this.message, {
    this.code,
    this.details,
  });

  @override
  String toString() => message;
}
