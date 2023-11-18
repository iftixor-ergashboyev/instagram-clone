import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.color = Colors.white});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
         CupertinoActivityIndicator(color: color) :
         CircularProgressIndicator(color: color);
  }
}
