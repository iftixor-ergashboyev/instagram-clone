import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../model/message.dart';
import 'loading.dart';

class ReceiverMessage extends StatelessWidget {
  const ReceiverMessage({super.key, required this.message});
  final Message? message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
          color: Colors.indigoAccent, // Color for sender messages
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(16),
              topRight: Radius.circular(16)
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if(message?.type == 0)
              Text(message?.text ?? "",style: const TextStyle(fontSize: 18, color: Colors.white))
            else if (message?.type == 1)
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 100.0,
                  minWidth: 100.0,
                  maxHeight: 300.0,
                  maxWidth: 300.0,
                ),
                child: GestureDetector(
                  // onTap: onImageOpen,
                  child: CachedNetworkImage(
                    imageUrl: message?.image ?? "",
                    placeholder: (context, url) => const Loading(color: Colors.white),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const Gap(5),
            Text(message?.time ?? "",style: const TextStyle(fontSize: 12, color: Colors.white))
          ],
        ),
      ),
    );
  }
}