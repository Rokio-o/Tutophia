import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
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
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
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
        email: email,
        role: role,
        profileData: profileData,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<UserCredential> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
