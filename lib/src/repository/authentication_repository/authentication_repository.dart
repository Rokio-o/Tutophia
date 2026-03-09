import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tutophia/SplashScreen.dart';
import 'package:tutophia/StudentAccess/dashboard-student.dart';
import 'package:tutophia/successful-reg.dart';
import 'exceptions/signup_email_password_failure.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  //variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady(){
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user){
    user == null ? Get.offAll(()=> SplashScreen()) : Get.offAll(()=> StudentDashboard());
  }

  void createUserWithEmailAndPassword(String email, String password) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(()=> SuccessfulRegistration()) : Get.offAll(()=> StudentDashboard());
    }on FirebaseAuthException catch(e){
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch(_){}
  }

  void loginWithEmailAndPassword(String email, String password) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(e){
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('EXCEPTION - ${ex.message}');
      throw ex;
    } catch(_){}
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}