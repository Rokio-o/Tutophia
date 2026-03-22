import 'package:flutter/material.dart';
import 'package:tutophia/models/student-model/notification-student_data.dart';

// ── NotificationStudentCard ───────────────────────────────────────────────────

class NotificationStudentCard extends StatelessWidget {
  final StudentNotificationCardData data;
  final VoidCallback? onTap;

  const NotificationStudentCard({super.key, required this.data, this.onTap});

  _NotificationStyle get _style {
    switch (data.type) {
      case StudentNotificationType.bookingApproved:
        return _NotificationStyle(
          icon: Icons.thumb_up_outlined,
          backgroundColor: const Color(0xFF3D6FA5),
        );
      case StudentNotificationType.bookingDeclined:
        return _NotificationStyle(
          icon: Icons.thumb_down_outlined,
          backgroundColor: const Color(0xFF3D6FA5),
        );
      case StudentNotificationType.sessionReminder:
        return _NotificationStyle(
          icon: Icons.error_outline_rounded,
          backgroundColor: const Color(0xFF3D6FA5),
        );
      case StudentNotificationType.newMaterialsUploaded:
        return _NotificationStyle(
          icon: Icons.upload_rounded,
          backgroundColor: const Color(0xFF3D6FA5),
        );
      case StudentNotificationType.feedbackReceived:
        return _NotificationStyle(
          icon: Icons.star_border_rounded,
          backgroundColor: const Color(0xFF3D6FA5),
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

// ── _NotificationStyle ────────────────────────────────────────────────────────

class _NotificationStyle {
  final IconData icon;
  final Color backgroundColor;

  const _NotificationStyle({required this.icon, required this.backgroundColor});
}

// ── NotificationStudentList ───────────────────────────────────────────────────

class NotificationStudentList extends StatelessWidget {
  final List<StudentNotificationCardData> notifications;
  final void Function(StudentNotificationCardData)? onCardTap;

  const NotificationStudentList({
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
        return NotificationStudentCard(
          data: item,
          onTap: onCardTap != null ? () => onCardTap!(item) : null,
        );
      },
    );
  }
}
