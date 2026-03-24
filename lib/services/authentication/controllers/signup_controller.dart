import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutophia/services/repository/authentication_repository/authentication_repository.dart';
import 'package:tutophia/services/repository/user_repository/user_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance {
    if (Get.isRegistered<SignUpController>()) {
      return Get.find<SignUpController>();
    }
    return Get.put(SignUpController());
  }

  //Textfield Controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final userName = TextEditingController();
  final phoneNo = TextEditingController();

  final userRepo = Get.put(UserRepository());

  Future<void> registerUser({
    required String email,
    required String password,
    required String role,
    required Map<String, dynamic> profileData,
  }) async {
    await AuthenticationRepository.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
      role: role,
      profileData: profileData,
    );
  }

  Future<void> createUser({
    required String uid,
    required String email,
    required String role,
    required Map<String, dynamic> profileData,
  }) async {
    await userRepo.createUser(
      uid: uid,
      email: email,
      role: role,
      profileData: profileData,
    );
  }
}
