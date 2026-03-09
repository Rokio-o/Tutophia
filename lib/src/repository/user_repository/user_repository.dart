import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutophia/src/features/authentication/models/user_model.dart';
import 'package:flutter/material.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db
        .collection("Users")
        .add(user.toJson())
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
}
