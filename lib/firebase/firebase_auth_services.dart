import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:test_aja/widgets/toast_message.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(
            message: 'Email address is already use.',
            backgroundColor: const Color(0xFFB28781));
      } else {
        showToast(
            message: 'An error occurred: ${e.code}',
            backgroundColor: const Color(0xFFB28781));
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(
            message: 'Invalid email or password.',
            backgroundColor: const Color(0xFFB7857E));
      } else {
        showToast(
            message: 'An error occurred: ${e.code}',
            backgroundColor: const Color(0xFFB7857E));
      }
    }
    return null;
  }
}
