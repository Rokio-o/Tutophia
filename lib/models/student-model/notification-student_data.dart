enum StudentNotificationType {
  bookingApproved,
  bookingDeclined,
  sessionReminder,
  newMaterialsUploaded,
  feedbackReceived,
}

class StudentNotificationCardData {
  final StudentNotificationType type;
  final String title;
  final String message;

  const StudentNotificationCardData({
    required this.type,
    required this.title,
    required this.message,
  });
}
