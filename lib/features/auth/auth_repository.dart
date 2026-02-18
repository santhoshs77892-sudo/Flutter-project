import 'package:firebase_auth/firebase_auth.dart';

import '../../core/backend/backend_service.dart';

class AuthRepository {
  AuthRepository(this._backend);

  final BackendService _backend;

  Stream<User?> authStateChanges() => _backend.auth.authStateChanges();

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? forceResendingToken)
        onCodeSent,
    required void Function(FirebaseAuthException error) onVerificationFailed,
    required void Function(PhoneAuthCredential credential) onVerificationCompleted,
  }) async {
    await _backend.auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<UserCredential> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return _backend.auth.signInWithCredential(credential);
  }
}
