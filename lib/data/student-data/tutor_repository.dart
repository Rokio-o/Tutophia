import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutophia/models/session_feedback_record.dart';
import 'package:tutophia/models/student-model/feedback_data.dart';
import 'package:tutophia/models/student-model/tutor_data.dart';

// Firestore instance
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Temporary tutor data - Used as fallback/mock data
final List<TutorData> availableTutors = [];

/// Fetches all tutors from Firestore (Users collection where role = 'tutor')
Future<List<TutorData>> fetchAllTutors() async {
  try {
    final results = await Future.wait<dynamic>([
      _firestore
          .collection('Users')
          .where('accountType', isEqualTo: 'tutor')
          .get(),
      _firestore
          .collection(SessionFeedbackRecord.collectionName)
          .where(
            'direction',
            isEqualTo: SessionFeedbackRecord.directionStudentToTutor,
          )
          .get(),
    ]);

    final QuerySnapshot querySnapshot = results[0] as QuerySnapshot;
    final QuerySnapshot<Map<String, dynamic>> reviewSnapshot =
        results[1] as QuerySnapshot<Map<String, dynamic>>;
    final ratingSummaries = _buildTutorRatingSummaries(reviewSnapshot.docs);

    final List<TutorData> tutors = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      // Combine firstName and lastName into name
      final firstName = data['firstName'] as String? ?? '';
      final lastName = data['lastName'] as String? ?? '';
      final fullName = '${firstName.trim()} ${lastName.trim()}'.trim();

      final ratingSummary =
          ratingSummaries[doc.id] ?? const _TutorRatingSummary();
      final rating = ratingSummary.averageRating.toStringAsFixed(1);
      final reviewCount = ratingSummary.reviewCount;
      final reviews =
          '($reviewCount ${reviewCount == 1 ? 'review' : 'reviews'})';

      // Parse session rate - ensure it includes ₱ symbol
      var sessionRate = data['sessionRate'] as String? ?? '₱0 /hr';
      if (!sessionRate.contains('₱')) {
        sessionRate = '₱$sessionRate /hr';
      }

      // Accept both legacy key `specialization` and current key `specializations`.
      final subjects = _toStringList(
        data['specializations'] ?? data['specialization'],
      );

      // Accept either a Firestore array or a single string value.
      final availableSchedule = _toStringList(data['availableSchedule']);

      return TutorData(
        uid: doc.id,
        name: fullName,
        role: data['tutorType'] as String? ?? 'Student Tutor',
        location: data['address'] as String? ?? 'Not specified',
        sessionRate: sessionRate,
        rating: rating,
        reviews: reviews,
        subjects: subjects,
        imagePath:
            data['profileImageUrl'] as String? ??
            data['profileImagePath'] as String? ??
            '',
        description:
            data['teachingDescription'] as String? ??
            data['description'] as String? ??
            '',
        department: data['department'] as String? ?? '',
        program: data['program'] as String? ?? '',
        yearLevel: data['yearSpent'] as String? ?? '',
        tutoringExperience: data['tutoringExperience'] as String? ?? '',
        portfolioLink:
            data['portfolioLink'] as String? ??
            data['scheduleLink'] as String? ??
            '',
        mode: _getModeString(data),
        sessionDuration:
            data['sessionDurationHours'] as String? ??
            data['sessionDuration'] as String? ??
            '',
        email: data['email'] as String? ?? '',
        contactNumber: data['contactNumber'] as String? ?? '',
        messenger: data['messenger'] as String? ?? '',
        instagram: data['instagram'] as String? ?? '',
        others:
            data['otherAccounts'] as String? ?? data['others'] as String? ?? '',
        availableSchedule: availableSchedule,
      );
    }).toList();

    return tutors;
  } catch (e) {
    print('Error fetching tutors from Firestore: $e');
    // Return mock data as fallback
    return availableTutors;
  }
}

