

import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  const FullScreen({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        onHorizontalDragUpdate: (v) {
          Navigator.of(context).pop();
        },
        onVerticalDragUpdate: (v) {
          Navigator.of(context).pop();
        },
        child: Hero(
          tag: 'profile_image',
          child: FadeInImage(
            placeholder: const AssetImage('assets/img/img.png'),
            image: NetworkImage(image),
          ),
        ),
      ),
    );
  }
}