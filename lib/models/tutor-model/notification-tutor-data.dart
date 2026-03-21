// ── NotificationType ──────────────────────────────────────────────────────────

enum NotificationType {
  bookingRequest,
  bookingCancellation,
  sessionReminder,
  feedbackReceived,
}

// ── NotificationCardData ──────────────────────────────────────────────────────

class NotificationCardData {
  final NotificationType type;
  final String title;
  final String message;

  const NotificationCardData({
    required this.type,
    required this.title,
    required this.message,
  });
}
