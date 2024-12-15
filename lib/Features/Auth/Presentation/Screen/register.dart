// ignore_for_file: camel_case_types

import 'package:app/Features/Auth/Presentation/Cubit/auth_States.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Components/inputText.dart';
import '../Cubit/authCubit.dart';

// ignore: duplicate_ignore
// ignore: camel_case_types, must_be_immutable
class registerScreen extends StatefulWidget {
  void Function()? backToLogin;
  registerScreen({super.key, required this.backToLogin});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool isLoading = false;

  void register() async {
    final String email = emailController.text.trim();
    final String password = passController.text.trim();
    final String name = nameController.text.trim();

    final bool checkMail = EmailValidator.validate(email);

    if (checkMail && password.length >= 6 && name.length >= 4) {
      setState(() {
        isLoading = true;
      });
      await context.read<Authcubit>().register(name, email, password);
      Navigator.pop(context);
    } else if (!checkMail && password.isNotEmpty && name.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Mail is not suitable', style: TextStyle(fontSize: 16))));
    } else if (name.length < 4 && checkMail && password.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Name is more or equals 4 character',
              style: TextStyle(fontSize: 16))));
    } else if (password.length < 6 && checkMail && name.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password length is more or equals 6 character',
              style: TextStyle(fontSize: 16))));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You must enter your information',
              style: TextStyle(fontSize: 16))));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<Authcubit, AuthStates>(
      listener: (context, state) {
        if (state is Error) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Email đã tồn tại', style: TextStyle(fontSize: 16))));
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
                    onTap: widget.backToLogin,
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
                  height: size.height * 0.15,
                  child: Center(
                    child: Image.asset(
                      'assets/images/themovie.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                //FieldLogin
                Container(
                  width: size.width,
                  height:
                      size.width > 600 ? size.height * 0.8 : size.height * 0.75,
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
                        'Get Started!',
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

                      //name fields
                      Inputtext(
                          prefixIcon: Icons.person,
                          isObscureText: false,
                          controller: nameController,
                          hintText: 'Username',
                          isPass: false),

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

                      const SizedBox(
                        height: 15,
                      ),

                      // Button Sign up
                      GestureDetector(
                        onTap: register,
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: !isLoading
                              ? Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      fontWeight: FontWeight.w600),
                                )
                              : const CircularProgressIndicator(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      //Continue with
                      Text(
                        'Or continue with',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: size.height * 0.07,
                              width: size.width > 600
                                  ? size.width * 0.2
                                  : size.width * 0.41,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                border: Border(
                                  top: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 1.0),
                                  left: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 1.0),
                                  right: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 1.0),
                                  bottom: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 1.0),
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/iconGG.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: size.height * 0.07,
                                width: size.width > 600
                                    ? size.width * 0.2
                                    : size.width * 0.41,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    border: Border(
                                      top: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 1.0),
                                      left: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 1.0),
                                      right: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 1.0),
                                      bottom: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 1.0),
                                    )),
                                child: Image.asset(
                                  'assets/images/appleIcon.png',
                                  fit: BoxFit.contain,
                                )),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // if have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '''Already have an account?''',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          GestureDetector(
                            onTap: widget.backToLogin,
                            child: Text(
                              ' Log In',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).colorScheme.primary),
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
      )),
    );
  }
}
