import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:instagram_clone/model/post.dart';

class PostItem extends StatelessWidget {
  const PostItem({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
     width: double.infinity,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(12),
       color: Colors.white,
     ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              foregroundImage: NetworkImage(post.ownerProfileImage ?? ""),
            ),
            title: Text(post.ownerUserName ?? ""),
            trailing:  const Icon(Icons.more_horiz),
          ),
          const Gap(10),
          Image.network(post.image ?? "", width: double.infinity),
        const  Padding(
            padding:EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(CupertinoIcons.heart),
                const Gap(10),
                Icon(CupertinoIcons.chat_bubble),
                const Gap(10),
                Icon(CupertinoIcons.paperplane),
                Expanded(child: Align(alignment: AlignmentDirectional.centerEnd, child: Icon(CupertinoIcons.bookmark),))
              ],
            ),
          ),
          Text("\t\t${post.text}" ?? "")
        ],
      ),
    );
  }
}
