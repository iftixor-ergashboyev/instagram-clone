import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyField extends StatelessWidget {
  const MyField({super.key, required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        border: InputBorder.none,
        hintText: hint,
        fillColor: CupertinoColors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      maxLength: 1,
    );
  }
}