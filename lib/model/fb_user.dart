class FbUser {
  String? uid;
  String? image;
  String? username;
  String? email;
  String? password;
  String? nickname;


  FbUser.user(this.uid, this.image, this.username, this.email, this.password, this.nickname);
  FbUser();

  FbUser.fromJson(Map<String, dynamic> json) :
        uid = json['uid'],
        image  = json['image'],
        username = json['username'],
        email = json['email'],
        password = json['password'],
        nickname = json['nickname'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'image': image,
      'username': username,
      'email': email,
      'password': password,
      'nickname' : nickname,

    };
  }
}