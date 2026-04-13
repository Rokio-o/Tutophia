import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutophia/models/session_feedback_record.dart';
import 'package:tutophia/models/student-model/booking_data.dart';
import 'package:tutophia/models/student-model/feedback_data.dart';

class StudentFeedbackRepository {
  StudentFeedbackRepository._();

  static final StudentFeedbackRepository instance =
      StudentFeedbackRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _bookingsRef =>
      _firestore.collection('bookings');

  CollectionReference<Map<String, dynamic>> get _feedbackRef =>
      _firestore.collection(SessionFeedbackRecord.collectionName);

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('Users');

  Stream<List<ToRateData>> watchToRate(String studentId) {
    return _combineLatest(
      _watchCompletedBookings(studentId),
      _watchStudentReviews(studentId),
      (bookings, feedback) =>
          _StudentFeedbackSource(bookings: bookings, feedback: feedback),
    ).asyncMap((source) async {
      final tutorProfiles = await _loadUserProfiles(
        source.bookings.map((booking) => booking.tutorId).toSet(),
      );
      final ratedBookingIds = source.feedback
          .map((item) => item.bookingId)
          .where((bookingId) => bookingId.isNotEmpty)
          .toSet();

      return source.bookings
          .where((booking) => !ratedBookingIds.contains(booking.bookingId))
          .map((booking) => _mapToRate(booking, tutorProfiles[booking.tutorId]))
          .toList(growable: false);
    });
  }

  Stream<List<ReviewData>> watchMyReviews(String studentId) {
    return _combineLatest(
      _watchCompletedBookings(studentId),
      _watchStudentReviews(studentId),
      (bookings, feedback) =>
          _StudentFeedbackSource(bookings: bookings, feedback: feedback),
    ).asyncMap((source) async {
      final tutorProfiles = await _loadUserProfiles(
        source.bookings.map((booking) => booking.tutorId).toSet(),
      );
      final bookingsById = {
        for (final booking in source.bookings) booking.bookingId: booking,
      };

      return source.feedback
          .map(
            (item) => _mapReview(
              item,
              bookingsById[item.bookingId],
              tutorProfiles[item.tutorId],
            ),
          )
          .toList(growable: false);
    });
  }

  Stream<List<TutorAdviceData>> watchTutorAdvice(String studentId) {
    return _combineLatest(
      _watchCompletedBookings(studentId),
      _watchTutorAdvice(studentId),
      (bookings, feedback) =>
          _StudentFeedbackSource(bookings: bookings, feedback: feedback),
    ).asyncMap((source) async {
      final tutorProfiles = await _loadUserProfiles(
        source.bookings.map((booking) => booking.tutorId).toSet(),
      );
      final bookingsById = {
        for (final booking in source.bookings) booking.bookingId: booking,
      };

      return source.feedback
          .map(
            (item) => _mapAdvice(
              item,
              bookingsById[item.bookingId],
              tutorProfiles[item.tutorId],
            ),
          )
          .toList(growable: false);
    });
  }

