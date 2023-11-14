import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<UserCredential?> signUpWithEmail(BuildContext context,
      TextEditingController email, TextEditingController password) async {
    try {
      final firebase = FirebaseAuth.instance;
      final userCredentials = await firebase.createUserWithEmailAndPassword(
          email: email.text, password: password.text);

      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }

      return userCredentials;
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      return null;
    }
  }

  Future<UserCredential?> signInWithEmail(BuildContext context,
      TextEditingController email, TextEditingController password) async {
    try {
      final firebase = FirebaseAuth.instance;
      final userCredentials = await firebase.signInWithEmailAndPassword(
          email: email.text, password: password.text);

      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).pop();
      }

      return userCredentials;
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      return null;
    }
  }

  void forgotPassword(BuildContext context, TextEditingController email) async {
    try {
      final firebase = FirebaseAuth.instance;
      await firebase.sendPasswordResetEmail(email: email.text);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check your email for reset link.'),
        ),
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'An error occurred. Try again.'),
        ),
      );
    }
  }

  void signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome!'),
        ),
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void deleteAccount(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted successfully!'),
        ),
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'An unexpected error occurred.'),
        ),
      );
    }
  }
}
