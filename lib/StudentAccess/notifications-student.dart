import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutophia/StudentAccess/menu-my_booking.dart';
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

  Future<void> _markAllAsRead() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _notificationRepository.markAllAsRead(uid);
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

    // TODO: Add additional target screen routes as more notification types are added.
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ClearNotificationsDialog(
        onYes: () async {
          Navigator.of(context).pop();
          await _markAllAsRead();
          if (!mounted) return;
          _showClearedDialog();
        },
        onNo: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showClearedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => NotificationsClearedDialog(
        onOkay: () {
          Navigator.of(context).pop();
        },
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
                onTap: () => Navigator.pop(context),
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
                          return const Center(child: CircularProgressIndicator());
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
                                    disabledBackgroundColor: Colors.grey.shade400,
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

// ── ClearNotificationsDialog ──────────────────────────────────────────────────

class ClearNotificationsDialog extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;

  const ClearNotificationsDialog({
    super.key,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Clear all\nnotifications?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DialogButton(
                  label: 'Yes',
                  color: const Color(0xff3d6fa5),
                  onPressed: onYes,
                ),
                const SizedBox(width: 12),
                _DialogButton(
                  label: 'No',
                  color: const Color(0xff3d6fa5),
                  onPressed: onNo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── NotificationsClearedDialog ────────────────────────────────────────────────

class NotificationsClearedDialog extends StatelessWidget {
  final VoidCallback onOkay;

  const NotificationsClearedDialog({super.key, required this.onOkay});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Notifications\nCleared!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff2e7d32),
              ),
            ),
            const SizedBox(height: 24),
            _DialogButton(
              label: 'Okay',
              color: const Color(0xff3d6fa5),
              onPressed: onOkay,
            ),
          ],
        ),
      ),
    );
  }
}

// ── _DialogButton ─────────────────────────────────────────────────────────────

class _DialogButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _DialogButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
