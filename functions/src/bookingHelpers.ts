import {getFirestore} from "firebase-admin/firestore";
import {
  FieldValue,
  Timestamp,
  Transaction,
  type QueryDocumentSnapshot,
} from "firebase-admin/firestore";
import {
  CallableRequest,
  HttpsError,
} from "firebase-functions/v2/https";

export const BOOKINGS_COLLECTION = "bookings";
export const USERS_COLLECTION = "Users";
export const NOTIFICATIONS_COLLECTION = "notifications";

export const BOOKING_STATUS = {
  pending: "pending",
  approved: "approved",
  cancelled: "cancelled",
  completed: "completed",
} as const;

export const NOTIFICATION_TYPE = {
  newBookingRequest: "new_booking_request",
  studentCancelledBooking: "student_cancelled_booking",
  bookingApproved: "booking_approved",
  bookingDeclined: "booking_declined",
  sessionReminder: "session_reminder",
} as const;

export const NOTIFICATION_STATUS = {
  unread: "unread",
} as const;

export const TARGET_SCREEN = {
  tutorSessionRequests: "tutor_session_requests",
  studentBookings: "student_my_bookings",
} as const;

type CallableData = Record<string, unknown>;

export interface BookingRecord {
  bookingId: string;
  studentId: string;
  studentName: string;
  tutorId: string;
  tutorName: string;
  subject: string;
  status: string;
  sessionDateTime: Date;
  endDateTime: Date;
}

interface NotificationWriteInput {
  recipientId: string;
  senderId: string;
  bookingId: string;
  type: string;
  title: string;
  body: string;
  targetScreen: string;
  sessionDateTime?: Date | null;
}

export function db() {
  return getFirestore();
}

export function assertAuthenticated(request: CallableRequest<unknown>): string {
  const uid = request.auth?.uid?.trim() ?? "";
  if (!uid) {
    throw new HttpsError("unauthenticated", "Authentication is required.");
  }
  return uid;
}

export function isAdmin(request: CallableRequest<unknown>): boolean {
  return request.auth?.token.admin === true || request.auth?.token.role === "admin";
}

export function getDataMap(data: unknown): CallableData {
  if (!data || typeof data !== "object" || Array.isArray(data)) {
    throw new HttpsError("invalid-argument", "Request payload must be an object.");
  }

  return data as CallableData;
}

export function requireString(data: CallableData, fieldName: string): string {
  const value = data[fieldName];
  if (typeof value != "string") {
    throw new HttpsError(
      "invalid-argument",
      `${fieldName} must be a non-empty string.`,
    );
  }

  const normalized = value.trim();
  if (!normalized) {
    throw new HttpsError(
      "invalid-argument",
      `${fieldName} must be a non-empty string.`,
    );
  }

  return normalized;
}

export function optionalString(data: CallableData, fieldName: string): string {
  const value = data[fieldName];
  if (value == null) {
    return "";
  }

  if (typeof value != "string") {
    throw new HttpsError(
      "invalid-argument",
      `${fieldName} must be a string when provided.`,
    );
  }

  return value.trim();
}

export function requireNumber(data: CallableData, fieldName: string): number {
  const value = data[fieldName];
  if (typeof value != "number" || !Number.isFinite(value)) {
    throw new HttpsError(
      "invalid-argument",
      `${fieldName} must be a valid number.`,
    );
  }

  return value;
}

export function requireDateFromMillis(
  data: CallableData,
  fieldName: string,
): Date {
  const value = requireNumber(data, fieldName);
  const result = new Date(value);

  if (Number.isNaN(result.getTime())) {
    throw new HttpsError(
      "invalid-argument",
      `${fieldName} must be a valid timestamp in milliseconds.`,
    );
  }

  return result;
}

export function queueNotificationWrite(
  transaction: Transaction,
  input: NotificationWriteInput,
): void {
  const notificationRef = db()
    .collection(USERS_COLLECTION)
    .doc(input.recipientId)
    .collection(NOTIFICATIONS_COLLECTION)
    .doc();

  transaction.set(notificationRef, {
    id: notificationRef.id,
    type: input.type,
    title: input.title,
    body: input.body,
    recipientId: input.recipientId,
    senderId: input.senderId,
    bookingId: input.bookingId,
    status: NOTIFICATION_STATUS.unread,
    targetScreen: input.targetScreen,
    createdAt: FieldValue.serverTimestamp(),
    sessionDateTime: input.sessionDateTime ?
      Timestamp.fromDate(input.sessionDateTime) :
      null,
  });
}

export function mapBookingDoc(
  doc: QueryDocumentSnapshot,
): BookingRecord {
  const data = doc.data();
  const sessionDateTime = asDate(data.sessionDateTime, "sessionDateTime");
  const endDateTime = asDate(data.endDateTime, "endDateTime");

  return {
    bookingId: asString(data.bookingId) || doc.id,
    studentId: asString(data.studentId),
    studentName: asString(data.studentName),
    tutorId: asString(data.tutorId),
    tutorName: asString(data.tutorName),
    subject: asString(data.subject),
    status: asString(data.status),
    sessionDateTime,
    endDateTime,
  };
}

export async function findApprovedOverlap(
  transaction: Transaction,
  tutorId: string,
  start: Date,
  end: Date,
  ignoredBookingId = "",
): Promise<BookingRecord | null> {
  const snapshot = await transaction.get(
    db()
      .collection(BOOKINGS_COLLECTION)
      .where("tutorId", "==", tutorId)
      .where("status", "in", [
        BOOKING_STATUS.pending,
        BOOKING_STATUS.approved,
      ])
      .where("sessionDateTime", "<", Timestamp.fromDate(end)),
  );

  for (const doc of snapshot.docs) {
    if (doc.id === ignoredBookingId) {
      continue;
    }

    const booking = mapBookingDoc(doc);
    const overlaps =
      booking.endDateTime.getTime() > start.getTime() &&
      booking.sessionDateTime.getTime() < end.getTime();

    if (overlaps && booking.status === BOOKING_STATUS.approved) {
      return booking;
    }
  }

  return null;
}

export function formatSessionDateTime(value: Date): string {
  const hour24 = value.getHours();
  const hour12 = hour24 === 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
  const minute = value.getMinutes().toString().padStart(2, "0");
  const suffix = hour24 >= 12 ? "pm" : "am";

  return `${value.getMonth() + 1}/${value.getDate()}/${value.getFullYear()} ` +
    `${hour12}:${minute} ${suffix}`;
}

function asString(value: unknown): string {
  if (typeof value === "string") {
    return value.trim();
  }

  if (value == null) {
    return "";
  }

  return String(value).trim();
}

function asDate(value: unknown, fieldName: string): Date {
  if (value instanceof Timestamp) {
    return value.toDate();
  }

  if (value instanceof Date) {
    return value;
  }

  if (typeof value === "number") {
    const date = new Date(value);
    if (!Number.isNaN(date.getTime())) {
      return date;
    }
  }

  if (typeof value === "string") {
    const date = new Date(value);
    if (!Number.isNaN(date.getTime())) {
      return date;
    }
  }

  throw new HttpsError(
    "internal",
    `Booking document is missing a valid ${fieldName}.`,
  );
}
