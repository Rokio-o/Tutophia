import 'package:tutophia/models/tutor-model/notification-tutor-data.dart';

// ── Sample Notifications ──────────────────────────────────────────────────────

final List<NotificationCardData> sampleTutorNotifications = [
  const NotificationCardData(
    type: NotificationType.bookingRequest,
    title: 'Booking Request',
    message: 'Student Wenifredo request to have a tutoring session with you',
  ),
  const NotificationCardData(
    type: NotificationType.bookingCancellation,
    title: 'Booking Cancellation',
    message:
        'Student Wenifredo cancelled the tutoring session; Reason: Schedule Conflict',
  ),
  const NotificationCardData(
    type: NotificationType.sessionReminder,
    title: 'Session Reminder',
    message: 'You have tutoring session with student Wenifredo today at 10am',
  ),
  const NotificationCardData(
    type: NotificationType.feedbackReceived,
    title: 'Feedback Received',
    message: 'Student named Wenifredo gave you a rate and descriptive feedback',
  ),
];
