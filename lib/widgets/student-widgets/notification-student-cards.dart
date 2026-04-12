import 'package:flutter/material.dart';
import 'package:tutophia/models/notification/app_notification.dart';

// ── NotificationStudentCard ───────────────────────────────────────────────────

class NotificationStudentCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;

  const NotificationStudentCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  _NotificationStyle get _style {
    switch (notification.type) {
      case AppNotification.typeBookingApproved:
        return _NotificationStyle(
          icon: Icons.thumb_up_outlined,
          backgroundColor: const Color(0xFF3D6FA5),
        );
      case AppNotification.typeBookingDeclined:
        return _NotificationStyle(
          icon: Icons.thumb_down_outlined,
          backgroundColor: const Color(0xFF3D6FA5),
        );
      case AppNotification.typeSessionReminder:
        return _NotificationStyle(
          icon: Icons.notifications_active_outlined,
          backgroundColor: const Color(0xFF3D6FA5),
        );
      case AppNotification.typeMaterialUploaded:
        return _NotificationStyle(
          icon: Icons.menu_book_outlined,
          backgroundColor: const Color(0xFF3D6FA5),
        );
      case AppNotification.typeTutorFeedbackReceived:
        return _NotificationStyle(
          icon: Icons.rate_review_outlined,
          backgroundColor: const Color(0xFF3D6FA5),
        );
      case AppNotification.typeBookingCompleted:
        return _NotificationStyle(
          icon: Icons.history_toggle_off_rounded,
          backgroundColor: const Color(0xFF3D6FA5),
        );
      case AppNotification.typeNewBookingRequest:
      case AppNotification.typeStudentCancelledBooking:
        return _NotificationStyle(
          icon: Icons.info_outline_rounded,
          backgroundColor: const Color(0xFF3D6FA5),
        );
      default:
        return _NotificationStyle(
          icon: Icons.notifications_none_rounded,
          backgroundColor: const Color(0xFF3D6FA5),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final isRead = notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isRead ? const Color(0xFFF7F7F7) : const Color(0xFFF5F0E8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isRead ? const Color(0xFFE3E3E3) : const Color(0xFFD9C7AB),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
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
                    notification.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: isRead
                          ? const Color(0xFF7B7B8C)
                          : const Color(0xFF555566),
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
  final List<AppNotification> notifications;
  final void Function(AppNotification)? onCardTap;

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
          notification: item,
          onTap: onCardTap != null ? () => onCardTap!(item) : null,
        );
      },
    );
  }
}
