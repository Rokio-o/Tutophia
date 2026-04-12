class ToRateData {
  final String bookingId;
  final String tutorId;
  final String name;
  final String role;
  final String? imagePath;

  const ToRateData({
    required this.bookingId,
    required this.tutorId,
    required this.name,
    required this.role,
    this.imagePath,
  });
}

class ReviewData {
  final String feedbackId;
  final String bookingId;
  final String name;
  final String? course;
  final int rating;
  final String comment;
  final String? imagePath;

  const ReviewData({
    this.feedbackId = '',
    this.bookingId = '',
    required this.name,
    this.course,
    required this.rating,
    required this.comment,
    this.imagePath,
  });
}

class TutorAdviceData {
  final String feedbackId;
  final String bookingId;
  final String tutorId;
  final String tutorName;
  final String? tutorRole;
  final String advice;
  final String? imagePath;

  const TutorAdviceData({
    this.feedbackId = '',
    this.bookingId = '',
    this.tutorId = '',
    required this.tutorName,
    this.tutorRole,
    required this.advice,
    this.imagePath,
  });
}
