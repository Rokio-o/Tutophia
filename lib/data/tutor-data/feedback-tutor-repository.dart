import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutophia/models/session_feedback_record.dart';
import 'package:tutophia/models/student-model/booking_data.dart';
import 'package:tutophia/models/tutor-model/feedback-tutor-data.dart';

class TutorFeedbackRepository {
  TutorFeedbackRepository._();

  static final TutorFeedbackRepository instance = TutorFeedbackRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _bookingsRef =>
      _firestore.collection('bookings');

  CollectionReference<Map<String, dynamic>> get _feedbackRef =>
      _firestore.collection(SessionFeedbackRecord.collectionName);

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('Users');

  Stream<List<StudentToRateData>> watchStudentsPendingFeedback(String tutorId) {
    return _combineLatest(
      _watchCompletedBookings(tutorId),
      _watchTutorAdviceAuthored(tutorId),
      (bookings, feedback) =>
          _TutorFeedbackSource(bookings: bookings, feedback: feedback),
    ).asyncMap((source) async {
      final studentProfiles = await _loadUserProfiles(
        source.bookings.map((booking) => booking.studentId).toSet(),
      );
      final completedFeedbackBookingIds = source.feedback
          .map((item) => item.bookingId)
          .where((bookingId) => bookingId.isNotEmpty)
          .toSet();

      return source.bookings
          .where(
            (booking) =>
                !completedFeedbackBookingIds.contains(booking.bookingId),
          )
          .map(
            (booking) =>
                _mapStudentToRate(booking, studentProfiles[booking.studentId]),
          )
          .toList(growable: false);
    });
  }

  Stream<List<TutorFeedbackGivenData>> watchFeedbackGiven(String tutorId) {
    return _combineLatest(
      _watchCompletedBookings(tutorId),
      _watchTutorAdviceAuthored(tutorId),
      (bookings, feedback) =>
          _TutorFeedbackSource(bookings: bookings, feedback: feedback),
    ).asyncMap((source) async {
      final studentProfiles = await _loadUserProfiles(
        source.bookings.map((booking) => booking.studentId).toSet(),
      );
      final bookingsById = {
        for (final booking in source.bookings) booking.bookingId: booking,
      };

      return source.feedback
          .map(
            (item) => _mapFeedbackGiven(
              item,
              bookingsById[item.bookingId],
              studentProfiles[item.studentId],
            ),
          )
          .toList(growable: false);
    });
  }

  Stream<List<StudentRatingData>> watchStudentRatings(String tutorId) {
    return _combineLatest(
      _watchCompletedBookings(tutorId),
      _watchStudentRatingsReceived(tutorId),
      (bookings, feedback) =>
          _TutorFeedbackSource(bookings: bookings, feedback: feedback),
    ).asyncMap((source) async {
      final studentProfiles = await _loadUserProfiles(
        source.bookings.map((booking) => booking.studentId).toSet(),
      );
      final bookingsById = {
        for (final booking in source.bookings) booking.bookingId: booking,
      };

      return source.feedback
          .map(
            (item) => _mapStudentRating(
              item,
              bookingsById[item.bookingId],
              studentProfiles[item.studentId],
            ),
          )
          .toList(growable: false);
    });
  }

  Future<void> submitTutorFeedback({
    required StudentToRateData student,
    required String advice,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const SessionFeedbackException('Please login first.');
    }

    final bookingId = student.bookingId.trim().isNotEmpty
        ? student.bookingId.trim()
        : student.id.trim();
    if (bookingId.isEmpty) {
      throw const SessionFeedbackException(
        'This completed session is missing a booking reference.',
      );
    }
    if (advice.trim().isEmpty) {
      throw const SessionFeedbackException('Please write your feedback.');
    }

    final bookingDoc = await _bookingsRef.doc(bookingId).get();
    if (!bookingDoc.exists) {
      throw const SessionFeedbackException(
        'The completed session could not be found.',
      );
    }

    final booking = BookingData.fromDoc(bookingDoc);
    if (booking.tutorId != user.uid) {
      throw const SessionFeedbackException(
        'You can only give feedback for your own completed sessions.',
      );
    }
    if (booking.status != BookingData.statusCompleted) {
      throw const SessionFeedbackException(
        'Only completed sessions can receive tutor advice.',
      );
    }

    final feedbackId = SessionFeedbackRecord.tutorAdviceDocumentId(
      booking.bookingId,
    );
    try {
      await _feedbackRef.doc(feedbackId).set({
        'feedbackId': feedbackId,
        'bookingId': booking.bookingId,
        'direction': SessionFeedbackRecord.directionTutorToStudent,
        'authorId': user.uid,
        'authorRole': 'tutor',
        'recipientId': booking.studentId,
        'recipientRole': 'student',
        'studentId': booking.studentId,
        'tutorId': booking.tutorId,
        'comment': '',
        'advice': advice.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      if (error.code == 'permission-denied') {
        throw const SessionFeedbackException(
          'Feedback for this session has already been submitted.',
        );
      }
      rethrow;
    }
  }

  Stream<List<BookingData>> _watchCompletedBookings(String tutorId) {
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
          return bookings;
        });
  }

