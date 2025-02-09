import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:shrimp/home/home.dart';
import 'package:shrimp/signup.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future _setDataUser() async {
    FirebaseFirestore.instance
        .collection("USERS")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "email": FirebaseAuth.instance.currentUser!.email,
      // "password": _password.text,
      "username": FirebaseAuth.instance.currentUser!.displayName,
      // "confirmpassword": _confirmpassword.text,
      "uid": FirebaseAuth.instance.currentUser!.uid,
      //"uid": user.uid,
      "user_image": FirebaseAuth.instance.currentUser!.photoURL,
    });
  }

  Future _signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print(userCredential.user?.displayName);
      return userCredential.user;
    }
    return null;
  }

  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  Future<void> _togglePasswordVisibility() async {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          //key: _formKey,
          child: OverflowBar(
            overflowSpacing: 20,
            children: [
              TextFormField(
                controller: _email,
                validator: (tText) {
                  if (tText == null || tText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email is empty')));
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black45,
                  ),
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: _password,
                validator: (tText) {
                  if (tText == null || tText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password is empty')));
                  }
                  return null;
                },
                obscureText: !_passwordVisible,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.black45,
                  ),
                  labelText: 'Password',
                  // suffixIcon: IconButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       _passwordVisible = !_passwordVisible;
                  //     });
                  //   },
                  //   icon: Icon(
                  //     _passwordVisible
                  //         ? Icons.visibility
                  //         : Icons.visibility_off,
                  //     color: Theme.of(context).primaryColorDark,
                  //   ),
                  // ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    if (_email.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please Enter Email')));
                    } else if (_password.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please Enter Password')));
                    } else {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _email.text, password: _password.text)
                          .then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHome()));
                      }).onError((error, stackTrace) {
                        print("ERROR ${error.toString()}");
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Has Something Wrong')));
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[100],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
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
                            builder: (context) => const MySignup()),
                      );
                    },
                    child: const Text(
                      "Signup",
                    ),
                  ),
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: ElevatedButton(
              //     style: ButtonStyle(backgroundColor:
              //         MaterialStateProperty.resolveWith((states) {
              //       if (states.contains(MaterialState.pressed)) {
              //         return Colors.black;
              //       }
              //       return Colors.greenAccent[100];
              //     })),
              //     onPressed: () async {
              //       final uUser = await _signInWithGoogle();
              //       if (uUser != null) {
              //         _setDataUser();
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (context) => const MyHome()),
              //         );
              //       }
              //     },
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         const Padding(
              //             padding: EdgeInsets.symmetric(vertical: 25)),
              //         Image.network(
              //           "https://assets.stickpng.com/images/5847f9cbcef1014c0b5e48c8.png",
              //           height: 35,
              //           width: 35,
              //         ),
              //         const SizedBox(
              //           width: 10,
              //         ),
              //         const Text(
              //           "Continue with Google",
              //           style: TextStyle(
              //               color: Colors.black,
              //               fontWeight: FontWeight.bold,
              //               fontSize: 15),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
