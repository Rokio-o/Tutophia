import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutophia/services/repository/notification_repository/notification_repository.dart';

class BottomNavStudent extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavStudent({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _notificationIcon() {
    if (currentIndex == 1) {
      // Hide badge on the notifications tab for immediate visual feedback.
      return const Icon(Icons.notifications);
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Icon(Icons.notifications);
    }

    return StreamBuilder<int>(
      stream: NotificationRepository.instance.watchUnreadCount(uid),
      builder: (context, snapshot) {
        final unreadCount = snapshot.data ?? 0;

        if (unreadCount <= 0) {
          return const Icon(Icons.notifications);
        }

        final badgeText = unreadCount > 99 ? '99+' : unreadCount.toString();

        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications),
            Positioned(
              right: -8,
              top: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  badgeText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xfff4a24c),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == currentIndex) return;

        if (index == 1) {
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid != null) {
            unawaited(NotificationRepository.instance.markAllAsRead(uid));
          }
        }

        onTap(index);
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: _notificationIcon(),
          label: "Notifications",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
