import 'package:tutophia/models/tutor-model/feedback-tutor-data.dart';

// ── Students pending feedback ─────────────────────────────────────────────────

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

// ── Feedback tutor has already given ─────────────────────────────────────────

final List<TutorFeedbackGivenData> sampleFeedbackGiven = [
  const TutorFeedbackGivenData(
    id: '1',
    studentName: 'Isaac Rei Aniceta',
    program: 'Computer Science',
    feedback:
        'Isaac is doing well overall. I recommend focusing more on problem decomposition and practicing algorithmic thinking through daily exercises.',
  ),
  const TutorFeedbackGivenData(
    id: '2',
    studentName: 'Lance Gerald Ferangco',
    program: 'Computer Science',
    feedback:
        'Lance shows great enthusiasm. Keep up the consistent attendance and review the topics we covered on data structures.',
  ),
];

// ── Star ratings students gave to the tutor ───────────────────────────────────

final List<StudentRatingData> sampleStudentRatings = [
  const StudentRatingData(
    id: '1',
    studentName: 'Juliana Aura Fortu',
    program: 'Computer Science',
    rating: 5,
    comment: 'Attentive and interested to the session',
  ),
  const StudentRatingData(
    id: '2',
    studentName: 'Chilldon Paul Carreon',
    program: 'Computer Science',
    rating: 4,
    comment: 'A little bit late to the session but it ends very well',
  ),
];
