import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../manager/firebase_manager.dart';
import '../model/fb_user.dart';
import '../model/post.dart';
import '../screen/full_screen.dart';
import '../screen/login_screen.dart';
import '../until/message.dart';
import '../widget/loading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final _manager = FirebaseManager();

  void _logOut() {
    showCupertinoDialog(context: context, builder: (context) => CupertinoAlertDialog(
      title: const Text("Do you want to log out?"),
      content: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoButton(child: const Text("No!",
                style: TextStyle(color: Colors.blue),), onPressed: () {
                Navigator.of(context).pop();
              }),
              CupertinoButton(child: const Text("Yes",style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    _manager.logOut().then((value) {
                      Navigator.of(context)
                          .pushAndRemoveUntil(
                          CupertinoPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false);
                    });
                  }),
            ],
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _manager.getCurrentUser(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          final user = snapshot.data;
          return _buildProfile(user);
        } else if(snapshot.hasError){
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return const Center(child: Loading(color: Colors.red));
        }
      },
    );
  }
  Widget _buildProfile(FbUser? user) {
    return RefreshIndicator(
      displacement: MediaQuery.of(context).size.height / 6,
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(user?.username ?? "",style: GoogleFonts.roboto(
              fontSize: 22
          )),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.add_circled)),
            Badge.count(
              count: 4,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.list_bullet),
              ),
            ),
            IconButton(onPressed: _logOut, icon: const Icon(CupertinoIcons.power,color: Colors.red))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => FullScreen(image: user?.image ?? "")));
                        },
                        child: Hero(
                          tag: 'profile_image',
                          child: CircleAvatar(
                            radius: 40,
                            foregroundImage: NetworkImage(
                                user?.image ?? ""
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(user?.nickname ?? "")
                    ],
                  ),
                  _buildTwoText("${user?.postCount}",'posts'),
                  _buildTwoText('${user?.followerCount}','followers'),
                  _buildTwoText('${user?.followingCount}','following'),
                ],
              ),
              const SizedBox(height: 30),
              Expanded( /// 2
                  child: _buildMyPosts()
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTwoText(String title, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,style: GoogleFonts.roboto(fontSize: 18,color: Colors.black)),
        const SizedBox(height: 3),
        Text(label)
      ],
    );
  }

  Widget _buildMyPosts() { /// 1
    return FutureBuilder(
      future: _manager.getMyPosts(),
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {

          return GridView.builder(
            itemCount: snapshot.data?.length,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3 / 3
            ),
            itemBuilder: (context, index) {
              /// mashetga
              final post = snapshot.data?[index]; /// index deb
              return InkWell(
                onTap: () {
                  _openBottomSheet(post);
                },
                child: Image.network("${post?.image}",fit: BoxFit.cover),
              ); /// mana
            },
          );
        } else {
          return const Loading();
        }
      },
    );
  }
  void _openBottomSheet(Post? post) {
    showModalBottomSheet(context: context, builder: (context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.network(post?.image ?? "",width: double.infinity,height: 200,fit: BoxFit.cover,),
            const SizedBox(height: 20),
            Text(post?.text ?? "",style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 20),
            CupertinoButton(child:
            const Text("Delete Post",
                style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  _manager.deletePost(post).then((value) {
                    showSuccessMessage(context, 'Post deleted successfully');
                    Navigator.of(context).pop();
                  });
                }),
          ],
        ),
      ),
    ));
  }
}