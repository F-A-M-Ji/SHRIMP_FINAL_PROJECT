import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shrimp/camera/camera.dart';
import 'package:shrimp/camera/camera_four.dart';
import 'package:shrimp/camera/camera_two.dart';
import 'package:shrimp/history/history.dart';
import 'package:shrimp/home/home.dart';
import 'package:shrimp/login.dart';
import 'package:shrimp/profile/profile.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MyPre extends StatefulWidget {
  final int name_scales;
  final XFile imageFile;
  final double overlayX;
  final double overlayY;
  final double overlayWidth;
  final double overlayHeight;
  final double layX;
  final double layY;
  final double layWidth;
  final double layHeight;

  const MyPre({
    super.key,
    required this.name_scales,
    required this.imageFile,
    required this.overlayX,
    required this.overlayY,
    required this.overlayWidth,
    required this.overlayHeight,
    required this.layX,
    required this.layY,
    required this.layWidth,
    required this.layHeight,
  });

  @override
  State<MyPre> createState() => _MyPreState();
}

class _MyPreState extends State<MyPre> {
  final String _referenceID = FirebaseFirestore.instance
      .collection("USERS")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("DATA")
      .doc()
      .id;

  String nname = "Name Error";
  String ddate = "";

  double lati = 0.0;
  double longi = 0.0;

  String longAddress = "long address";
  String shortAddress = "short address";

  Future _setData(String imageUrl) async {
    try {
      FirebaseFirestore.instance
          .collection("USERS")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("DATA")
          .doc(_referenceID)
          .set({
        "name": nname,
        "image": imageUrl,
        "create_at": DateTime.now(),
        "date": ddate,
        "uid_data": _referenceID,
        "Latitude": lati,
        "Longitude": longi,
        "longAddress": longAddress,
        "shortAddress": shortAddress,
        //"OCR": ""
        //"PROCESS": ""
        "result": ""
      });
    } catch (e) {
      print('Error setting data: $e');
    }
  }

  // ประกาศฟังก์ชั่นสำหรับส่งไฟล์ไปยังเซิร์ฟเวอร์ FastAPI
  Future<void> _sendFilesToServer(
      String imagePath,
      double overlayX,
      double overlayY,
      double overlayWidth,
      double overlayHeight,
      double layX,
      double layY,
      double layWidth,
      double layHeight) async {
    try {
      // อ่านข้อมูลจากไฟล์ JSON
      Map<String, dynamic> jsonData = {
        'overlayX': overlayX,
        'overlayY': overlayY,
        'overlayWidth': overlayWidth,
        'overlayHeight': overlayHeight,
        'layX': layX,
        'layY': layY,
        'layWidth': layWidth,
        'layHeight': layHeight,
        'digital_scale': widget.name_scales,
      };

      // สร้างไฟล์ JSON
      String jsonDataString = jsonEncode(jsonData);
      List<int> jsonDataBytes = utf8.encode(jsonDataString);
      http.MultipartFile jsonDataFile = http.MultipartFile.fromBytes(
          'data', jsonDataBytes,
          filename: 'data.json');

      // สร้างไฟล์รูปภาพ
      File imageFile = File(imagePath);
      http.MultipartFile imageMultipartFile = http.MultipartFile.fromBytes(
          'image', await imageFile.readAsBytes(),
          filename: 'image.jpg');

      // สร้างคำขอ HTTP multipart
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.109.197:1707/upload/'))
        ..files.add(imageMultipartFile)
        ..files.add(jsonDataFile);

      // ส่งคำขอ HTTP multipart ไปยังเซิร์ฟเวอร์
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Files uploaded successfully');
      } else {
        print('Failed to upload files: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading files: $e');
    }
  }

  // GPS

  late String lat;
  late String long;
  //String locationMessage = "Not ready to click";
  String stAddress = "Name Address";

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Disabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("cannot request");
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
    //try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lati, longi);
    if (placemarks.isNotEmpty) {
      Placemark first = placemarks.first;
      setState(() {
        longAddress =
            "${first.name}, ${first.street}, ${first.subLocality}, ${first.subAdministrativeArea}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
        shortAddress = "${first.name}";
        ddate = DateFormat.yMd().format(DateTime.now());
        nname = shortAddress + "_" + ddate;
      });
      print(shortAddress);
      print(longAddress);
    } else {
      setState(() {
        shortAddress = "Address not found";
        longAddress = "Address not found";
      });
    }
  }

  // image to firebase
  Future<String> _uploadImageToStorage(File imageFile) async {
    //File imageFile = File(widget.imageFile.path);
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${DateTime.now()}.jpg');

      final metadata = SettableMetadata(contentType: "image/jpeg");

      await ref.putFile(imageFile, metadata);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //_buildHeader(),
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHome()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCamera()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHistory()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyProfile()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyLogin()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Image.file(
                File(widget.imageFile.path), // Show image
                //fit: BoxFit.cover,
                fit: BoxFit.fill,
                // width: widget.imageWidth / 2, // กำหนดความกว้างของรูปภาพ
                // height: widget.imageHeight / 2, // กำหนดความสูงของรูปภาพ
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  onPressed: () async {
                    //print(widget.imagePath);
                    _getCurrentLocation().then((value) {
                      lat = "${value.latitude}";
                      long = "${value.longitude}";

                      setState(() {
                        lati = value.latitude;
                        longi = value.longitude;
                      });
                      getAddressFromLatLng(lati, longi);
                    });

                    //String imageUrl = await _uploadImageToStorage();

                    if (lati != 0.0 && longi != 0.0) {
                      String imageUrl = await _uploadImageToStorage(
                          File(widget.imageFile.path));
                      await _setData(imageUrl);
                      await _sendFilesToServer(
                        widget.imageFile.path,
                        widget.overlayX,
                        widget.overlayY,
                        widget.overlayWidth,
                        widget.overlayHeight,
                        widget.layX,
                        widget.layY,
                        widget.layWidth,
                        widget.layHeight,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Result()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Unable to find location, Please click the button again.'),
                      ));
                    }
                  },
                  child: Text('Next'),
                ),
                SizedBox(width: 10), // ระยะห่างระหว่างปุ่ม
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyCamera()),
                    );
                  },
                  child: Text('Back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
