import {FieldValue, Timestamp} from "firebase-admin/firestore";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import {
  BOOKING_STATUS,
  BOOKINGS_COLLECTION,
  NOTIFICATION_TYPE,
  TARGET_SCREEN,
  assertAuthenticated,
  db,
  findApprovedOverlap,
  formatSessionDateTime,
  getDataMap,
  isAdmin,
  mapBookingDoc,
  optionalString,
  queueNotificationWrite,
  requireDateFromMillis,
  requireNumber,
  requireString,
} from "./bookingHelpers.js";

interface BookingMutationResult {
  success: true;
  bookingId: string;
  status: string;
}

interface ReminderMutationResult {
  success: true;
  createdCount: number;
}

export const createBooking = onCall(async (request): Promise<BookingMutationResult> => {
  const callerUid = assertAuthenticated(request);
  const data = getDataMap(request.data);

  const studentId = requireString(data, "studentId");
  if (studentId !== callerUid && !isAdmin(request)) {
    throw new HttpsError(
      "permission-denied",
      "You can only create bookings for your own account.",
    );
  }

  const studentName = requireString(data, "studentName");
  const tutorId = requireString(data, "tutorId");
  const tutorName = requireString(data, "tutorName");
  const subject = requireString(data, "subject");
  const topic = requireString(data, "topic");
  const mode = requireString(data, "mode");
  const sessionDateTime = requireDateFromMillis(data, "sessionDateTimeMs");
  const endDateTime = requireDateFromMillis(data, "endDateTimeMs");
  const durationMinutes = requireNumber(data, "durationMinutes");
  const hourlyRate = requireNumber(data, "hourlyRate");
  const totalPrice = requireNumber(data, "totalPrice");

  if (endDateTime.getTime() <= sessionDateTime.getTime()) {
    throw new HttpsError(
      "invalid-argument",
      "endDateTimeMs must be after sessionDateTimeMs.",
    );
  }

  if (durationMinutes <= 0 || hourlyRate < 0 || totalPrice < 0) {
    throw new HttpsError(
      "invalid-argument",
      "Booking duration and pricing values must be valid positive numbers.",
    );
  }

  const bookingRef = db().collection(BOOKINGS_COLLECTION).doc();

  await db().runTransaction(async (transaction) => {
    transaction.set(bookingRef, {
      bookingId: bookingRef.id,
      studentId,
      studentName,
      studentProgram: optionalString(data, "studentProgram"),
      tutorId,
      tutorName,
      tutorType: optionalString(data, "tutorType"),
      tutorImagePath: optionalString(data, "tutorImagePath"),
      subject,
      topic,
      mode,
      location: optionalString(data, "location"),
      sessionDateTime: Timestamp.fromDate(sessionDateTime),
      endDateTime: Timestamp.fromDate(endDateTime),
      durationMinutes,
      hourlyRate,
      totalPrice,
      studentNotes: requireString(data, "studentNotes"),
      status: BOOKING_STATUS.pending,
      meetingLink: optionalString(data, "meetingLink"),
      cancelledBy: "",
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
      completedAt: null,
    });

    queueNotificationWrite(transaction, {
      recipientId: tutorId,
      senderId: studentId,
      bookingId: bookingRef.id,
      type: NOTIFICATION_TYPE.newBookingRequest,
      title: "New Booking Request",
      body: `${studentName} requested a ${subject} session on ` +
        `${formatSessionDateTime(sessionDateTime)}.`,
      targetScreen: TARGET_SCREEN.tutorSessionRequests,
      sessionDateTime,
    });
  });

  return {
    success: true,
    bookingId: bookingRef.id,
    status: BOOKING_STATUS.pending,
  };
});

