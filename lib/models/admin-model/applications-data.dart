// ── Enums ─────────────────────────────────────────────────────────────────────

enum ApplicationStatus { pending, approved, rejected }

extension ApplicationStatusX on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.pending:
        return 'pending';
      case ApplicationStatus.approved:
        return 'approved';
      case ApplicationStatus.rejected:
        return 'rejected';
    }
  }
}

// ── Tutor Application Model ───────────────────────────────────────────────────

class TutorApplicationModel {
  final String id;
  final String name;
  final String specialization;
  final String image;
  final bool hasImage;
  ApplicationStatus status;
  String? rejectReason;

  // Profile details
  final String bio;
  final String academicInstitution;
  final String degree;
  final String yearsOfExperience;
  final List<String> subjectsTaught;
  final String availability;
  final String portfolioLink;

  // Contact
  final String email;
  final String contactNumber;
  final String messengerHandle;
  final String instagramHandle;

  // Uploaded ID
  final String uploadedIdImage;

  TutorApplicationModel({
    required this.id,
    required this.name,
    required this.specialization,
    this.image = '',
    this.hasImage = false,
    this.status = ApplicationStatus.pending,
    this.rejectReason,
    this.bio = '',
    this.academicInstitution = '',
    this.degree = '',
    this.yearsOfExperience = '',
    this.subjectsTaught = const [],
    this.availability = '',
    this.portfolioLink = '',
    this.email = '',
    this.contactNumber = '',
    this.messengerHandle = '',
    this.instagramHandle = '',
    this.uploadedIdImage = '',
  });

  TutorApplicationModel copyWith({
    ApplicationStatus? status,
    String? rejectReason,
  }) {
    return TutorApplicationModel(
      id: id,
      name: name,
      specialization: specialization,
      image: image,
      hasImage: hasImage,
      status: status ?? this.status,
      rejectReason: rejectReason ?? this.rejectReason,
      bio: bio,
      academicInstitution: academicInstitution,
      degree: degree,
      yearsOfExperience: yearsOfExperience,
      subjectsTaught: subjectsTaught,
      availability: availability,
      portfolioLink: portfolioLink,
      email: email,
      contactNumber: contactNumber,
      messengerHandle: messengerHandle,
      instagramHandle: instagramHandle,
      uploadedIdImage: uploadedIdImage,
    );
  }
}

// ── Student Application Model ─────────────────────────────────────────────────

class StudentApplicationModel {
  final String id;
  final String name;
  final String course;
  final String image;
  final bool hasImage;
  ApplicationStatus status;
  String? rejectReason;

  // Profile details
  final String bio;
  final String yearLevel;
  final String academicInstitution;
  final List<String> subjectsNeeded;
  final String availability;

  // Contact
  final String email;
  final String contactNumber;
  final String messengerHandle;
  final String instagramHandle;

  // Uploaded ID
  final String uploadedIdImage;

  StudentApplicationModel({
    required this.id,
    required this.name,
    required this.course,
    this.image = '',
    this.hasImage = false,
    this.status = ApplicationStatus.pending,
    this.rejectReason,
    this.bio = '',
    this.yearLevel = '',
    this.academicInstitution = '',
    this.subjectsNeeded = const [],
    this.availability = '',
    this.email = '',
    this.contactNumber = '',
    this.messengerHandle = '',
    this.instagramHandle = '',
    this.uploadedIdImage = '',
  });

  StudentApplicationModel copyWith({
    ApplicationStatus? status,
    String? rejectReason,
  }) {
    return StudentApplicationModel(
      id: id,
      name: name,
      course: course,
      image: image,
      hasImage: hasImage,
      status: status ?? this.status,
      rejectReason: rejectReason ?? this.rejectReason,
      bio: bio,
      yearLevel: yearLevel,
      academicInstitution: academicInstitution,
      subjectsNeeded: subjectsNeeded,
      availability: availability,
      email: email,
      contactNumber: contactNumber,
      messengerHandle: messengerHandle,
      instagramHandle: instagramHandle,
      uploadedIdImage: uploadedIdImage,
    );
  }
}
