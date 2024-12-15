// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../Components/inputText.dart';

class Resetpass extends StatelessWidget {

  final TextEditingController controller;
  void Function()? onSend;
  Resetpass({super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Reset Password',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary
        ),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height*0.17,
        child: Column(
          children: [
            Text('Enter your email and we will send you reset password link',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18
              ),
            ),
            Inputtext(
              prefixIcon: Icons.email, 
              isObscureText: false, 
              isPass: false, 
              controller: controller, 
              hintText: 'email'
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onSend, 
          child:const Text('Send',
            style: TextStyle(
              fontSize: 24
            ),
          )
        )
      ],
    );
  }
}