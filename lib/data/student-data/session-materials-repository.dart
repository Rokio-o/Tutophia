import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tutophia/models/student-model/session-material_data.dart';

class SessionMaterialsRepository {
  SessionMaterialsRepository._();

  static final SessionMaterialsRepository instance =
      SessionMaterialsRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static const List<String> _studentVisibleMaterialStates = [
    SessionMaterialData.visibilityStudentOnly,
    SessionMaterialData.visibilityBookingParticipants,
  ];

  CollectionReference<Map<String, dynamic>> get _materialsRef =>
      _firestore.collection(SessionMaterialData.collectionName);

  Stream<List<SessionMaterialData>> watchStudentMaterials(String studentId) {
    return _materialsRef
        .where('studentId', isEqualTo: studentId)
        .where('status', isEqualTo: SessionMaterialData.statusActive)
        .where('visibility', whereIn: _studentVisibleMaterialStates)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(SessionMaterialData.fromDoc)
              .toList(growable: false),
        );
  }

  Stream<int> watchStudentMaterialCount(String studentId) {
    return watchStudentMaterials(studentId).map((items) => items.length);
  }

  Future<Uri> resolveOpenUri(SessionMaterialData material) async {
    if (material.hasStorageFile) {
      final url = await _storage.ref(material.storagePath).getDownloadURL();
      return Uri.parse(url);
    }

    if (material.hasDirectUrl) {
      return Uri.parse(material.downloadUrl);
    }

    throw const SessionMaterialException(
      'This material is missing an accessible file location.',
    );
  }
}

class SessionMaterialException implements Exception {
  final String message;

  const SessionMaterialException(this.message);

  @override
  String toString() => message;
}
