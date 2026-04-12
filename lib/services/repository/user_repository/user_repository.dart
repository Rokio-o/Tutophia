import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserRepository extends GetxController {
  static UserRepository get instance {
    if (Get.isRegistered<UserRepository>()) {
      return Get.find<UserRepository>();
    }
    return Get.put(UserRepository());
  }

  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  static const String _profileImagesRoot = 'profile_images';

  Map<String, dynamic> _sanitizeProfileData(Map<String, dynamic> profileData) {
    final sanitizedData = <String, dynamic>{...profileData};

    // Never persist raw credentials or local-only UI values in Firestore.
    sanitizedData.remove('password');
    sanitizedData.remove('confirmPassword');
    sanitizedData.remove('profileImageFile');

    sanitizedData.removeWhere((key, value) {
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      if (value is Iterable && value.isEmpty) return true;
      return false;
    });

    return sanitizedData;
  }

  String buildProfileImagePath(String uid) {
    return '$_profileImagesRoot/$uid/profile.jpg';
  }

  String _appendCacheBuster(String downloadUrl) {
    final separator = downloadUrl.contains('?') ? '&' : '?';
    return '$downloadUrl${separator}v=${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<Map<String, String>> uploadProfileImage({
    required String uid,
    required File imageFile,
  }) async {
    final path = buildProfileImagePath(uid);
    final ref = _storage.ref().child(path);

    await ref.putFile(imageFile);

    final downloadUrl = await ref.getDownloadURL();
    return <String, String>{
      'profileImagePath': path,
      'profileImageUrl': _appendCacheBuster(downloadUrl),
    };
  }

  Future<void> createUser({
    required String uid,
    required String email,
    required String role,
    required Map<String, dynamic> profileData,
    File? profileImageFile,
  }) async {
    final sanitizedData = <String, dynamic>{
      ..._sanitizeProfileData(profileData),
      'email': email,
      'accountType': role,
      'uid': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      if (profileImageFile != null) {
        sanitizedData.addAll(
          await uploadProfileImage(uid: uid, imageFile: profileImageFile),
        );
      }

      await _db
          .collection("Users")
          .doc(uid)
          .set(sanitizedData, SetOptions(merge: true));

      Get.snackbar(
        "Success",
        "Your account has been created!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    } catch (error) {
      final profileImagePath = sanitizedData['profileImagePath'];
      if (profileImagePath is String && profileImagePath.isNotEmpty) {
        try {
          await _storage.ref().child(profileImagePath).delete();
        } catch (_) {}
      }

      Get.snackbar(
        "Error",
        "Something went wrong. Try again!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      rethrow;
    }
  }

  Future<String?> getUserRole(String uid) async {
    final doc = await _db.collection("Users").doc(uid).get();
    if (!doc.exists) return null;

    final data = doc.data();
    final role = data?['accountType'];
    if (role is String && role.trim().isNotEmpty) {
      return role.trim().toLowerCase();
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.collection("Users").doc(uid).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> updates,
  }) async {
    final payload = <String, dynamic>{...updates};
    payload['updatedAt'] = FieldValue.serverTimestamp();
    payload.removeWhere((key, value) => value == null);
    await _db
        .collection("Users")
        .doc(uid)
        .set(payload, SetOptions(merge: true));
  }

  Future<Map<String, String>> updateProfileImage({
    required String uid,
    required File imageFile,
  }) async {
    final imageData = await uploadProfileImage(uid: uid, imageFile: imageFile);
    await updateUserProfile(uid: uid, updates: imageData);
    return imageData;
  }
}