  Stream<List<SessionFeedbackRecord>> _watchTutorAdviceAuthored(
    String tutorId,
  ) {
    return _feedbackRef
        .where('authorId', isEqualTo: tutorId)
        .where(
          'direction',
          isEqualTo: SessionFeedbackRecord.directionTutorToStudent,
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(SessionFeedbackRecord.fromDoc)
              .toList(growable: false),
        );
  }

  Stream<List<SessionFeedbackRecord>> _watchStudentRatingsReceived(
    String tutorId,
  ) {
    return _feedbackRef
        .where('recipientId', isEqualTo: tutorId)
        .where(
          'direction',
          isEqualTo: SessionFeedbackRecord.directionStudentToTutor,
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(SessionFeedbackRecord.fromDoc)
              .toList(growable: false),
        );
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

    final profiles = <String, Map<String, dynamic>>{};
    for (final doc in docs) {
      final data = doc.data();
      if (data != null) {
        profiles[doc.id] = data;
      }
    }

    return profiles;
  }

  StudentToRateData _mapStudentToRate(
    BookingData booking,
    Map<String, dynamic>? studentProfile,
  ) {
    return StudentToRateData(
      id: booking.bookingId,
      studentId: booking.studentId,
      bookingId: booking.bookingId,
      name: booking.studentName.isNotEmpty
          ? booking.studentName
          : _displayNameFromProfile(studentProfile, fallback: 'Student'),
      program: _buildStudentSubtitle(booking),
      imagePath: _profileImageSource(studentProfile) ?? '',
    );
  }

  TutorFeedbackGivenData _mapFeedbackGiven(
    SessionFeedbackRecord feedback,
    BookingData? booking,
    Map<String, dynamic>? studentProfile,
  ) {
    return TutorFeedbackGivenData(
      id: feedback.feedbackId,
      feedbackId: feedback.feedbackId,
      bookingId: feedback.bookingId,
      studentId: feedback.studentId,
      studentName: booking?.studentName.isNotEmpty == true
          ? booking!.studentName
          : _displayNameFromProfile(studentProfile, fallback: 'Student'),
      program: _buildStudentSubtitle(booking),
      feedback: feedback.advice.isNotEmpty
          ? feedback.advice
          : 'No feedback provided.',
      imagePath: _profileImageSource(studentProfile) ?? '',
    );
  }

  StudentRatingData _mapStudentRating(
    SessionFeedbackRecord feedback,
    BookingData? booking,
    Map<String, dynamic>? studentProfile,
  ) {
    return StudentRatingData(
      id: feedback.feedbackId,
      feedbackId: feedback.feedbackId,
      bookingId: feedback.bookingId,
      studentId: feedback.studentId,
      studentName: booking?.studentName.isNotEmpty == true
          ? booking!.studentName
          : _displayNameFromProfile(studentProfile, fallback: 'Student'),
      program: _buildStudentSubtitle(booking),
      rating: feedback.rating ?? 0,
      comment: feedback.comment.isNotEmpty
          ? feedback.comment
          : 'No comment provided.',
      imagePath: _profileImageSource(studentProfile) ?? '',
    );
  }

  String _buildStudentSubtitle(BookingData? booking) {
    if (booking == null) {
      return 'Completed session';
    }

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

  String? _profileImageSource(Map<String, dynamic>? profile) {
    if (profile == null) {
      return null;
    }

    final profileImageUrl = _asString(profile['profileImageUrl']);
    if (profileImageUrl.isNotEmpty) {
      return profileImageUrl;
    }

    final profileImagePath = _asString(profile['profileImagePath']);
    if (profileImagePath.isNotEmpty) {
      return profileImagePath;
    }

    return null;
  }

  String _formatShortDate(DateTime dateTime) {
    final year = (dateTime.year % 100).toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$month/$day/$year';
  }

  String _asString(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }

  Stream<T> _combineLatest<T, A, B>(
    Stream<A> first,
    Stream<B> second,
    T Function(A firstValue, B secondValue) combine,
  ) {
    late StreamController<T> controller;
    StreamSubscription<A>? firstSubscription;
    StreamSubscription<B>? secondSubscription;

    A? firstValue;
    B? secondValue;
    var hasFirst = false;
    var hasSecond = false;

    void emitIfReady() {
      if (!hasFirst || !hasSecond) {
        return;
      }
      controller.add(combine(firstValue as A, secondValue as B));
    }

    controller = StreamController<T>(
      onListen: () {
        firstSubscription = first.listen((value) {
          firstValue = value;
          hasFirst = true;
          emitIfReady();
        }, onError: controller.addError);
        secondSubscription = second.listen((value) {
          secondValue = value;
          hasSecond = true;
          emitIfReady();
        }, onError: controller.addError);
      },
      onCancel: () async {
        await firstSubscription?.cancel();
        await secondSubscription?.cancel();
      },
    );

    return controller.stream;
  }
}

class _TutorFeedbackSource {
  final List<BookingData> bookings;
  final List<SessionFeedbackRecord> feedback;

  const _TutorFeedbackSource({required this.bookings, required this.feedback});
}
