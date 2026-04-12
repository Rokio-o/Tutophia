import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutophia/StudentAccess/menu-feedback.dart';
import 'package:tutophia/StudentAccess/menu-my_booking.dart';
import 'package:tutophia/StudentAccess/session-history-student.dart';
import 'package:tutophia/StudentAccess/session-materials.dart';
import 'package:tutophia/models/notification/app_notification.dart';
import 'package:tutophia/services/repository/notification_repository/notification_repository.dart';
import 'package:tutophia/widgets/student-widgets/notification-student-cards.dart';
import 'package:tutophia/widgets/student-widgets/bottom-navigation-student.dart';
import 'package:tutophia/StudentAccess/profile-student.dart';
import 'package:tutophia/StudentAccess/dashboard-student.dart';

class StudentNotificationsScreen extends StatefulWidget {
  const StudentNotificationsScreen({super.key});

  @override
  State<StudentNotificationsScreen> createState() =>
      _StudentNotificationsScreenState();
}

class _StudentNotificationsScreenState
    extends State<StudentNotificationsScreen> {
  static const Color kNavy = Color(0xFF1A3A5C);
  final NotificationRepository _notificationRepository =
      NotificationRepository.instance;

  void _goBackToDashboard() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StudentDashboard()),
    );
  }

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
      forTutor: false,
    );
  }

  Future<void> _clearAllNotifications() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _notificationRepository.deleteAllNotifications(uid);
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
    if (targetScreen == AppNotification.targetStudentBookings) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const StudentBookingsScreen()),
      );
      return;
    }

    if (targetScreen == AppNotification.targetStudentSessionMaterials) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SessionMaterialsScreen()),
      );
      return;
    }

    if (targetScreen == AppNotification.targetStudentTutorAdvice) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const FeedbackScreen(
            initialTab: FeedbackScreenInitialTab.tutorAdvice,
          ),
        ),
      );
      return;
    }

    if (targetScreen == AppNotification.targetStudentSessionHistory) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SessionHistoryScreen()),
      );
    }
  }

  void _showClearConfirmation() {
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
              await _clearAllNotifications();
              if (!ctx.mounted) return;
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: _goBackToDashboard,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'NOTIFICATIONS',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  color: Color(0xff3d6fa5),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Scrollable notification list ──
            Expanded(
              child: uid == null
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          'Please log in to view notifications.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    )
                  : StreamBuilder<List<AppNotification>>(
                      stream: _notificationRepository.watchNotifications(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Failed to load notifications: ${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          );
                        }

                        final notifications =
                            snapshot.data ?? const <AppNotification>[];

                        if (notifications.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                'No notifications',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  final item = notifications[index];
                                  return NotificationStudentCard(
                                    notification: item,
                                    onTap: () => _onNotificationTap(item),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: notifications.isNotEmpty
                                      ? _showClearConfirmation
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kNavy,
                                    disabledBackgroundColor:
                                        Colors.grey.shade400,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    'CLEAR ALL',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavStudent(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const StudentDashboard()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const StudentProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
