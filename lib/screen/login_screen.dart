import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/screen/register_screen.dart';


import '../manager/firebase_manager.dart';
import '../until/message.dart';
import '../widget/loading.dart';
import '../widget/my_button.dart';
import '../widget/my_field.dart';
import '../widget/password_field.dart';
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
    setState(() {
      _isLoading = true;
    });
    _manager.login(
        _nameController.text,
        _passwordController.text
    ).then((value) {
      if(value == "Success") {
        showSuccessMessage(context, 'Success');
        Navigator.of(context)
            .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false);
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
            gradient: LinearGradient(
                colors: [
                  Color(0xff11347a),
                  Color(0xffd52a92),
                  Color(0xffe5571e),
                ],
                begin: Alignment(0,0),
                end: Alignment(1,1)
            )
        ),
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
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 30,),
                    MyTextField(controller: _nameController, hint: 'Username'),
                    const SizedBox(height: 15,),
                    MyPasswordField(controller: _passwordController, hint: 'Password'),
                    const SizedBox(height: 30,),
                    _isLoading ? const Loading() : MyButton(
                      text: 'Log in',
                      onClick: _login,
                    ),
                    const SizedBox(height: 30,),
                    GoogleAuthButton(
                      onPressed: () {

                      },
                    ),
                  ],
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: TextButton(onPressed: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context)=> const RegisterScreen()));
                    },child: const Text("Don't have an account? Sign Up",style: TextStyle(color: Colors.white))))

              ],
            ),
          ),
        ),
      ),
    );
  }
}