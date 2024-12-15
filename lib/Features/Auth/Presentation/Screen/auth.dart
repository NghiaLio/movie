import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class authScreen extends StatefulWidget {
  
  final bool isLoginError;
  const authScreen({super.key, required this.isLoginError});

  @override
  State<authScreen> createState() => _authScreenState();
}

class _authScreenState extends State<authScreen> {

  bool isLoginScreen = true;

  void toggleScreen(){
    setState(() {
      isLoginScreen = !isLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isLoginScreen){
      return LoginScreen(
        pushToSignUpPage: toggleScreen,
        isError: widget.isLoginError,
      );
    }else{
      return registerScreen(
        backToLogin: toggleScreen,
      );
    }
  }
}