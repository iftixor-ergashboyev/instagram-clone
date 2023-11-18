// update

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/manager/firebase_manager.dart';
import 'package:instagram_clone/screen/login_screen.dart';
import 'package:instagram_clone/screen/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( InstagramApp());
}

class InstagramApp extends StatelessWidget {
   InstagramApp({super.key});

  final _manager = FirebaseManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF96234C))
      ),
      home: _manager.getUser() == null ? const LoginScreen() : const MainScreen(),
    );
  }
}
