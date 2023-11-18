import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/manager/firebase_manager.dart';
import 'package:instagram_clone/screen/register_screen.dart';
import 'package:instagram_clone/until/message.dart';

import '../widget/loading.dart';
import '../widget/my_button.dart';
import '../widget/my_field.dart';
import '../widget/password_field.dart';
import '../widget/password_fild.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _manager = FirebaseManager();
  bool _isLoading = false;

  void _login() {
    _manager.login(_nameController.text, _passwordController.text
    ).then((value) {
      if(value == "Success") {
        showSuccessMessage(context, "Success");
        Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
      } else {
        showErrorMessage(context, 'Error');
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
              Color(0xff11347a),
              Color(0xffd52a92),
              Color(0xffe5571e),
            ], begin: Alignment(0, 0), end: Alignment(1, 1))),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Stack(
              children: [
                Column(
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
                    const SizedBox(
                      height: 30,
                    ),
                    MyField(controller: _nameController, hint: 'Username'),
                    const SizedBox(
                      height: 15,
                    ),
                    PasswordField(
                        controller: _passwordController, hint: 'Password'),
                    const SizedBox(
                      height: 30,
                    ),
                     _isLoading ? const Loading() : MyBottom(
                      text: 'Log in',
                      onClick: () {},
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GoogleAuthButton(
                      onPressed: () {},
                    )
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Image.asset('assets/logo/google.png', height: 40,width: 40,),
                    //     const SizedBox(width: 10),
                    //     TextButton(onPressed: (){}, child: const Text('Login In with Google')),
                    //   ],
                    // )
                  ],
                ),
                Positioned(
                    bottom: 0,
                    left: 0,

                    right: 0,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => RegisterPage()));
                      },
                      child: const Text(
                        "Don't have an account?",
                        style:
                        const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}