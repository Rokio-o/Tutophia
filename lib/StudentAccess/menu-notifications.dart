import 'package:flutter/material.dart';

// Global variable — persists across navigation
bool hasNotification = true;

class StudentNotificationsScreen extends StatefulWidget {
  const StudentNotificationsScreen({super.key});

  @override
  State<StudentNotificationsScreen> createState() =>
      _StudentNotificationsScreenState();
}

class _StudentNotificationsScreenState
    extends State<StudentNotificationsScreen> {
  static const Color kNavy = Color(0xFF1A3A5C);

  final _notification = const _NotifData(
    title: 'Booking Approved',
    body: 'Tutor Jeancess confirmed your tutoring session request',
  );

  void _showClearConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ClearNotificationsDialog(
        onYes: () {
          Navigator.of(context).pop();
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
          setState(() => hasNotification = false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                child: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 24),
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

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                children: hasNotification
                    ? [_NotifCard(data: _notification)]
                    : [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              'No notifications',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: hasNotification ? _showClearConfirmation : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNavy,
                    disabledBackgroundColor: Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'CLEAR ALL',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xfff4a24c),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notification"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.data});
  final _NotifData data;

  static const Color kCardBg = Color(0xFFF5F0EA);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff3d6fa5),
            ),
            child: const Icon(Icons.thumb_up, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.body,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifData {
  final String title;
  final String body;

  const _NotifData({
    required this.title,
    required this.body,
  });
}

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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
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