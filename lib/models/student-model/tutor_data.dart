class TutorData {
  final String uid;
  final String name;
  final String role;
  final String location;
  final String sessionRate;
  final String rating;
  final String reviews;
  final List<String> subjects;
  final String imagePath;

  // Extra tutor details for profile screen
  final String description;
  final String department;
  final String program;
  final String yearLevel;
  final String tutoringExperience;
  final String mode;
  final String sessionDuration;
  final String email;
  final String contactNumber;
  final String messenger;
  final String instagram;
  final String others;
  final List<String> availableSchedule;

  const TutorData({
    this.uid = '',
    required this.name,
    required this.role,
    required this.location,
    required this.sessionRate,
    required this.rating,
    required this.reviews,
    required this.subjects,
    required this.imagePath,
    this.description = '',
    this.department = '',
    this.program = '',
    this.yearLevel = '',
    this.tutoringExperience = '',
    this.mode = '',
    this.sessionDuration = '',
    this.email = '',
    this.contactNumber = '',
    this.messenger = '',
    this.instagram = '',
    this.others = '',
    this.availableSchedule = const [],
  });
}
