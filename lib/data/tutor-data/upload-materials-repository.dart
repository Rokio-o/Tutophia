import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tutophia/models/student-model/booking_data.dart';
import 'package:tutophia/models/student-model/session-material_data.dart';
import 'package:tutophia/models/tutor-model/upload-materials-data.dart';

class UploadMaterialsRepository {
  UploadMaterialsRepository._();

  static final UploadMaterialsRepository instance =
      UploadMaterialsRepository._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get _materialsRef =>
      _firestore.collection(SessionMaterialData.collectionName);

  CollectionReference<Map<String, dynamic>> get _bookingsRef =>
      _firestore.collection('bookings');

  Future<List<MaterialRecipient>> fetchRecipientsForCurrentTutor() async {
    final tutorId = _auth.currentUser?.uid;
    if (tutorId == null) {
      return const [];
    }

    final snapshot = await _bookingsRef
        .where('tutorId', isEqualTo: tutorId)
        .where(
          'status',
          whereIn: [BookingData.statusApproved, BookingData.statusCompleted],
        )
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map(BookingData.fromDoc)
        .where((booking) => booking.studentId.isNotEmpty)
        .map(
          (booking) => MaterialRecipient(
            bookingId: booking.bookingId,
            studentId: booking.studentId,
            studentName: booking.studentName,
            subject: booking.subject,
            studentProgram: booking.studentProgram,
            sessionDateTime: booking.sessionDateTime,
          ),
        )
        .toList(growable: false);
  }

  Stream<List<SessionMaterialData>> watchTutorMaterials(String tutorId) {
    return _materialsRef
        .where('tutorId', isEqualTo: tutorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(SessionMaterialData.fromDoc)
              .toList(growable: false),
        );
  }

  Future<void> uploadMaterial(UploadMaterialData upload) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const SessionMaterialUploadException('Please login first.');
    }

    if (upload.title.trim().isEmpty) {
      throw const SessionMaterialUploadException('A title is required.');
    }

    if (upload.isLink && upload.externalUrl.trim().isEmpty) {
      throw const SessionMaterialUploadException(
        'Please paste a material link.',
      );
    }

    if (!upload.isLink &&
        (upload.fileBytes == null || upload.fileBytes!.isEmpty)) {
      throw const SessionMaterialUploadException(
        'Please choose a file to upload.',
      );
    }

    final tutorProfile = await _firestore
        .collection('Users')
        .doc(user.uid)
        .get();
    final tutorData = tutorProfile.data() ?? <String, dynamic>{};
    final tutorName = _displayNameFromProfile(tutorData, fallback: user.email);

    final materialRef = _materialsRef.doc();
    final contentType = upload.contentType.trim().isNotEmpty
        ? upload.contentType.trim()
        : _guessContentType(upload.fileName);
    final fileType = _resolveFileType(
      upload.fileName,
      contentType,
      upload.isLink,
    );

    var storagePath = '';
    var downloadUrl = upload.isLink ? upload.externalUrl.trim() : '';

    try {
      if (!upload.isLink) {
        final safeFileName = _sanitizeFileName(upload.fileName);
        storagePath =
            'session_materials/${user.uid}/${materialRef.id}/$safeFileName';

        await _storage
            .ref(storagePath)
            .putData(
              upload.fileBytes!,
              SettableMetadata(contentType: contentType),
            );
      }

      await materialRef.set({
        'materialId': materialRef.id,
        'tutorId': user.uid,
        'tutorName': tutorName,
        'studentId': upload.recipient.studentId,
        'studentName': upload.recipient.studentName,
        'bookingId': upload.recipient.bookingId,
        'subject': upload.recipient.subject,
        if (upload.recipient.sessionDateTime != null)
          'sessionDateTime': Timestamp.fromDate(
            upload.recipient.sessionDateTime!,
          ),
        'title': upload.title.trim(),
        'description': upload.description.trim(),
        'fileName': upload.fileName.trim(),
        'storagePath': storagePath,
        'downloadUrl': downloadUrl,
        'contentType': contentType,
        'fileType': fileType,
        'fileSizeBytes': upload.fileSizeBytes,
        'visibility': upload.recipient.bookingId.isNotEmpty
            ? SessionMaterialData.visibilityBookingParticipants
            : SessionMaterialData.visibilityStudentOnly,
        'status': SessionMaterialData.statusActive,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      if (storagePath.isNotEmpty) {
        try {
          await _storage.ref(storagePath).delete();
        } catch (_) {
          // Keep the original upload failure as the primary error.
        }
      }

      if (error is SessionMaterialUploadException) {
        rethrow;
      }

      throw SessionMaterialUploadException(
        'Upload failed. Please try again.',
        cause: error,
      );
    }
  }

  Future<void> archiveMaterial(String materialId) async {
    await _materialsRef.doc(materialId).update({
      'status': SessionMaterialData.statusArchived,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteMaterial(SessionMaterialData material) async {
    final docRef = _materialsRef.doc(material.materialId);
    var fileRemoved = false;

    if (material.storagePath.trim().isNotEmpty) {
      try {
        await _storage.ref(material.storagePath).delete();
        fileRemoved = true;
      } on FirebaseException catch (error) {
        if (error.code != 'object-not-found') {
          throw SessionMaterialDeleteException(
            'The file could not be removed from Cloud Storage.',
            cause: error,
          );
        }
      }
    }

    try {
      await docRef.delete();
    } catch (error) {
      if (fileRemoved) {
        throw SessionMaterialDeleteException(
          'The file was deleted from Cloud Storage, but the Firestore record could not be removed.',
          cause: error,
        );
      }

      throw SessionMaterialDeleteException(
        'The material could not be deleted.',
        cause: error,
      );
    }
  }

  String _displayNameFromProfile(
    Map<String, dynamic> data, {
    String? fallback,
  }) {
    final firstName = _asString(data['firstName']);
    final lastName = _asString(data['lastName']);
    final fullName = '$firstName $lastName'.trim();
    if (fullName.isNotEmpty) {
      return fullName;
    }

    final fallbackName = _asString(data['displayName']);
    if (fallbackName.isNotEmpty) {
      return fallbackName;
    }

    return fallback?.trim().isNotEmpty == true ? fallback!.trim() : 'Tutor';
  }

  String _sanitizeFileName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'material';
    }

    return trimmed.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  }

  String _guessContentType(String fileName) {
    switch (_extensionFrom(fileName)) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'txt':
        return 'text/plain';
      case 'zip':
        return 'application/zip';
      default:
        return 'application/octet-stream';
    }
  }

  String _resolveFileType(String fileName, String contentType, bool isLink) {
    if (isLink) {
      return 'link';
    }

    final extension = _extensionFrom(fileName);
    if (extension.isNotEmpty) {
      return extension;
    }

    final slashIndex = contentType.indexOf('/');
    if (slashIndex >= 0 && slashIndex < contentType.length - 1) {
      return contentType.substring(slashIndex + 1);
    }

    return 'file';
  }

  String _extensionFrom(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex < 0 || dotIndex == fileName.length - 1) {
      return '';
    }
    return fileName.substring(dotIndex + 1).toLowerCase();
  }

  String _asString(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }
}

class SessionMaterialUploadException implements Exception {
  final String message;
  final Object? cause;

  const SessionMaterialUploadException(this.message, {this.cause});

  @override
  String toString() => message;
}

class SessionMaterialDeleteException implements Exception {
  final String message;
  final Object? cause;

  const SessionMaterialDeleteException(this.message, {this.cause});

  @override
  String toString() => message;
}
