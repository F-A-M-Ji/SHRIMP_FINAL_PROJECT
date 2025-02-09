import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:shrimp/home/home.dart';
import 'package:shrimp/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCEgKwNx--IT-G0ATDbGIEZSDgEh_G3Tfc',
              appId: '1:149725229078:android:a57495374a8b9b58074537',
              messagingSenderId: '149725229078',
              projectId: 'koko-a63dd',
              storageBucket: "koko-a63dd.appspot.com"))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return const MyHome();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            //return const CircularProgressIndicator();
          }
          return const MyLogin();
        },
      ),
    );
  }
}
