// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Domain/Entities/UserModel.dart';
import '../../Domain/Repo/authRepo.dart';
import 'auth_States.dart';

class Authcubit extends Cubit<AuthStates> {
  AppUser? _currentUser;
  final AuthRepo authRepo;

  Authcubit({required this.authRepo}) : super(initial());

  // check if user logged
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

  //get currentUser
  AppUser? get currentUser => _currentUser;
  //login
  Future<AppUser?> login(String email, String password) async {
    try {
      emit(loading());
      final user = await authRepo.loginWithEmailPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(Error('message'));
    }
    return null;
  }

  //register
  Future<AppUser?> register(String name, String email, String password) async {
    try {
      emit(loading());
      final user =
          await authRepo.registerWithEmailPassword(name, email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Error('message'));
      }
    } catch (e) {
      emit(UnAuthenticated());
    }
    return null;
  }

  //logOut
  Future<void> logOut() async {
    await authRepo.logOut();
    emit(UnAuthenticated());
  }

  //back to home when login fail
  Future<void> backToHome() async {
    emit(UnAuthenticated());
  }

  //reset pass
  Future<void> resetPass(String email) async {
    return await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
