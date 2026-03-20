import 'package:flutter/material.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/notification-tutor-cards.dart';

class TutorNotificationScreen extends StatefulWidget {
  const TutorNotificationScreen({super.key});

  @override
  State<TutorNotificationScreen> createState() =>
      _TutorNotificationScreenState();
}

class _TutorNotificationScreenState extends State<TutorNotificationScreen> {
  int _selectedIndex = 1; // Notifications tab index

  final List<NotificationCardData> _notifications = [
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
      message:
          'Student named Wenifredo gave you a rate and descriptive feedback',
    ),
  ];

  void _clearAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear All Notifications',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: const Text(
          'Are you sure you want to clear all notifications?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF5A5A6E)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff3d6fa5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              setState(() => _notifications.clear());
              Navigator.pop(ctx);
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──────────────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 14, top: 4),
            child: Text(
              'NOTIFICATIONS',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: const Color(0xff3d6fa5),
                letterSpacing: 1.2,
              ),
            ),
          ),

          // ── Notification Cards ─────────────────────────────────────────────
          Expanded(
            child: _notifications.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NotificationTutorList(
                      notifications: _notifications,
                      onCardTap: (item) {
                        debugPrint('Tapped: ${item.title}');
                      },
                    ),
                  ),
          ),

          // ── Clear All Button ───────────────────────────────────────────────
          if (_notifications.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 20,
                bottom: 16,
                top: 8,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _clearAll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3d6fa5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'CLEAR ALL',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),

      // ── Bottom Nav Bar (your existing BottomNavBar widget) ─────────────────
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        tabActions: [
          () {
            // Home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TutorDashboard()),
            );
          },
          () {
            // Notifications — already here, no-op
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const TutorNotificationScreen(),
              ),
            );
          },
          () {
            // Profile
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TutorProfileScreen()),
            );
          },
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 64,
            color: const Color(0xff3d6fa5).withOpacity(0.25),
          ),
          const SizedBox(height: 12),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF9999AA),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
