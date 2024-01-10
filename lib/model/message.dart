class Message {
  String? messageId;
  String? senderId;
  String? receiverId;
  String? text;
  String? image;
  int? type;
  String? time;
  String? senderImage;

  Message(
      {required this.messageId,
        required this.senderId,
        required this.receiverId,
        required this.text,
        required this.image,
        required this.type,
        required this.time,
        required this.senderImage});

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'text': text,
      'image': image,
      'type': type,
      'time': time,
      'sender_image': senderImage,
    };
  }

  Message.fromJson(Map<Object?, Object?> json)
      : messageId = json['message_id'].toString(),
        senderId = json['sender_id'].toString(),
        receiverId = json['receiver_id'].toString(),
        text = json['text'].toString(),
        image = json['image'].toString(),
        type = int.tryParse(json['type'].toString()) ?? 0,
        time = json['time'].toString(),
        senderImage = json['sender_image'].toString();
}