Future<List<ReviewData>> fetchRecentTutorReviews(
  String tutorId, {
  int limit = 5,
}) async {
  if (tutorId.trim().isEmpty) {
    return const <ReviewData>[];
  }

  try {
    final snapshot = await _firestore
        .collection(SessionFeedbackRecord.collectionName)
        .where('recipientId', isEqualTo: tutorId)
        .where(
          'direction',
          isEqualTo: SessionFeedbackRecord.directionStudentToTutor,
        )
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    final feedback = snapshot.docs
        .map(SessionFeedbackRecord.fromDoc)
        .toList(growable: false);
    final studentProfiles = await _loadUserProfiles(
      feedback.map((item) => item.authorId).toSet(),
    );

    return feedback
        .map((item) {
          final studentProfile = studentProfiles[item.authorId];
          final program = _asString(studentProfile?['program']);

          return ReviewData(
            feedbackId: item.feedbackId,
            bookingId: item.bookingId,
            name: _displayNameFromProfile(studentProfile, fallback: 'Student'),
            course: program.isEmpty ? null : program,
            rating: item.rating ?? 0,
            comment: item.comment.isEmpty
                ? 'No comment provided.'
                : item.comment,
            imagePath: _profileImageSource(studentProfile),
          );
        })
        .toList(growable: false);
  } catch (error) {
    print('Error fetching tutor reviews: $error');
    return const <ReviewData>[];
  }
}

/// Helper function to construct mode string from boolean fields
String _getModeString(Map<String, dynamic> data) {
  final modesFromList = _toStringList(data['modeOfTutoring']);
  if (modesFromList.isNotEmpty) {
    return modesFromList
        .map((mode) {
          switch (mode.trim().toLowerCase()) {
            case 'online':
              return 'Online';
            case 'face_to_face':
              return 'Face-to-Face';
            case 'hybrid':
              return 'Hybrid';
            default:
              return mode;
          }
        })
        .join(', ');
  }

  final List<String> modes = [];

  if (data['isOnlineSelected'] == true) modes.add('Online');
  if (data['isFaceToFaceSelected'] == true) modes.add('Face-to-Face');
  if (data['isHybridSelected'] == true) modes.add('Hybrid');

  return modes.isNotEmpty ? modes.join(', ') : 'Not specified';
}

Map<String, _TutorRatingSummary> _buildTutorRatingSummaries(
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
) {
  final totalsByTutor = <String, int>{};
  final countsByTutor = <String, int>{};

  for (final doc in docs) {
    final feedback = SessionFeedbackRecord.fromDoc(doc);
    final tutorId = feedback.recipientId.trim();
    final rating = feedback.rating;

    if (tutorId.isEmpty || rating == null) {
      continue;
    }

    totalsByTutor[tutorId] = (totalsByTutor[tutorId] ?? 0) + rating;
    countsByTutor[tutorId] = (countsByTutor[tutorId] ?? 0) + 1;
  }

  final summaries = <String, _TutorRatingSummary>{};
  for (final entry in countsByTutor.entries) {
    final tutorId = entry.key;
    final reviewCount = entry.value;
    final total = totalsByTutor[tutorId] ?? 0;
    summaries[tutorId] = _TutorRatingSummary(
      averageRating: reviewCount == 0 ? 0 : total / reviewCount,
      reviewCount: reviewCount,
    );
  }
  return summaries;
}

Future<Map<String, Map<String, dynamic>>> _loadUserProfiles(
  Set<String> userIds,
) async {
  final validIds = userIds.where((userId) => userId.trim().isNotEmpty).toList();
  if (validIds.isEmpty) {
    return const <String, Map<String, dynamic>>{};
  }

  final docs = await Future.wait(
    validIds.map((userId) => _firestore.collection('Users').doc(userId).get()),
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

String _asString(dynamic value) {
  if (value == null) {
    return '';
  }
  return value.toString().trim();
}

class _TutorRatingSummary {
  final double averageRating;
  final int reviewCount;

  const _TutorRatingSummary({this.averageRating = 0, this.reviewCount = 0});
}

List<String> _toStringList(dynamic value) {
  if (value == null) return <String>[];

  if (value is List) {
    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  if (value is String) {
    final normalized = value.trim();
    if (normalized.isEmpty) return <String>[];

    if (normalized.contains(',')) {
      return normalized
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    if (normalized.contains('\n')) {
      return normalized
          .split('\n')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    return <String>[normalized];
  }

  return <String>[value.toString()];
}
