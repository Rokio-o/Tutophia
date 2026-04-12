import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:tutophia/models/notification/app_notification.dart';

class NotificationRepository {
  NotificationRepository._();

  static final NotificationRepository instance = NotificationRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    app: Firebase.app(),
    region: 'us-central1',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _notificationsRef(String uid) {
    return _firestore.collection('Users').doc(uid).collection('notifications');
  }

  Stream<List<AppNotification>> watchNotifications(String uid) {
    return _notificationsRef(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppNotification.fromDoc(doc))
              .toList(),
        );
  }

  Stream<int> watchUnreadCount(String uid) {
    return _notificationsRef(uid)
        .where('status', isEqualTo: AppNotification.statusUnread)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> markAsRead(String uid, String notificationId) async {
    await _notificationsRef(uid).doc(notificationId).set({
      'status': AppNotification.statusRead,
    }, SetOptions(merge: true));
  }

  Future<void> markAllAsRead(String uid) async {
    final unread = await _notificationsRef(uid)
        .where('status', isEqualTo: AppNotification.statusUnread)
        .get();

    if (unread.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in unread.docs) {
      batch.set(doc.reference, {
        'status': AppNotification.statusRead,
      }, SetOptions(merge: true));
    }
    await batch.commit();
  }

  Future<void> deleteAllNotifications(String uid) async {
    while (true) {
      final snapshot = await _notificationsRef(uid).limit(400).get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      if (snapshot.docs.length < 400) {
        return;
      }
    }
  }

  Future<void> ensureTodaySessionReminders({
    required String uid,
    required bool forTutor,
  }) async {
    if (uid.trim().isEmpty) return;

    try {
      final user = _auth.currentUser;
      if (user == null || user.uid != uid) {
        return;
      }

      await user.getIdToken(true);
      await _functions.httpsCallable('ensureTodaySessionReminders').call({
        'forTutor': forTutor,
      });
    } on FirebaseFunctionsException catch (error) {
      debugPrint(
        'ensureTodaySessionReminders failed '
        '(${error.code}): ${error.message}',
      );
    } catch (error) {
      debugPrint('ensureTodaySessionReminders failed: $error');
    }
  }
}
