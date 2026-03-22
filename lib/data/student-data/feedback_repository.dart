import 'package:tutophia/models/student-model/feedback_data.dart';

final List<ToRateData> toRateList = [
  const ToRateData(name: 'Jeancess Gallo', role: 'Student Tutor'),
  const ToRateData(name: 'Lawrence Malaga', role: 'Student Tutor'),
];

final List<ReviewData> reviewsList = [
  const ReviewData(
    name: 'Juliana Aura Fortu',
    course: 'BS Computer Science',
    rating: 5,
    comment: 'Attentive and interested to the session',
  ),
  const ReviewData(
    name: 'Chilldon Paul Carreon',
    course: 'BS Information Technology',
    rating: 4,
    comment: 'A little bit late to the session but it ends very well',
  ),
];

final List<TutorAdviceData> tutorAdviceList = [
  const TutorAdviceData(
    tutorName: 'Jeancess Gallo',
    tutorRole: 'Student Tutor',
    advice:
        'You are doing great! Keep practicing the exercises I gave you and focus more on Calculus derivatives.',
  ),
  const TutorAdviceData(
    tutorName: 'Lawrence Malaga',
    tutorRole: 'Student Tutor',
    advice:
        'Good progress overall. I recommend reviewing the UI/UX principles we discussed and applying them to your project.',
  ),
];
