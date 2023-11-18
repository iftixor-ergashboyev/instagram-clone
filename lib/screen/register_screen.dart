import 'dart:io';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/manager/firebase_manager.dart';

import '../until/message.dart';
import '../widget/loading.dart';
import '../widget/my_button.dart';
import '../widget/my_field.dart';
import '../widget/password_field.dart';
import 'main_screen.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();

  bool _isLoading = false;

  XFile? _xFile;
  final _namager = FirebaseManager();

  void _register() {
    setState(() {
      _isLoading = true;
    });
    _namager.register(
      _nameController.text,
      _emailController.text,
      _nicknameController.text,
      _passwordController.text,
      File(_xFile?.path ?? "")
    ).then((value){
      if(value == "Success") {
        showSuccessMessage(context, "Success");
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        showErrorMessage(context, "Error");
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff294b93),
              Color(0xffff009a),
              Color(0xffff8048),
            ], begin: Alignment(0, 0), end: Alignment(1, 1))),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Instagram",
                    style: GoogleFonts.dancingScript(
                        fontSize: 45,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _xFile == null ? Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white,width: 2)
                    ),
                    child: IconButton(onPressed: () async {
                      final picker = ImagePicker();
                      _xFile = await picker.pickImage(source: ImageSource.gallery);
                      setState(() {

                      });
                    }, icon: const Icon(Icons.person,size: 100,color: Colors.white,)),
                  ) : CircleAvatar(
                    radius: 60,
                    foregroundImage: FileImage(File(_xFile?.path ?? "")),
                  ),

                  const SizedBox(height: 30,),
                  MyField(controller: _nameController, hint: 'Username'),
                  const SizedBox(height: 15,),
                  MyField(controller: _nicknameController, hint: 'Nickname'),
                  const SizedBox(height: 15),
                  MyField(controller: _emailController, hint: 'Email'),
                  const SizedBox(height: 15,),
                  PasswordField(controller: _passwordController, hint: 'Password'),
                  const SizedBox(height: 30,),
                  _isLoading ? const Loading() : MyBottom(
                    text: 'Register',
                    onClick: _register,
                  ),
                  const SizedBox(height: 30,),
                  GoogleAuthButton(
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Already have an account? Sing in",
                          style:
                          const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}