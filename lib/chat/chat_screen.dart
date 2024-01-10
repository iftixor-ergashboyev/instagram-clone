import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../manager/chat_manager.dart';
import '../manager/firebase_manager.dart';
import '../model/fb_user.dart';
import '../model/message.dart';
import '../widget/loading.dart';
import '../widget/message_field.dart';
import '../widget/receiver_message.dart';
import '../widget/sender_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.fbUser});
  final FbUser? fbUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _messageController = TextEditingController();
  bool _isLoading = false;
  final _chatManager = ChatManager();
  final _fManager = FirebaseManager();
  final _scrollController = ScrollController();
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              foregroundImage: NetworkImage(
                  widget.fbUser?.image ?? ""
              ),
            ),
            const Gap(20),
            Text(widget.fbUser?.username ?? ""),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _chatManager.getCurrentChatMessages(widget.fbUser?.uid),
                builder: (context, snapshot) {
                  if(snapshot.data != null && snapshot.data?.children.isNotEmpty == true) {
                    final List<Message> messageList = snapshot.data!.children.map((e) => Message.fromJson(e.value as Map<Object?, Object?>)).toList();
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        final message = messageList[index];
                        if(message.senderId == _fManager.getUser()?.uid) {
                          return SenderMessage(message: message, onMessageClicked: () {}, onImageOpen: () {});
                        } else {
                          return ReceiverMessage(message: message);
                        }
                      },
                    );
                  } else if (snapshot.data?.children.isEmpty == true) {
                    return const Center(child: Icon(CupertinoIcons.hand_thumbsup_fill),);
                  } else {
                    return const Loading();
                  }
                },
              ),
            ),
            MessageField( /// import
                controller: _messageController,
                isLoading: _isLoading,
                onSendMessage: _sendTextMessage, /// 1
                onSendImage: _launchImage///  2
            )
          ],
        ),
      ),
    );
  }

  void _launchImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null) {
      setState(() {
        _isLoading = true;
      });
      _chatManager.sendImageMessage(File(image.path), widget.fbUser?.uid).then((value) {
        setState(() {
          _isLoading = false;
          Future.delayed(const Duration(seconds: 1)).then((value) {
            _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
          });
        });
      });
    }
  }

  void _sendTextMessage() {
    setState(() {
      _isLoading = true;
    });
    _chatManager.sendTextMessage(_messageController.text, widget.fbUser?.uid).then((value) {
      setState(() {
        _isLoading = false;
        _messageController.text = '';
        Future.delayed(const Duration(seconds: 1)).then((value) {
          _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
        });
      });
    });
  }
}