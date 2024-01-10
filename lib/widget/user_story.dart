import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/model/fb_user.dart';

class UserStory extends StatelessWidget {
  const UserStory({super.key, required this.user, required this.onClick});
  final FbUser user;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          colors: [
            Color(0xFF11347a),
            Color(0xFFd52a92),
            Color(0xffe5571e),
          ],
        ),
        shape: BoxShape.circle
      ),
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(50),
        child: CircleAvatar(
          foregroundImage: NetworkImage(user?.image ?? ""),
        ),
      ),
    );
  }
}
