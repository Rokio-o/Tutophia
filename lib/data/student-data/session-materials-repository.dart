import 'package:tutophia/models/student-model/session-material_data.dart';

// ── Dummy data — replace with backend fetch when ready ──
final List<SessionMaterialData> sessionMaterialsList = [
  SessionMaterialData(
    id: 'mat_001',
    title: 'Introduction to Figma',
    uploaderName: 'Jeancess Gallo',
    uploaderId: 'tutor_001',
    fileUrl: 'https://example.com/files/intro-to-figma.pdf',
    fileType: 'pdf',
    uploadedAt: DateTime(2026, 2, 20),
  ),
  SessionMaterialData(
    id: 'mat_002',
    title: 'UI-UX Guidelines',
    uploaderName: 'Jeancess Gallo',
    uploaderId: 'tutor_001',
    fileUrl: 'https://example.com/files/ui-ux-guidelines.pdf',
    fileType: 'pdf',
    uploadedAt: DateTime(2026, 2, 22),
  ),
];
