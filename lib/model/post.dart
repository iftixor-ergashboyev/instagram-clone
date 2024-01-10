class Post {
  String? id;
  String? time;
  String? ownerId;
  int likeCount = 0;
  String? image;
  String? text;
  String? imageName;

  String? ownerProfileImage;
  String? ownerUserName;

  Post();
  Post.post(this.id,this.text,this.image,
      this.time,this.likeCount,this.ownerId, this.imageName, this.ownerProfileImage, this.ownerUserName);

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'image': image, 'time': time,
      'like_count': likeCount, 'owner_id': ownerId, 'image_name': imageName, 'owner_profile_image': ownerProfileImage, 'owner_user_name': ownerUserName};
  }
  Post.fromJson(Map<Object?, Object?> json) :
        id = json['id'].toString(),
        time = json['time'].toString(),
        ownerId = json['owner_id'].toString(),
        likeCount = int.tryParse(json['like_count'].toString()) ?? 0,
        image = json['image'].toString(),
        text = json['text'].toString(),
        imageName = json['image_name'].toString(),
  ownerProfileImage = json['owner_profile_image'].toString(),
  ownerUserName = json['owner_user_name'].toString();
}