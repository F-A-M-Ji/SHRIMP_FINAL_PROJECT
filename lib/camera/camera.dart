import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shrimp/camera/camera_two.dart';
import 'package:shrimp/camera/three.dart';
import 'package:shrimp/history/history.dart';
import 'package:shrimp/home/home.dart';
import 'package:shrimp/login.dart';
import 'package:shrimp/profile/profile.dart';

import 'package:image_picker/image_picker.dart';

class MyCamera extends StatefulWidget {
  const MyCamera({super.key});

  @override
  State<MyCamera> createState() => _MyCameraState();
}

class _MyCameraState extends State<MyCamera> {
  XFile? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camera',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.deepPurple[100],
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
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
            children: [
              InkWell(
                onTap: () {
                  _showAlertDialogALLSKING(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const ALLSKING()),
                  // );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepPurple.shade100,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.all(10.0)),
                      Image.asset(
                        "assets/images/ALLSKING.png",
                        //width: 170,
                        height: 100,
                        //fit: BoxFit.cover,
                      ),
                      Text(
                        "ALLSKING",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),

              ///////////////////////////////////////////////////
              InkWell(
                onTap: () {
                  _showAlertDialogWhite(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const Timecafe_White()),
                  // );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepPurple.shade100,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.all(10.0)),
                      Image.asset(
                        "assets/images/timecafe_white.jpg",
                        //'https://firebasestorage.googleapis.com/v0/b/sevenapp-66f82.appspot.com/o/images%2FA12.png?alt=media&token=058b6939-991f-4d05-8b64-3fd1ae08d3b3',
                        //width: 170,
                        height: 100,
                        //fit: BoxFit.cover,
                      ),
                      Text(
                        "Timecafe White",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _showAlertDialogBlack(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const Timecafe_Black()),
                  // );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepPurple.shade100,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.all(10.0)),
                      Image.asset(
                        "assets/images/timecafe_black.jpg",
                        //'https://firebasestorage.googleapis.com/v0/b/sevenapp-66f82.appspot.com/o/images%2FA13.png?alt=media&token=025afbcb-326b-425d-84bb-4ffb6099605d',
                        //width: 170,
                        height: 100,
                        //fit: BoxFit.cover,
                      ),
                      Text(
                        "Timecafe Black",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialogALLSKING(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ALLSKING"),
          content: ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ALLSKING()),
                  );
                  //Navigator.of(context).pop();
                },
                child: Text("Camera"),
              ),
              ElevatedButton(
                onPressed: () {
                  _getImageALLSKING();
                },
                child: Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getImageALLSKING() async {
    // name
    int name_scales = 2;
    // full cam
    double overlayX = 40.0;
    double overlayY = 128.0;
    double overlayWidth = 345.0;
    double overlayHeight = 518.0;
    //full cam sent
    double verlayX = 65.0;
    double verlayY = 155.0;
    double verlayWidth = 650.0;
    double verlayHeight = 1062.0;
    // num cam sent
    double layX = 243.0;
    double layY = 859.0;
    double layWidth = 475.0;
    double layHeight = 953.0;

    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
      //Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyPre(
            imageFile: image,
            name_scales: name_scales,
            overlayX: verlayX,
            overlayY: verlayY,
            overlayWidth: verlayWidth,
            overlayHeight: verlayHeight,
            layX: layX,
            layY: layY,
            layWidth: layWidth,
            layHeight: layHeight,
            // imageWidth: imageWidth, // ส่งค่า imageWidth ไปยัง MyPreview
            // imageHeight: imageHeight, // ส่งค่า imageHeight ไปยัง MyPreview
          ),
        ),
      );
    }
  }

  ////////////////////////////////////////////
  void _showAlertDialogWhite(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Timecafe White"),
          content: ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Timecafe_White()),
                  );
                  //Navigator.of(context).pop();
                },
                child: Text("Camera"),
              ),
              ElevatedButton(
                onPressed: () {
                  _getImageWhite();
                },
                child: Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getImageWhite() async {
    // name
    int name_scales = 1;

    // full cam
    double overlayX = 35.0;
    double overlayY = 85.0;
    double overlayWidth = 368.0;
    double overlayHeight = 517.0;
    //full cam sent
    double verlayX = 48.0;
    double verlayY = 72.0;
    double verlayWidth = 662.0;
    double verlayHeight = 947.0;
    // num cam sent
    double layX = 170.0;
    double layY = 782.0;
    double layWidth = 412.0;
    double layHeight = 885.0;

    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
      //Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyPre(
            imageFile: image,
            name_scales: name_scales,
            overlayX: verlayX,
            overlayY: verlayY,
            overlayWidth: verlayWidth,
            overlayHeight: verlayHeight,
            layX: layX,
            layY: layY,
            layWidth: layWidth,
            layHeight: layHeight,
            // imageWidth: imageWidth, // ส่งค่า imageWidth ไปยัง MyPreview
            // imageHeight: imageHeight, // ส่งค่า imageHeight ไปยัง MyPreview
          ),
        ),
      );
    }
  }

  ///////////////////////////////////////////
  void _showAlertDialogBlack(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Timecafe Black"),
          content: ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Timecafe_Black()),
                  );
                  //Navigator.of(context).pop();
                },
                child: Text("Camera"),
              ),
              ElevatedButton(
                onPressed: () {
                  _getImageBlack();
                },
                child: Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getImageBlack() async {
    // name
    int name_scales = 3;

    // full cam
    double overlayX = 15.0;
    double overlayY = 110.0;
    double overlayWidth = 413.0;
    double overlayHeight = 478.0;
    //full cam sent
    double verlayX = 35.0;
    double verlayY = 192.0;
    double verlayWidth = 704.0;
    double verlayHeight = 968.0;
    // num cam sent
    double layX = 446.0;
    double layY = 855.0;
    double layWidth = 622.0;
    double layHeight = 920.0;

    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
      //Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyPre(
            imageFile: image,
            name_scales: name_scales,
            overlayX: verlayX,
            overlayY: verlayY,
            overlayWidth: verlayWidth,
            overlayHeight: verlayHeight,
            layX: layX,
            layY: layY,
            layWidth: layWidth,
            layHeight: layHeight,
            // imageWidth: imageWidth, // ส่งค่า imageWidth ไปยัง MyPreview
            // imageHeight: imageHeight, // ส่งค่า imageHeight ไปยัง MyPreview
          ),
        ),
      );
    }
  }
}
