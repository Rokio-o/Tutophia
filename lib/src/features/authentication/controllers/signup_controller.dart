import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutophia/src/repository/authentication_repository/authentication_repository.dart';
import 'package:tutophia/src/repository/user_repository/user_repository.dart';
import 'package:tutophia/src/features/authentication/models/user_model.dart';


class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  // TextField Controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final userName = TextEditingController();
  final phoneNo = TextEditingController();

  final userRepo = Get.put(UserRepository());


  
  void registerUser(String email, String password) {
    AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password);
  }

  void createUser(UserModel user) async {
    await userRepo.createUser(user);
  }
}