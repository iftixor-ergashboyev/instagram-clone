import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/chat/chat_screen.dart';
import 'package:instagram_clone/manager/firebase_manager.dart';
import 'package:instagram_clone/widget/loading.dart';
import 'package:instagram_clone/widget/post_item.dart';

import '../widget/user_story.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _manager = FirebaseManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Instagram",
          style: GoogleFonts.dancingScript(fontSize: 34, color: Colors.black),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: SizedBox(
                height: 100,
                width: double.infinity,
                child: FutureBuilder(
                    future: _manager.getAllUsers(),
                    builder: (context, snapshot) {
                      if(snapshot.data != null && snapshot.data?.isNotEmpty == true) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            if(index == 0) {
                              return _buildBox(_manager.myImage);
                            } else {
                              return UserStory(user: snapshot.data![0], onClick: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(builder: (context) => ChatScreen(fbUser: snapshot.data?[0]))
                                );
                              });
                            }
                          },
                        );
                      } else {
                        return const  Loading();
                      }
                    }
                ))),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
          Badge.count(
            count: 2,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.chat_bubble_text),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: FutureBuilder(
        future: _manager.getMyPosts(),
        builder: (context, snapshot) {
          if(snapshot.data != null && snapshot.data?.isNotEmpty == true) {
            return ListView.separated(
              separatorBuilder: (context, index) => const Gap(10),
              itemCount: snapshot.data?.length ??0,
              itemBuilder: (context, index) {
                return PostItem(post: snapshot.data![index]);
              },
            );
          } else {
            return const Loading();
          }
        },
      ),
    );
  }

  Widget _buildBox(String imageUrl) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: 80,
              height: 80,
              decoration:  BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2)
              ),
              child: const Icon(CupertinoIcons.profile_circled),
              ),
            ),
          Positioned(
              right: 0,
              bottom: 10,
              child: Container(
                height: 24,
                width: 24,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue),
                child:
                const Icon(CupertinoIcons.add_circled, color: Colors.white),
              ))
        ],
      ),
    );
  }
}