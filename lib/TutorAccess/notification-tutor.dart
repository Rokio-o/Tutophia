import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';
import 'package:tutophia/TutorAccess/tutor-menu/session-requests-tutor.dart';
import 'package:tutophia/models/notification/app_notification.dart';
import 'package:tutophia/services/repository/notification_repository/notification_repository.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/notification-tutor-cards.dart';

class TutorNotificationScreen extends StatefulWidget {
  const TutorNotificationScreen({super.key});

  @override
  State<TutorNotificationScreen> createState() =>
      _TutorNotificationScreenState();
}

class _TutorNotificationScreenState extends State<TutorNotificationScreen> {
  int _selectedIndex = 1;
  final NotificationRepository _notificationRepository =
      NotificationRepository.instance;

  @override
  void initState() {
    super.initState();
    _ensureReminders();
  }

  Future<void> _ensureReminders() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _notificationRepository.ensureTodaySessionReminders(
      uid: uid,
      forTutor: true,
    );
  }

  Future<void> _onNotificationTap(AppNotification notification) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (!notification.isRead) {
      await _notificationRepository.markAsRead(uid, notification.id);
    }

    if (!mounted) return;
    _navigateByTarget(notification.targetScreen);
  }

  void _navigateByTarget(String targetScreen) {
    if (targetScreen == AppNotification.targetTutorSessionRequests) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SessionRequestsScreen()),
      );
      return;
    }

    // TODO: Add additional target screen routes as more notification types are added.
  }

  void _clearAll(String uid) {
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
            onPressed: () async {
              await _notificationRepository.markAllAsRead(uid);
              if (!mounted) return;
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
    final uid = FirebaseAuth.instance.currentUser?.uid;

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
                color: Color(0xff3d6fa5),
                letterSpacing: 1.2,
              ),
            ),
          ),

          // ── Notification Cards ─────────────────────────────────────────────
          Expanded(
            child: uid == null
                ? const Center(
                    child: Text(
                      'Please log in to view notifications.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF9999AA),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : StreamBuilder<List<AppNotification>>(
                    stream: _notificationRepository.watchNotifications(uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Error loading notifications: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        );
                      }

                      final notifications =
                          snapshot.data ?? const <AppNotification>[];

                      if (notifications.isEmpty) {
                        return _buildEmptyState();
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NotificationTutorList(
                          notifications: notifications,
                          onCardTap: _onNotificationTap,
                        ),
                      );
                    },
                  ),
          ),

          // ── Clear All Button ───────────────────────────────────────────────
          if (uid != null)
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 20,
                bottom: 16,
                top: 8,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: StreamBuilder<List<AppNotification>>(
                  stream: _notificationRepository.watchNotifications(uid),
                  builder: (context, snapshot) {
                    final notifications =
                        snapshot.data ?? const <AppNotification>[];

                    return ElevatedButton(
                      onPressed:
                          notifications.isEmpty ? null : () => _clearAll(uid),
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
                    );
                  },
                ),
              ),
            ),
        ],
      ),

      // ── Bottom Nav ─────────────────────────────────────────────────────────
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        tabActions: [
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorDashboard()),
          ),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorNotificationScreen()),
          ),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorProfileScreen()),
          ),
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
            color: const Color(0xff3d6fa5).withValues(alpha: 0.25),
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
