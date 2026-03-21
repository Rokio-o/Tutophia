import 'package:tutophia/models/tutor-model/session-requests-data.dart';
// ── Requests ──────────────────────────────────────────────────────────────────

final List<SessionRequestStudentData> sampleRequestStudents = [
  const SessionRequestStudentData(
    id: '1',
    name: 'Student Name',
    course: 'Program',
  ),
  const SessionRequestStudentData(
    id: '2',
    name: 'Student Name',
    course: 'Program',
  ),
];

// ── Approved ──────────────────────────────────────────────────────────────────

final List<SessionRequestStudentData> sampleApprovedStudents = [
  const SessionRequestStudentData(
    id: '3',
    name: 'Student Name',
    course: 'Program',
  ),
];

// ── Cancelled ─────────────────────────────────────────────────────────────────

final List<SessionRequestStudentData> sampleCancelledStudents = [
  const SessionRequestStudentData(
    id: '4',
    name: 'Student Name',
    course: 'Program',
  ),
];
