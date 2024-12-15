// ignore_for_file: must_be_immutable, use_build_context_synchronously

import '../Cubit/auth_States.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Components/inputText.dart';
import '../Cubit/authCubit.dart';
import 'resetPass.dart';

class LoginScreen extends StatefulWidget {
  void Function()? pushToSignUpPage;
  final bool isError;

  LoginScreen(
      {super.key, required this.pushToSignUpPage, required this.isError});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailToResetController = TextEditingController();

  bool isLoading = false;

  void login() async {
    final String email = emailController.text.trim();
    final String password = passController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty && password.length >= 6) {
      setState(() {
        isLoading = true;
      });
      await context.read<Authcubit>().login(email, password);
      Navigator.pop(context);
    } else if (password.length < 6 && email.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'Password length is more or equals 6 character',
        style: TextStyle(fontSize: 16),
      )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You must enter your email & password',
              style: TextStyle(fontSize: 16))));
    }
  }

  // click forgot button
  void forgotPassword() {
    showDialog(
        context: context,
        builder: (c) => Resetpass(
              controller: emailToResetController,
              onSend: onSend,
            ));
  }

  //click send email
  void onSend() async {
    try {
      await context
          .read<Authcubit>()
          .resetPass(emailToResetController.text.trim());
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) => const AlertDialog(
                content: Text('Password reset link sent! Check your email'),
              ));
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (c) => AlertDialog(
                content: Text(e.message.toString()),
              ));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<Authcubit, AuthStates>(
      listener: (context, state) {
        if (state is Error) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Tài khoản hoặc mật khẩu không đúng',
                  style: TextStyle(fontSize: 16))));
        }
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // back button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        !widget.isError
                            ? Navigator.pop(context)
                            : context.read<Authcubit>().backToHome();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width > 600
                            ? size.width * 0.04
                            : size.width * 0.1,
                        height: size.width > 600
                            ? size.width * 0.04
                            : size.width * 0.1,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            // color: Theme.of(context).colorScheme.primary,
                            border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0),
                              left: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0),
                              right: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0),
                              bottom: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Header Titlte
                  SizedBox(
                    height: size.height * 0.25,
                    child: Center(
                      child: Image.asset(
                        'assets/images/themovie.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //FieldLogin
                  Container(
                    width: size.width,
                    height: size.height * 0.65,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 8, 8, 8),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        // Title
                        Text(
                          'Welcom back!',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Enter your detail blow',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        // email fields
                        Inputtext(
                            prefixIcon: Icons.email,
                            isObscureText: false,
                            controller: emailController,
                            hintText: 'Email',
                            isPass: false),

                        // password fields
                        Inputtext(
                          prefixIcon: Icons.password,
                          isObscureText: true,
                          controller: passController,
                          hintText: 'Password',
                          isPass: true,
                        ),

                        // forgot password
                        Padding(
                          padding: size.width > 600
                              ? const EdgeInsets.only(right: 110)
                              : const EdgeInsets.all(0),
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: forgotPassword,
                              child: Text(
                                'Forgot your password?',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        // Button login
                        GestureDetector(
                          onTap: login,
                          child: Container(
                            height: size.height * 0.07,
                            width: size.width > 600
                                ? size.width * 0.4
                                : size.width * 0.87,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: !isLoading
                                ? Text(
                                    'Log In',
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        fontWeight: FontWeight.w600),
                                  )
                                : const CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 4.0,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        // if not have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '''Don't have an account?''',
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            GestureDetector(
                              onTap: widget.pushToSignUpPage,
                              child: Text(
                                ' Sign Up',
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
