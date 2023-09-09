import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  // Our settings
  final dynamic controller;
  final String hintText;
  final bool obscureText;
  final bool emailText;

  const CustomTextfield({
    super.key,
    this.controller,
    required this.hintText,
    required this.obscureText,
    required this.emailText,
  });

  @override
  Widget build(BuildContext context) {
    if (emailText) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      );
    }
  }
}
