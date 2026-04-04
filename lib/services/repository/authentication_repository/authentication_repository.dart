import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tutophia/services/authentication/auth_registration_validator.dart';
import 'package:tutophia/services/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:tutophia/services/repository/user_repository/user_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance {
    if (Get.isRegistered<AuthenticationRepository>()) {
      return Get.find<AuthenticationRepository>();
    }
    return Get.put(AuthenticationRepository());
  }

  //variables
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String role,
    required Map<String, dynamic> profileData,
  }) async {
    final normalizedEmail = AuthRegistrationValidator.normalizeEmail(email);

    final emailValidationError =
        AuthRegistrationValidator.validateRegistrationEmail(normalizedEmail);
    if (emailValidationError != null) {
      throw SignUpWithEmailAndPasswordFailure(emailValidationError);
    }

    if (role.trim().toLowerCase() == 'student') {
      final studentAgeError = AuthRegistrationValidator.validateStudentAge(
        profileData['age'],
      );
      if (studentAgeError != null) {
        throw SignUpWithEmailAndPasswordFailure(studentAgeError);
      }
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const SignUpWithEmailAndPasswordFailure(
          'Account creation failed. Please try again.',
        );
      }

      await UserRepository.instance.createUser(
        uid: user.uid,
        email: normalizedEmail,
        role: role,
        profileData: profileData,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      debugPrint('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<UserCredential> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: AuthRegistrationValidator.normalizeEmail(email),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      debugPrint('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<void> sendEmailVerification({User? user}) async {
    try {
      final activeUser = user ?? _auth.currentUser;
      if (activeUser == null) {
        throw const SignUpWithEmailAndPasswordFailure(
          'No signed-in user found. Please log in again.',
        );
      }

      if (!activeUser.emailVerified) {
        await activeUser.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      debugPrint('EMAIL VERIFICATION ERROR - ${ex.message}');
      throw ex;
    }
  }

  Future<User?> reloadCurrentUser() async {
    final user = _auth.currentUser;
    await user?.reload();
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