  Future<void> submitReview({
    required ToRateData tutor,
    required int rating,
    required String comment,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const SessionFeedbackException('Please login first.');
    }
    if (tutor.bookingId.trim().isEmpty) {
      throw const SessionFeedbackException(
        'This completed session is missing a booking reference.',
      );
    }
    if (rating < 1 || rating > 5) {
      throw const SessionFeedbackException('Please select a rating first.');
    }

    final bookingDoc = await _bookingsRef.doc(tutor.bookingId).get();
    if (!bookingDoc.exists) {
      throw const SessionFeedbackException(
        'The completed session could not be found.',
      );
    }

    final booking = BookingData.fromDoc(bookingDoc);
    if (booking.studentId != user.uid) {
      throw const SessionFeedbackException(
        'You can only review your own completed sessions.',
      );
    }
    if (booking.status != BookingData.statusCompleted) {
      throw const SessionFeedbackException(
        'Only completed sessions can be reviewed.',
      );
    }

    final feedbackId = SessionFeedbackRecord.studentReviewDocumentId(
      booking.bookingId,
    );
    try {
      await _feedbackRef.doc(feedbackId).set({
        'feedbackId': feedbackId,
        'bookingId': booking.bookingId,
        'direction': SessionFeedbackRecord.directionStudentToTutor,
        'authorId': user.uid,
        'authorRole': 'student',
        'recipientId': booking.tutorId,
        'recipientRole': 'tutor',
        'studentId': booking.studentId,
        'tutorId': booking.tutorId,
        'rating': rating,
        'comment': comment.trim(),
        'advice': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      if (error.code == 'permission-denied') {
        throw const SessionFeedbackException(
          'You already submitted a review for this session.',
        );
      }
      rethrow;
    }
  }

  Stream<List<BookingData>> _watchCompletedBookings(String studentId) {
    return _bookingsRef
        .where('studentId', isEqualTo: studentId)
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

  Stream<List<SessionFeedbackRecord>> _watchStudentReviews(String studentId) {
    return _feedbackRef
        .where('authorId', isEqualTo: studentId)
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

  Stream<List<SessionFeedbackRecord>> _watchTutorAdvice(String studentId) {
    return _feedbackRef
        .where('recipientId', isEqualTo: studentId)
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

  ToRateData _mapToRate(
    BookingData booking,
    Map<String, dynamic>? tutorProfile,
  ) {
    return ToRateData(
      bookingId: booking.bookingId,
      tutorId: booking.tutorId,
      name: booking.tutorName.isNotEmpty
          ? booking.tutorName
          : _displayNameFromProfile(tutorProfile, fallback: 'Tutor'),
      role: _buildTutorSubtitle(booking, tutorProfile),
      imagePath: _profileImageSource(tutorProfile),
    );
  }

  ReviewData _mapReview(
    SessionFeedbackRecord feedback,
    BookingData? booking,
    Map<String, dynamic>? tutorProfile,
  ) {
    return ReviewData(
      feedbackId: feedback.feedbackId,
      bookingId: feedback.bookingId,
      name: booking?.tutorName.isNotEmpty == true
          ? booking!.tutorName
          : _displayNameFromProfile(tutorProfile, fallback: 'Tutor'),
      course: _buildReviewCourse(booking, tutorProfile),
      rating: feedback.rating ?? 0,
      comment: feedback.comment.isNotEmpty
          ? feedback.comment
          : 'No comment provided.',
      imagePath: _profileImageSource(tutorProfile),
    );
  }

  TutorAdviceData _mapAdvice(
    SessionFeedbackRecord feedback,
    BookingData? booking,
    Map<String, dynamic>? tutorProfile,
  ) {
    return TutorAdviceData(
      feedbackId: feedback.feedbackId,
      bookingId: feedback.bookingId,
      tutorId: feedback.tutorId,
      tutorName: booking?.tutorName.isNotEmpty == true
          ? booking!.tutorName
          : _displayNameFromProfile(tutorProfile, fallback: 'Tutor'),
      tutorRole: _buildTutorSubtitle(booking, tutorProfile),
      advice: feedback.advice.isNotEmpty
          ? feedback.advice
          : 'No advice provided yet.',
      imagePath: _profileImageSource(tutorProfile),
    );
  }

  String _buildTutorSubtitle(
    BookingData? booking,
    Map<String, dynamic>? tutorProfile,
  ) {
    final parts = <String>[];
    final tutorType =
        booking?.tutorType ?? _asString(tutorProfile?['tutorType']);
    final tutorProgram = _asString(tutorProfile?['program']);
    final subject = booking?.subject ?? '';

    if (tutorType.trim().isNotEmpty) {
      parts.add(tutorType.trim());
    }
    if (tutorProgram.isNotEmpty) {
      parts.add(tutorProgram);
    } else if (subject.trim().isNotEmpty) {
      parts.add(subject.trim());
    }
    if (booking != null) {
      parts.add(_formatShortDate(booking.sessionDateTime));
    }

    return parts.isEmpty ? 'Tutor' : parts.join(' • ');
  }

  String? _buildReviewCourse(
    BookingData? booking,
    Map<String, dynamic>? tutorProfile,
  ) {
    final tutorProgram = _asString(tutorProfile?['program']);
    final subject = booking?.subject ?? '';

    if (tutorProgram.isNotEmpty && subject.trim().isNotEmpty) {
      return '$tutorProgram • ${subject.trim()}';
    }
    if (tutorProgram.isNotEmpty) {
      return tutorProgram;
    }
    if (subject.trim().isNotEmpty) {
      return subject.trim();
    }
    return null;
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

class _StudentFeedbackSource {
  final List<BookingData> bookings;
  final List<SessionFeedbackRecord> feedback;

  const _StudentFeedbackSource({
    required this.bookings,
    required this.feedback,
  });
}
