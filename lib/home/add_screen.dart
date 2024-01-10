import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../manager/firebase_manager.dart';
import '../model/post.dart';
import '../screen/main_screen.dart';
import '../until/message.dart';
import '../widget/loading.dart';


class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _picker = ImagePicker();
  XFile? _image;
  final _textController = TextEditingController();

  bool _isLoading = false;
  final _manager = FirebaseManager();

  void _uploadPost() {
    setState(() {
      _isLoading = true;
    });
    _manager.uploadPost(
        Post.post(null,
            _textController.text,
            _image?.path ?? "",
            null, 0, null, null, null, null
        )
    ).then((value) {
      setState(() {
        _isLoading = false;
      });
      showSuccessMessage(context, 'Post uploaded');
      Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Add Screen"),
        actions: [
          _isLoading ? Padding(
            padding: EdgeInsets.only(right: 16),
            child: const Loading(
              color: Colors.red,
            ),
          ) : CupertinoButton(
              child: const Icon(CupertinoIcons.add), onPressed: () {
            if(_image != null && _textController.text.isNotEmpty) {
              _uploadPost();
            } else {
              showErrorMessage(context, 'Enter data');
            }
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Add image to your post",style: TextStyle(
                  fontSize: 20
              )),
              const SizedBox(height: 20), /// 1
              InkWell(
                  onTap: () async {
                    _image = await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {});
                  },
                  child: _image == null
                      ? Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2)),
                    child: const Icon(CupertinoIcons.photo_camera),
                  )
                      : SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Image.file(File(_image?.path ?? ""),fit: BoxFit.cover,),
                  )
              ),
              const SizedBox(height: 30),///
              Text('Write text to your post',
                  style: GoogleFonts.roboto(fontSize: 20, color: Colors.black)),
              const SizedBox(height: 10),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Text',
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      const BorderSide(color: Colors.black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      const BorderSide(color: Colors.indigoAccent, width: 2)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      const BorderSide(color: Colors.black, width: 2)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}