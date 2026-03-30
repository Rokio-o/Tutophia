import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutophia/models/student-model/tutor_data.dart';

// Firestore instance
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Temporary tutor data - Used as fallback/mock data
final List<TutorData> availableTutors = [
  
];

/// Fetches all tutors from Firestore (Users collection where role = 'tutor')
Future<List<TutorData>> fetchAllTutors() async {
  try {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('Users')
        .where('accountType', isEqualTo: 'tutor')
        .get();

    final List<TutorData> tutors = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      // Combine firstName and lastName into name
      final firstName = data['firstName'] as String? ?? '';
      final lastName = data['lastName'] as String? ?? '';
      final fullName = '${firstName.trim()} ${lastName.trim()}'.trim();

      // Parse rating and reviews
      final ratingValue = data['rating'] ?? 0;
      final rating = ratingValue is num ? ratingValue.toString() : '0';
      
      final reviewCount = data['reviewCount'] ?? 0;
      final reviews = reviewCount is num ? '($reviewCount reviews)' : '(0 reviews)';

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
        name: fullName,
        role: data['tutorType'] as String? ?? 'Student Tutor',
        location: data['address'] as String? ?? 'Not specified',
        sessionRate: sessionRate,
        rating: rating,
        reviews: reviews,
        subjects: subjects,
        imagePath: data['profileImagePath'] as String? ?? '',
        description:
            data['teachingDescription'] as String? ??
            data['description'] as String? ??
            '',
        department: data['department'] as String? ?? '',
        program: data['program'] as String? ?? '',
        yearLevel: data['yearSpent'] as String? ?? '',
        tutoringExperience: data['tutoringExperience'] as String? ?? '',
        mode: _getModeString(data),
        sessionDuration:
            data['sessionDurationHours'] as String? ??
            data['sessionDuration'] as String? ??
            '',
        email: data['email'] as String? ?? '',
        contactNumber: data['contactNumber'] as String? ?? '',
        messenger: data['messenger'] as String? ?? '',
        instagram: data['instagram'] as String? ?? '',
        others: data['otherAccounts'] as String? ?? data['others'] as String? ?? '',
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
