import 'package:tutophia/models/student-model/notification-student_data.dart';

final List<StudentNotificationCardData> studentNotificationList = [
  const StudentNotificationCardData(
    type: StudentNotificationType.bookingApproved,
    title: 'Booking Approved',
    message: 'Tutor Jeancess confirmed your tutoring session request',
  ),
  const StudentNotificationCardData(
    type: StudentNotificationType.bookingDeclined,
    title: 'Booking Declined',
    message:
        'Tutor Ace declined your tutoring session request\nReason: Not available',
  ),
  const StudentNotificationCardData(
    type: StudentNotificationType.sessionReminder,
    title: 'Reminder for Session',
    message: 'Your session with Tutor Ace is coming up\nReason: Not available',
  ),
  const StudentNotificationCardData(
    type: StudentNotificationType.newMaterialsUploaded,
    title: 'New Materials Uploaded',
    message: 'Tutor Jeancess upload materials\nSubject: Additional Reviewers',
  ),
  const StudentNotificationCardData(
    type: StudentNotificationType.feedbackReceived,
    title: 'Feedback Received',
    message: 'Tutor Jeancess gives a descriptive feedback about you',
  ),
];
