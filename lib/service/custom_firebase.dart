import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger/models/firebase_model.dart';
import 'package:messenger/service/custom_firestore.dart';
import 'package:messenger/service/custom_shared_prefs.dart';

class CustomFirebase with ChangeNotifier {
  static final auth = FirebaseAuth.instance;

  CustomFirebase._();
  static final instance = CustomFirebase._();

  static final _prefs = CustomSharedPrefs.instance;

  String _errorMess = '';
  String? get errorMess => _errorMess;
  // Create Account
  Future<User?> createAccountWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      await CustomFirestore.instance
          .credentialToFirestore(auth.currentUser!.uid, {
        'name': name,
        'email': email,
        'userId': auth.currentUser!.uid,
      });
      await user!.updateDisplayName(name);
      await _prefs.saveEmail(email);
      await _prefs.saveName(name);
      await _prefs.saveuid(auth.currentUser!.uid);
      return user;
    } on FirebaseAuthException catch (e) {
      _errorMess = e.message.toString();
    }
  }

  // Sign In
  Future<User?> signInAccountWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      _errorMess = e.message.toString();
    }
  }

  // sign out

  Future sigOut() async {
    try {
      return await auth.signOut();
    } on FirebaseAuthException catch (e) {
      _errorMess = e.message.toString();
    }
  }

  // fetching user data from firebase converting it to dart object
  FirebaseModel? _fetchDataFromFireBase(User? user) {
    return FirebaseModel(
      uid: user!.uid,
      name: user.displayName,
      email: user.email,
    );
  }

  Stream<FirebaseModel?> get userData {
    return auth.authStateChanges().map(_fetchDataFromFireBase);
  }
}
