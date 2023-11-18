import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _isVisible,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12)
        ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)
          ),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hint,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off))
      ),
      maxLines: 1,
    );
  }
}