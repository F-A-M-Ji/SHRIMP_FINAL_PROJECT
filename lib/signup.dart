import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';

import 'package:shrimp/login.dart';

class MySignup extends StatefulWidget {
  const MySignup({super.key});

  @override
  State<MySignup> createState() => _MySignupState();
}

class _MySignupState extends State<MySignup> {
  String imageUrl = '';
  File? _image;
  final picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFileGallery =
        await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFileGallery != null) {
        _image = File(pickedFileGallery.path);
      }
    });

    if (pickedFileGallery == null) return;

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    final metadata = SettableMetadata(contentType: "image/jpeg");

    try {
      await referenceImageToUpload.putFile(
          File(pickedFileGallery.path), metadata);
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFileCamera = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFileCamera != null) {
        _image = File(pickedFileCamera.path);
      }
    });

    if (pickedFileCamera == null) return;

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    final metadata = SettableMetadata(contentType: "image/jpeg");

    try {
      await referenceImageToUpload.putFile(
          File(pickedFileCamera.path), metadata);
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}
  }

  //Show options to get image from camera or gallery
  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();

  void _setDataUser() async {
    FirebaseFirestore.instance
        .collection("USERS")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "email": _email.text,
      "password": _password.text,
      "username": _username.text,
      "confirmpassword": _confirmpassword.text,
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "user_image": imageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          //key: _formKey,
          child: Center(
            //overflowSpacing: 20,
            child: Column(
              children: [
                const SizedBox(
                  height: 60.0,
                ),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightGreen, width: 7),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(200),
                        ),
                      ),
                      child: ClipOval(
                        child: _image != null
                            ? Image.file(
                                _image!,
                                width: 170,
                                height: 170,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/Person_icon_Graphics.jpg",
                              ),
                        // Image.network(
                        //     //'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg',
                        //     //'https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg?w=170&h=170',
                        //     'https://www.creativefabrica.com/wp-content/uploads/2022/10/25/Person-icon-Graphics-43204353-1-1-580x386.jpg',
                        //     width: 170,
                        //     height: 170,
                        //     fit: BoxFit.cover,
                        //   ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -10,
                      child: IconButton(
                        onPressed: () {
                          showOptions();
                        },
                        icon: const Icon(
                          Icons.add_a_photo_rounded,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  controller: _username,
                  //controller: _email,
                  validator: (tText) {
                    if (tText == null || tText.isEmpty) {
                      return 'Username is empty';
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text('Username is empty')));
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  controller: _email,
                  //controller: _email,
                  validator: (tText) {
                    if (tText == null || tText.isEmpty) {
                      return 'Email is empty';
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text('mail is empty')));
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  controller: _password,
                  //controller: _password,
                  validator: (tText) {
                    if (tText == null || tText.isEmpty) {
                      return 'Password is empty';
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text('Password is empty')));
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  controller: _confirmpassword,
                  //controller: _password,
                  validator: (tText) {
                    if (tText == null || tText.isEmpty) {
                      return 'Confirm password is empty';
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //     content: Text('Confirm password is empty')));
                    }
                    if (tText != _password.text) {
                      return 'Password is not match';
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //     content: Text('Password is not match')));
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_username.text == "" &&
                              _email.text == "" &&
                              _password.text == "" &&
                              _confirmpassword.text == ""
                          // && authService.confirmpassword ==authService.confirmpassword
                          ) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please Enter Information'),
                          ),
                        );
                      } else if (_password.text != _confirmpassword.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password is not match'),
                          ),
                        );
                      } else {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _email.text, password: _password.text)
                            .then((value) {
                          print("Created New Accound");
                          _setDataUser();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyLogin()));
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyLogin()),
                        );
                      },
                      child: const Text(
                        "Login",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      //bottomNavigationBar: const BottomNav(),
    );
  }
}