export const approveBooking = onCall(async (request): Promise<BookingMutationResult> => {
  const callerUid = assertAuthenticated(request);
  const data = getDataMap(request.data);
  const bookingId = requireString(data, "bookingId");
  const meetingLink = optionalString(data, "meetingLink");

  await db().runTransaction(async (transaction) => {
    const bookingRef = db().collection(BOOKINGS_COLLECTION).doc(bookingId);
    const bookingSnap = await transaction.get(bookingRef);

    if (!bookingSnap.exists) {
      throw new HttpsError("not-found", "Booking not found.");
    }

    const bookingData = bookingSnap.data() ?? {};
    const tutorId = String(bookingData.tutorId ?? "").trim();
    if (callerUid !== tutorId && !isAdmin(request)) {
      throw new HttpsError(
        "permission-denied",
        "Only the assigned tutor can approve this booking.",
      );
    }

    const currentStatus = String(bookingData.status ?? "").trim();
    if (currentStatus !== BOOKING_STATUS.pending) {
      throw new HttpsError(
        "failed-precondition",
        "Only pending bookings can be approved.",
        {reason: "invalid_status", currentStatus},
      );
    }

    const sessionDateTime = (bookingData.sessionDateTime as Timestamp).toDate();
    const endDateTime = (bookingData.endDateTime as Timestamp).toDate();
    const conflict = await findApprovedOverlap(
      transaction,
      tutorId,
      sessionDateTime,
      endDateTime,
      bookingId,
    );

    if (conflict) {
      throw new HttpsError(
        "failed-precondition",
        "The tutor already has an approved booking during this time.",
        {
          reason: "booking_overlap",
          conflictingBookingId: conflict.bookingId,
          sessionDateTimeMs: conflict.sessionDateTime.getTime(),
        },
      );
    }

    transaction.update(bookingRef, {
      status: BOOKING_STATUS.approved,
      meetingLink,
      updatedAt: FieldValue.serverTimestamp(),
      cancelledBy: "",
    });

    queueNotificationWrite(transaction, {
      recipientId: String(bookingData.studentId ?? "").trim(),
      senderId: tutorId,
      bookingId,
      type: NOTIFICATION_TYPE.bookingApproved,
      title: "Booking Approved",
      body: `${String(bookingData.tutorName ?? "Tutor").trim()} approved ` +
        `your booking for ${String(bookingData.subject ?? "this session").trim()} ` +
        `on ${formatSessionDateTime(sessionDateTime)}.`,
      targetScreen: TARGET_SCREEN.studentBookings,
      sessionDateTime,
    });
  });

  return {
    success: true,
    bookingId,
    status: BOOKING_STATUS.approved,
  };
});

export const cancelBooking = onCall(async (request): Promise<BookingMutationResult> => {
  const callerUid = assertAuthenticated(request);
  const data = getDataMap(request.data);
  const bookingId = requireString(data, "bookingId");

  const nextStatus = BOOKING_STATUS.cancelled;

  await db().runTransaction(async (transaction) => {
    const bookingRef = db().collection(BOOKINGS_COLLECTION).doc(bookingId);
    const bookingSnap = await transaction.get(bookingRef);

    if (!bookingSnap.exists) {
      throw new HttpsError("not-found", "Booking not found.");
    }

    const bookingData = bookingSnap.data() ?? {};
    const studentId = String(bookingData.studentId ?? "").trim();
    const tutorId = String(bookingData.tutorId ?? "").trim();
    const currentStatus = String(bookingData.status ?? "").trim();

    if (
      currentStatus === BOOKING_STATUS.cancelled ||
      currentStatus === BOOKING_STATUS.completed
    ) {
      throw new HttpsError(
        "failed-precondition",
        "This booking can no longer be cancelled.",
        {reason: "invalid_status", currentStatus},
      );
    }

    let cancelledBy = "";
    if (callerUid === studentId) {
      cancelledBy = "student";
    } else if (callerUid === tutorId) {
      cancelledBy = "tutor";
    } else {
      throw new HttpsError(
        "permission-denied",
        "Only the student or tutor can cancel this booking.",
      );
    }

    transaction.update(bookingRef, {
      status: nextStatus,
      cancelledBy,
      updatedAt: FieldValue.serverTimestamp(),
    });

    const sessionDateTime = (bookingData.sessionDateTime as Timestamp).toDate();
    const subject = String(bookingData.subject ?? "this session").trim();

    if (cancelledBy === "student") {
      queueNotificationWrite(transaction, {
        recipientId: tutorId,
        senderId: studentId,
        bookingId,
        type: NOTIFICATION_TYPE.studentCancelledBooking,
        title: "Booking Cancelled by Student",
        body: `${String(bookingData.studentName ?? "A student").trim()} ` +
          `cancelled the session for ${subject} on ` +
          `${formatSessionDateTime(sessionDateTime)}.`,
        targetScreen: TARGET_SCREEN.tutorSessionRequests,
        sessionDateTime,
      });
      return;
    }

    queueNotificationWrite(transaction, {
      recipientId: studentId,
      senderId: tutorId,
      bookingId,
      type: NOTIFICATION_TYPE.bookingDeclined,
      title: "Booking Declined",
      body: `${String(bookingData.tutorName ?? "Your tutor").trim()} declined ` +
        `or cancelled your booking for ${subject} on ` +
        `${formatSessionDateTime(sessionDateTime)}.`,
      targetScreen: TARGET_SCREEN.studentBookings,
      sessionDateTime,
    });
  });

  return {
    success: true,
    bookingId,
    status: nextStatus,
  };
});

