class SignUpWithEmailAndPasswordFailure {
  final String message;

  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SignUpWithEmailAndPasswordFailure.code(String code){
    switch(code){
      case 'weak-password': 
        return const SignUpWithEmailAndPasswordFailure('The password is too weak.');
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure('The email address is invalid or badly formatted.');
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure('An account already exists for that email.');
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure('This operation is not allowed. Please contact support.');
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure('This user has been disabled. Please contact support for help.');
      default: 
        return SignUpWithEmailAndPasswordFailure();
    }
  }
}