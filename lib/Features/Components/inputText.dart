// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Inputtext extends StatefulWidget {
  final IconData prefixIcon;
  final bool isPass;
  bool isObscureText;
  final TextEditingController controller;
  final String hintText;

  Inputtext(
      {super.key,
      required this.prefixIcon,
      required this.isObscureText,
      required this.isPass,
      required this.controller,
      required this.hintText});

  @override
  State<Inputtext> createState() => _InputtextState();
}

class _InputtextState extends State<Inputtext> {
  bool isVisibility = false;
  bool isTapTextFiled = false;

  void onPressed() {
    setState(() {
      isVisibility = !isVisibility;
      widget.isObscureText = !widget.isObscureText;
    });
  }

  void onTap() {
    setState(() {
      isTapTextFiled = true;
    });
  }

  void onTapOutside(event) {
    setState(() {
      isTapTextFiled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10.0),
      child: SizedBox(
        width: size.width > 600 ? size.width * 0.8 : size.width,
        child: TextField(
          onTapOutside: onTapOutside,
          onTap: onTap,
          controller: widget.controller,
          decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              suffixIcon: widget.isPass
                  ? IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        isVisibility ? Icons.visibility : Icons.visibility_off,
                        color: isTapTextFiled
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                      ))
                  : null,
              prefixIcon: Icon(widget.prefixIcon,
                  color: isTapTextFiled
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary),
              hintText: widget.hintText,
              fillColor: const Color.fromARGB(255, 17, 17, 17),
              filled: true),
          style: const TextStyle(fontSize: 20),
          obscureText: widget.isObscureText,
        ),
      ),
    );
  }
}
