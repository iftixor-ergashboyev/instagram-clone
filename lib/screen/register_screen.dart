import 'dart:io';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';



import '../manager/firebase_manager.dart';
import '../until/message.dart';
import '../widget/loading.dart';
import '../widget/my_button.dart';
import '../widget/my_field.dart';
import '../widget/password_field.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nickNameController = TextEditingController();

  bool _isLoading = false;

  XFile? _xFile;
  final _manager = FirebaseManager();

  void _register() {
    setState(() {
      _isLoading = true;
    });
    _manager.register(
        _nameController.text,
        _emailController.text,
        _nickNameController.text,
        _passwordController.text,
        File(_xFile?.path ?? "")
    ).then((value) {
      if(value == "Success") {
        showSuccessMessage(context, "Success");
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
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
            gradient: LinearGradient(
                colors: [
                  Color(0xffd91377),
                  Color(0xff157496),
                  Color(0xff1a2a94),
                ],
                begin: Alignment(0,0),
                end: Alignment(1,1)
            )
        ),
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
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10),

                  _xFile == null ? Container( /// mana 1
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white,width: 2)
                    ),
                    child: IconButton(onPressed: () async {
                      final picker = ImagePicker();
                      _xFile = await picker.pickImage(source: ImageSource.gallery);
                      setState(() {});
                    }, icon: const Icon(Icons.person,color: Colors.white)), /// mana 2
                  ) : CircleAvatar(
                    radius: 90, /// mana 3
                    foregroundImage: FileImage(File(_xFile?.path ?? "")),
                  ),
                  const SizedBox(height: 30,),
                  MyTextField(controller: _nameController, hint: 'Username'),
                  const SizedBox(height: 15,),
                  MyTextField(controller: _nickNameController, hint: 'Nickname'),
                  const SizedBox(height: 15,),
                  MyTextField(controller: _emailController, hint: 'Email'),
                  const SizedBox(height: 15),
                  MyPasswordField(controller: _passwordController, hint: 'Password'),
                  const SizedBox(height: 30),
                  _isLoading ? const Loading() : MyButton(
                    text: 'Register',
                    onClick: _register,
                  ),
                  const SizedBox(height: 30,),
                  GoogleAuthButton(
                    onPressed: () {

                    },
                  ),
                  const SizedBox(height: 30),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: TextButton(onPressed: (){
                        Navigator.of(context).pop();
                      },child: const Text("Already have an account? Sign In",style: TextStyle(color: Colors.white))))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
