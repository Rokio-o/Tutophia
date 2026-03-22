class ToRateData {
  final String name;
  final String role;
  final String? imagePath;

  const ToRateData({required this.name, required this.role, this.imagePath});
}

class ReviewData {
  final String name;
  final String? course;
  final int rating;
  final String comment;
  final String? imagePath;

  const ReviewData({
    required this.name,
    this.course,
    required this.rating,
    required this.comment,
    this.imagePath,
  });
}

class TutorAdviceData {
  final String tutorName;
  final String? tutorRole;
  final String advice;
  final String? imagePath;

  const TutorAdviceData({
    required this.tutorName,
    this.tutorRole,
    required this.advice,
    this.imagePath,
  });
}
