import 'dart:io';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/fb_user.dart';
import '../model/post.dart';

class FirebaseManager {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance;
  final _storage = FirebaseStorage.instance;

  String myImage = "";


  User? getUser() {
    return _auth.currentUser;
  }

  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Success';
    } on FirebaseAuthException catch(e) {
      return "Error";
    }
  }
  Future<String> register(
      String username,
      String email,
      String nickname, /// mana !!!
      String password,
      File image
      ) async {
    try {
      final fileName = DateTime.now().microsecondsSinceEpoch;
      final uploadTask = await _storage.ref('user_images/$fileName').putFile(image);
      final imageUri = await uploadTask.ref.getDownloadURL();
      final user =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final newUser = {
        'uid': user.user?.uid,
        'username': username,
        'email': email,
        'nickname': nickname, /// mana 2 !!!
        'password': password,
        'image': imageUri
      };
      final id = getUser()?.uid ?? _db.ref('users').push().key; /// mana
      await _db.ref('users/$id').set(newUser);
      return 'Success';
    } catch(e) {
      return 'Error';
    }
  }

  Future<FbUser> getCurrentUser() async {
    final id = getUser()?.uid ?? "";
    final snapshot = await _db.ref('users').child(id).get();
    final map = snapshot.value as Map<Object?, Object?>;

    final postList = await getMyPosts();

    final user = FbUser
        .user(map['uid'].toString(),
      map['image'].toString(),
      map['username'].toString(),
      map['email'].toString(),
      map['password'].toString(),
      map['nickname'].toString(),
      postList.length,
      int.tryParse(map['follower_count'].toString()) ?? 0,
      int.tryParse(map['following_count'].toString()) ?? 0,
    );

    myImage = user.image ?? "";
    return user;
  }
  Future<void> logOut() async {
    await _auth.signOut();
  }
  Future<void> uploadPost(Post post) async {
    final postId = _db.ref('posts').push().key;
    final currentTime = DateTime.now().toLocal().toString();
    final ownerId = getUser()?.uid;

    final imageName = _db.ref('posts').push().key.toString();
    final snapshot = await _storage.ref('post_images/$imageName').putFile(File(post.image ?? ""));
    final imageUrl = await snapshot.ref.getDownloadURL();

    final currentUser = await getCurrentUser();

    final newPost = {
      'id': postId,
      'owner_id': ownerId,
      'time': currentTime,
      'like_count': post.likeCount,
      'image': imageUrl,
      'text': post.text,
      'image_name': imageName,
      'owner_profile_image': currentUser.image,
      'owner_user_name': currentUser.username,
    };
    await _db.ref('posts/$postId').set(newPost);
  }

  Future<List<Post>> getMyPosts() async {
    final List<Post> myPostList = [];
    final snapshot = await _db.ref('posts').get();
    for(var map in snapshot.children) {
      final json = map.value as Map<Object?, Object?>;
      final post = Post.fromJson(json);
      if(post.ownerId == getUser()?.uid) {
        myPostList.add(post);
      }
    }
    return myPostList;
  }
  Future<void> deletePost(Post? post) async {
    await _storage.ref('post_images/${post?.imageName}').delete();
    await _db.ref('posts/${post?.id}').remove();
  }

  Future<List<FbUser>> getAllUsers() async {
    final snapshot = await _db.ref('users').get();
    final List<FbUser> userList = [];
    for(var map in snapshot.children) {
      final fbUser = FbUser.fromJson(map.value as Map<Object?, Object?>);
      userList.add(fbUser);
    }
    return userList;
  }
  Future<List<Post>> getAllPost() async {
    final snapshot = await _db.ref('posts').get();
    final List<Post> postList = [];
    for(var map in snapshot.children) {
      final post = Post.fromJson(map.value as Map<Object?, Object?>);
      postList.add(post);
    }
    return postList;
  }
}