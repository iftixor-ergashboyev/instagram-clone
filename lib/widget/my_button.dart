import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onClick, required this.text});
  final void Function() onClick;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox( height: 55, width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text, style: TextStyle(color: Colors.white),),
      ),
    );

  }
}