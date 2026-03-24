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

  Future<void> createUser({
    required String uid,
    required String email,
    required String role,
    required Map<String, dynamic> profileData,
  }) async {
    final sanitizedData = <String, dynamic>{
      ...profileData,
      'email': email,
      'role': role,
      'uid': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Never persist raw credentials in Firestore.
    sanitizedData.remove('password');
    sanitizedData.remove('confirmPassword');

    sanitizedData.removeWhere((key, value) {
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      if (value is Iterable && value.isEmpty) return true;
      return false;
    });

    await _db
        .collection("Users")
        .doc(uid)
        .set(sanitizedData, SetOptions(merge: true))
        .whenComplete(
          () => Get.snackbar(
            "Success",
            "Your account has been created!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.greenAccent.withValues(alpha: 0.1),
            colorText: Colors.green,
          ),
        )
        .catchError((error, stackTrace) {
          Get.snackbar(
            "Error",
            "Something went wrong. Try again!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
            colorText: Colors.red,
          );
          print(error.toString());
        });
  }

  Future<String?> getUserRole(String uid) async {
    final doc = await _db.collection("Users").doc(uid).get();
    if (!doc.exists) return null;

    final data = doc.data();
    final role = data?['role'];
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
}
