import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutophia/models/notification/app_notification.dart';
import 'package:tutophia/models/student-model/booking_data.dart';

class NotificationRepository {
  NotificationRepository._();

  static final NotificationRepository instance = NotificationRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> createNotification({
    required String recipientId,
    required String type,
    required String title,
    required String body,
    required String targetScreen,
    String? senderId,
    String? bookingId,
    String status = AppNotification.statusUnread,
    DateTime? sessionDateTime,
  }) async {
    if (recipientId.trim().isEmpty) return;

    final docRef = _notificationsRef(recipientId).doc();

    await docRef.set({
      'id': docRef.id,
      'type': type,
      'title': title,
      'body': body,
      'recipientId': recipientId,
      'senderId': senderId,
      'bookingId': bookingId,
      'status': status,
      'targetScreen': targetScreen,
      'createdAt': FieldValue.serverTimestamp(),
      'sessionDateTime':
          sessionDateTime == null ? null : Timestamp.fromDate(sessionDateTime),
    });
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

  Future<void> ensureTodaySessionReminders({
    required String uid,
    required bool forTutor,
  }) async {
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final participantField = forTutor ? 'tutorId' : 'studentId';

    final snapshot = await _firestore
        .collection('bookings')
        .where(participantField, isEqualTo: uid)
        .where('status', isEqualTo: BookingData.statusApproved)
        .where('sessionDateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
        .where('sessionDateTime', isLessThan: Timestamp.fromDate(dayEnd))
        .get();

    for (final doc in snapshot.docs) {
      final booking = BookingData.fromDoc(doc);
      await createSessionReminderIfMissing(
        recipientId: uid,
        booking: booking,
        forTutor: forTutor,
      );
    }
  }

  Future<void> createSessionReminderIfMissing({
    required String recipientId,
    required BookingData booking,
    required bool forTutor,
  }) async {
    final existing = await _notificationsRef(recipientId)
        .where('type', isEqualTo: AppNotification.typeSessionReminder)
        .where('bookingId', isEqualTo: booking.bookingId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) return;

    final title = 'Session Reminder';
    final body = forTutor
        ? 'You have an approved session with ${booking.studentName} today at ${_formatTime(booking.sessionDateTime)}.'
        : 'Your session with ${booking.tutorName} is scheduled today at ${_formatTime(booking.sessionDateTime)}.';

    await createNotification(
      recipientId: recipientId,
      type: AppNotification.typeSessionReminder,
      title: title,
      body: body,
      senderId: forTutor ? booking.studentId : booking.tutorId,
      bookingId: booking.bookingId,
      targetScreen: forTutor
          ? AppNotification.targetTutorSessionRequests
          : AppNotification.targetStudentBookings,
      sessionDateTime: booking.sessionDateTime,
    );
  }

  String _formatTime(DateTime value) {
    final hour =
        value.hour == 0 ? 12 : (value.hour > 12 ? value.hour - 12 : value.hour);
    final minute = value.minute.toString().padLeft(2, '0');
    final suffix = value.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $suffix';
  }
}
