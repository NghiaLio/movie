// ignore_for_file: file_names

import '../Entities/UserModel.dart';

abstract class AuthRepo{
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(String name,String email, String password);
  Future<void> logOut();
  Future<AppUser?> getCurrentUser();
}