export const completeBooking = onCall(async (request): Promise<BookingMutationResult> => {
  const callerUid = assertAuthenticated(request);
  const data = getDataMap(request.data);
  const bookingId = requireString(data, "bookingId");

  await db().runTransaction(async (transaction) => {
    const bookingRef = db().collection(BOOKINGS_COLLECTION).doc(bookingId);
    const bookingSnap = await transaction.get(bookingRef);

    if (!bookingSnap.exists) {
      throw new HttpsError("not-found", "Booking not found.");
    }

    const bookingData = bookingSnap.data() ?? {};
    const tutorId = String(bookingData.tutorId ?? "").trim();
    const currentStatus = String(bookingData.status ?? "").trim();

    if (callerUid !== tutorId && !isAdmin(request)) {
      throw new HttpsError(
        "permission-denied",
        "Only the assigned tutor can complete this booking.",
      );
    }

    if (currentStatus !== BOOKING_STATUS.approved) {
      throw new HttpsError(
        "failed-precondition",
        "Only approved bookings can be marked as completed.",
        {reason: "invalid_status", currentStatus},
      );
    }

    transaction.update(bookingRef, {
      status: BOOKING_STATUS.completed,
      completedAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
  });

  return {
    success: true,
    bookingId,
    status: BOOKING_STATUS.completed,
  };
});

export const ensureTodaySessionReminders = onCall(
  async (request): Promise<ReminderMutationResult> => {
    const callerUid = assertAuthenticated(request);
    const data = getDataMap(request.data);
    const forTutor = data.forTutor;

    if (typeof forTutor !== "boolean") {
      throw new HttpsError(
        "invalid-argument",
        "forTutor must be a boolean.",
      );
    }

    const now = new Date();
    const dayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const dayEnd = new Date(dayStart);
    dayEnd.setDate(dayEnd.getDate() + 1);

    const participantField = forTutor ? "tutorId" : "studentId";
    const bookingsSnapshot = await db()
      .collection(BOOKINGS_COLLECTION)
      .where(participantField, "==", callerUid)
      .where("status", "==", BOOKING_STATUS.approved)
      .where("sessionDateTime", ">=", Timestamp.fromDate(dayStart))
      .where("sessionDateTime", "<", Timestamp.fromDate(dayEnd))
      .get();

    let createdCount = 0;

    for (const doc of bookingsSnapshot.docs) {
      const booking = mapBookingDoc(doc);
      const bookingId = booking.bookingId.trim();
      if (!bookingId) {
        continue;
      }

      const sessionDateTime = booking.sessionDateTime;
      const title = "Session Reminder";
      const formattedSessionTime = formatSessionDateTime(sessionDateTime);
      const participantName = forTutor ?
        String(booking.studentName ?? "your student").trim() :
        String(booking.tutorName ?? "your tutor").trim();
      const body = forTutor ?
        `You have an approved session with ${participantName} today at ` +
          `${formattedSessionTime}.` :
        `Your session with ${participantName} is scheduled today at ` +
          `${formattedSessionTime}.`;
      const senderId = forTutor ?
        String(booking.studentId ?? "").trim() :
        String(booking.tutorId ?? "").trim();
      const targetScreen = forTutor ?
        TARGET_SCREEN.tutorSessionRequests :
        TARGET_SCREEN.studentBookings;
      const notificationRef = db()
        .collection("Users")
        .doc(callerUid)
        .collection("notifications")
        .doc(`session_reminder_${bookingId}`);

      await db().runTransaction(async (transaction) => {
        const existingSnapshot = await transaction.get(notificationRef);
        if (existingSnapshot.exists) {
          return;
        }

        transaction.set(notificationRef, {
          id: notificationRef.id,
          type: NOTIFICATION_TYPE.sessionReminder,
          title,
          body,
          recipientId: callerUid,
          senderId,
          bookingId,
          status: "unread",
          targetScreen,
          createdAt: FieldValue.serverTimestamp(),
          sessionDateTime: Timestamp.fromDate(sessionDateTime),
        });

        createdCount += 1;
      });
    }

    return {
      success: true,
      createdCount,
    };
  },
);
