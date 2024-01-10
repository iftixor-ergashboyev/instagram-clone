import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message),
      backgroundColor: Colors.redAccent));
}

void showSuccessMessage(BuildContext context, String message){
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message),
      backgroundColor: const Color(0xFF0D700F)));
}