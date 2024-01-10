import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loading.dart';

class MessageField extends StatefulWidget {
  const MessageField({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSendImage,
    required this.onSendMessage
  });
  final TextEditingController controller;
  final bool isLoading;
  final void Function() onSendMessage;
  final void Function() onSendImage;

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (v) {
        setState(() {

        });
      },
      decoration: InputDecoration(
          hintText: 'Xabar...',
          fillColor: Colors.white60,
          filled: true,
          contentPadding: const EdgeInsets.all(20),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 2,color: Colors.indigo)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 2,color: Colors.indigo)
          ),
          suffixIcon: widget.isLoading ? const Loading(color: Colors.indigoAccent,) : AnimatedOpacity(
            opacity: widget.controller.text.isNotEmpty ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: IconButton(
              onPressed: widget.onSendMessage,
              icon: const Icon(CupertinoIcons.paperplane),
            ),
          ),
          prefixIcon: IconButton(
            icon: const Icon(CupertinoIcons.photo),
            onPressed: widget.onSendImage,
          )
      ),
    );
  }
}