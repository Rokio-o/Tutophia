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
      case 'user-not-found':
        return const SignUpWithEmailAndPasswordFailure('No account exists for this email.');
      case 'wrong-password':
        return const SignUpWithEmailAndPasswordFailure('The password you entered is incorrect.');
      case 'invalid-credential':
        return const SignUpWithEmailAndPasswordFailure('Invalid email or password. Please try again.');
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure('This operation is not allowed. Please contact support.');
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure('This user has been disabled. Please contact support for help.');
      case 'too-many-requests':
        return const SignUpWithEmailAndPasswordFailure('Too many login attempts. Please try again later.');
      case 'network-request-failed':
        return const SignUpWithEmailAndPasswordFailure('Network error. Please check your connection and try again.');
      default: 
        return SignUpWithEmailAndPasswordFailure();
    }
  }
}