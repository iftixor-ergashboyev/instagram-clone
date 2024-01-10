import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/message.dart';
import 'firebase_manager.dart';


class ChatManager {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance;
  final _storage = FirebaseStorage.instance;
  final _manager = FirebaseManager();

  Future<void> sendTextMessage(String text, String? receiverId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final messageId = _db.ref('chats').push().key;
    final senderId = _auth.currentUser?.uid;
    final senderRoomId = "$senderId$receiverId";
    final receiverRoomId = "$receiverId$senderId";
    final me = await _manager.getCurrentUser();
    final newMessage = Message(
        messageId: messageId,
        senderId: senderId,
        receiverId: receiverId,
        text: text,
        image: null,
        type: 0,
        time: getCurrentTime(),
        senderImage: me.image
    );
    await _db.ref('chats').child(senderRoomId).child('messages/$messageId').set(newMessage.toJson());
    await _db.ref('chats').child(receiverRoomId).child('messages/$messageId').set(newMessage.toJson());
  }
  String getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute}";
  }

  Stream<DataSnapshot> getCurrentChatMessages(String? receiverId) {
    final room = "${_auth.currentUser?.uid}$receiverId";
    return _db.ref('chats/$room/messages').get().asStream();
  }
  Future<void> sendImageMessage(File file, String? receiverId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final imageName = DateTime.now().microsecondsSinceEpoch.toString();
    final snapshot = await _storage.ref('chat_images').child(imageName).putFile(file);
    final imageUrl = await snapshot.ref.getDownloadURL();

    final messageId = _db.ref('chats').push().key;
    final senderId = _auth.currentUser?.uid;
    final senderRoomId = "$senderId$receiverId";
    final receiverRoomId = "$receiverId$senderId";
    final me = await _manager.getCurrentUser();
    final newMessage = Message(
        messageId: messageId,
        senderId: senderId,
        receiverId: receiverId,
        text: null,
        image: imageUrl,
        type: 1,
        time: getCurrentTime(),
        senderImage: me.image
    );
    await _db.ref('chats').child(senderRoomId).child('messages/$messageId').set(newMessage.toJson());
    await _db.ref('chats').child(receiverRoomId).child('messages/$messageId').set(newMessage.toJson());
    print('tugadi');
  }
}