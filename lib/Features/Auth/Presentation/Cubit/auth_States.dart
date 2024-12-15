// ignore_for_file: file_names

import '../../Domain/Entities/UserModel.dart';

abstract class AuthStates{}

//initial
class initial extends AuthStates{

}

//loading
class loading extends AuthStates{

}
//Authenticated
class Authenticated extends AuthStates{
  AppUser? user;
  Authenticated(this.user);
}
//UnAuthenticated
class UnAuthenticated extends AuthStates{

}
//Error
class Error extends AuthStates{
  String? message;
  Error(this.message);
}