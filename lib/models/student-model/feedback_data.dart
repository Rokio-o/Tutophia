class ToRateData {
  final String name;
  final String role;
  final String? imagePath;

  const ToRateData({required this.name, required this.role, this.imagePath});
}

class ReviewData {
  final String name;
  final int rating;
  final String comment;
  final String? imagePath;

  const ReviewData({
    required this.name,
    required this.rating,
    required this.comment,
    this.imagePath,
  });
}
