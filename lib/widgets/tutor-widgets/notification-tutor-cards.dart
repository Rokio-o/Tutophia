import 'package:flutter/material.dart';

enum NotificationType {
  bookingRequest,
  bookingCancellation,
  sessionReminder,
  feedbackReceived,
}

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

class NotificationTutorCard extends StatelessWidget {
  final NotificationCardData data;
  final VoidCallback? onTap;

  const NotificationTutorCard({super.key, required this.data, this.onTap});

  _NotificationStyle get _style {
    switch (data.type) {
      case NotificationType.bookingRequest:
        return _NotificationStyle(
          icon: Icons.help_outline_rounded,
          backgroundColor: const Color(0xff3d6fa5),
        );
      case NotificationType.bookingCancellation:
        return _NotificationStyle(
          icon: Icons.close_rounded,
          backgroundColor: const Color(0xff3d6fa5),
        );
      case NotificationType.sessionReminder:
        return _NotificationStyle(
          icon: Icons.info_outline_rounded,
          backgroundColor: const Color(0xff3d6fa5),
        );
      case NotificationType.feedbackReceived:
        return _NotificationStyle(
          icon: Icons.star_border_rounded,
          backgroundColor: const Color(0xff3d6fa5),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F0E8),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon circle
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: style.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(style.icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    data.message,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF555566),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationStyle {
  final IconData icon;
  final Color backgroundColor;

  const _NotificationStyle({required this.icon, required this.backgroundColor});
}

// ── Notification List Widget ─────────────────────────────────────────────────

class NotificationTutorList extends StatelessWidget {
  final List<NotificationCardData> notifications;
  final void Function(NotificationCardData)? onCardTap;

  const NotificationTutorList({
    super.key,
    required this.notifications,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        return NotificationTutorCard(
          data: item,
          onTap: onCardTap != null ? () => onCardTap!(item) : null,
        );
      },
    );
  }
}

// ── Sample Usage / Demo Screen ────────────────────────────────────────────────

class NotificationTutorScreen extends StatelessWidget {
  const NotificationTutorScreen({super.key});

  static final List<NotificationCardData> _sampleNotifications = [
    NotificationCardData(
      type: NotificationType.bookingRequest,
      title: 'Booking Request',
      message: 'Student Wenifredo request to have a tutoring session with you',
    ),
    NotificationCardData(
      type: NotificationType.bookingCancellation,
      title: 'Booking Cancellation',
      message:
          'Student Wenifredo cancelled the tutoring session; Reason: Schedule Conflict',
    ),
    NotificationCardData(
      type: NotificationType.sessionReminder,
      title: 'Session Reminder',
      message: 'You have tutoring session with student Wenifredo today at 10am',
    ),
    NotificationCardData(
      type: NotificationType.feedbackReceived,
      title: 'Feedback Received',
      message:
          'Student named Wenifredo gave you a rate and descriptive feedback',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EBE0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EBE0),
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: NotificationTutorList(
          notifications: _sampleNotifications,
          onCardTap: (item) {
            debugPrint('Tapped: ${item.title}');
          },
        ),
      ),
    );
  }
}

// ── Entry Point ───────────────────────────────────────────────────────────────

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationTutorScreen(),
    ),
  );
}
