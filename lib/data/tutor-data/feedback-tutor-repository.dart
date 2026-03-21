import 'package:tutophia/models/tutor-model/feedback-tutor-data.dart';

// ── Sample Students To Rate ───────────────────────────────────────────────────

final List<StudentToRateData> sampleStudentsToRate = [
  const StudentToRateData(
    id: '1',
    name: 'Isaac Rei Aniceta',
    program: 'Computer Science',
  ),
  const StudentToRateData(
    id: '2',
    name: 'Lance Gerald Ferangco',
    program: 'Computer Science',
  ),
  const StudentToRateData(
    id: '3',
    name: 'Ariah Mae Lindo',
    program: 'Computer Science',
  ),
];

// ── Sample My Reviews ─────────────────────────────────────────────────────────

final List<ReviewData> sampleMyReviews = [
  const ReviewData(
    id: '1',
    studentName: 'Isaac Rei Aniceta',
    program: 'Computer Science',
    rating: 5,
    comment: 'Good communication skills, voice is clear, and very friendly',
  ),
  const ReviewData(
    id: '2',
    studentName: 'Lance Gerald Ferangco',
    program: 'Computer Science',
    rating: 5,
    comment: 'Great and helpful tutor',
  ),
];
