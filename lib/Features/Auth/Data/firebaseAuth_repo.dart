// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Domain/Entities/UserModel.dart';
import '../Domain/Repo/authRepo.dart';

class FirebaseauthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      AppUser userReturn =
          AppUser(userName: '', email: email, uid: userCredential.user!.uid);

      return userReturn;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      // sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create user
      AppUser userReturn =
          AppUser(userName: name, email: email, uid: userCredential.user!.uid);

      // save to firestore
      await firebaseFirestore
          .collection('User')
          .doc(userReturn.uid)
          .set(userReturn.toJson());

      return userReturn;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  @override
  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      // get firebase user logged
      final firebaseUser = firebaseAuth.currentUser;

      // no user
      if (firebaseUser == null) {
        return null;
      }

      // user exists
      return AppUser(
          userName: '', email: firebaseUser.email!, uid: firebaseUser.uid);
    } catch (e) {
      throw Exception('Fail: $e');
    }
  }
}
