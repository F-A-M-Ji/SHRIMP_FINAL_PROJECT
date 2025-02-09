import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shrimp/camera/camera.dart';
import 'package:shrimp/camera/camera_three.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shrimp/history/history.dart';
import 'package:shrimp/home/home.dart';
import 'package:shrimp/login.dart';
import 'package:shrimp/profile/profile.dart';

class ALLSKING extends StatefulWidget {
  const ALLSKING({super.key});

  @override
  State<ALLSKING> createState() => _ALLSKINGState();
}

class _ALLSKINGState extends State<ALLSKING> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  double imageWidth = 0.0;
  double imageHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final rearCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _controller = CameraController(
      rearCamera,
      ResolutionPreset.max,
    );
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late double latitude;
  late double longitude;

  // Future<void> _getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     latitude = position.latitude;
  //     longitude = position.longitude;
  //   });
  // }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       throw Exception('Location services are disabled');
  //     }

  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         throw Exception('Location permissions are denied');
  //       }
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       throw Exception('Location permissions are permanently denied');
  //     }

  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     setState(() {
  //       latitude = position.latitude;
  //       longitude = position.longitude;
  //     });
  //   } catch (e) {
  //     print('Error getting current location: $e');
  //   }
  // }

  Future<void> _getCurrentLocation() async {
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
      return Future.error("Cannot request");
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // จัดการกับข้อมูลพิกัดที่ได้รับ
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ALLSKING',
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
      body: SingleChildScrollView(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              imageWidth = _controller.value.previewSize?.width ?? 0.0;
              imageHeight = _controller.value.previewSize?.height ?? 0.0;
              return Stack(
                children: [
                  // Container(
                  //   width: double.infinity, // Expand to full width
                  //   height: double.infinity, // Expand to full height
                  //   child: AspectRatio(
                  //     aspectRatio: _controller.value.aspectRatio,
                  //     child: CameraPreview(_controller),
                  //   ),
                  // ),
                  CameraPreview(_controller),
                  Positioned(
                    left: overlayX,
                    top: overlayY,
                    child: Container(
                      width: overlayWidth,
                      height: overlayHeight,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff7fff00), width: 5),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyCamera()),
              );
            },
            child: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () async {
              await _getCurrentLocation();
              try {
                final image = await _controller.takePicture();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPreview(
                      name_scales: name_scales,
                      imageFile: image,
                      overlayX: verlayX,
                      overlayY: verlayY,
                      overlayWidth: verlayWidth,
                      overlayHeight: verlayHeight,
                      layX: layX,
                      layY: layY,
                      layWidth: layWidth,
                      layHeight: layHeight,
                      imageWidth: imageWidth,
                      imageHeight: imageHeight,
                      latitude: latitude,
                      longitude: longitude,
                    ),
                  ),
                );
              } catch (e) {
                print(e);
              }
            },
            child: Icon(Icons.camera),
          ),
        ],
      ),
    );
  }
}

class Timecafe_White extends StatefulWidget {
  const Timecafe_White({super.key});

  @override
  State<Timecafe_White> createState() => _Timecafe_WhiteState();
}

class _Timecafe_WhiteState extends State<Timecafe_White> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  double imageWidth = 0.0;
  double imageHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final rearCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _controller = CameraController(
      rearCamera,
      ResolutionPreset.max,
    );
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late double latitude;
  late double longitude;

  Future<void> _getCurrentLocation() async {
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
      return Future.error("Cannot request");
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // จัดการกับข้อมูลพิกัดที่ได้รับ
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Timecafe White',
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
      body: SingleChildScrollView(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              imageWidth = _controller.value.previewSize?.width ?? 0.0;
              imageHeight = _controller.value.previewSize?.height ?? 0.0;
              return Stack(
                children: [
                  // Container(
                  //   width: double.infinity, // Expand to full width
                  //   height: double.infinity, // Expand to full height
                  //   child: AspectRatio(
                  //     aspectRatio: _controller.value.aspectRatio,
                  //     child: CameraPreview(_controller),
                  //   ),
                  // ),
                  CameraPreview(_controller),
                  Positioned(
                    left: overlayX,
                    top: overlayY,
                    child: Container(
                      width: overlayWidth,
                      height: overlayHeight,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff7fff00), width: 5),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyCamera()),
              );
            },
            child: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () async {
              await _getCurrentLocation();
              try {
                final image = await _controller.takePicture();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPreview(
                      name_scales: name_scales,
                      imageFile: image,
                      overlayX: verlayX,
                      overlayY: verlayY,
                      overlayWidth: verlayWidth,
                      overlayHeight: verlayHeight,
                      layX: layX,
                      layY: layY,
                      layWidth: layWidth,
                      layHeight: layHeight,
                      imageWidth: imageWidth,
                      imageHeight: imageHeight,
                      latitude: latitude,
                      longitude: longitude,
                    ),
                  ),
                );
              } catch (e) {
                print(e);
              }
            },
            child: Icon(Icons.camera),
          ),
        ],
      ),
    );
  }
}

class Timecafe_Black extends StatefulWidget {
  const Timecafe_Black({super.key});

  @override
  State<Timecafe_Black> createState() => _Timecafe_BlackState();
}

class _Timecafe_BlackState extends State<Timecafe_Black> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  double imageWidth = 0.0;
  double imageHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final rearCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _controller = CameraController(
      rearCamera,
      ResolutionPreset.max,
    );
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

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
  double layX = 448.0;
  double layY = 858.0;
  double layWidth = 623.0;
  double layHeight = 917.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late double latitude;
  late double longitude;

  Future<void> _getCurrentLocation() async {
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
      return Future.error("Cannot request");
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // จัดการกับข้อมูลพิกัดที่ได้รับ
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Timecafe Black',
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
      body: SingleChildScrollView(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              imageWidth = _controller.value.previewSize?.width ?? 0.0;
              imageHeight = _controller.value.previewSize?.height ?? 0.0;
              return Stack(
                children: [
                  // Container(
                  //   width: double.infinity, // Expand to full width
                  //   height: double.infinity, // Expand to full height
                  //   child: AspectRatio(
                  //     aspectRatio: _controller.value.aspectRatio,
                  //     child: CameraPreview(_controller),
                  //   ),
                  // ),
                  CameraPreview(_controller),
                  Positioned(
                    left: overlayX,
                    top: overlayY,
                    child: Container(
                      width: overlayWidth,
                      height: overlayHeight,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff7fff00), width: 5),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyCamera()),
              );
            },
            child: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () async {
              await _getCurrentLocation();
              try {
                final image = await _controller.takePicture();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPreview(
                      name_scales: name_scales,
                      imageFile: image,
                      overlayX: verlayX,
                      overlayY: verlayY,
                      overlayWidth: verlayWidth,
                      overlayHeight: verlayHeight,
                      layX: layX,
                      layY: layY,
                      layWidth: layWidth,
                      layHeight: layHeight,
                      imageWidth: imageWidth,
                      imageHeight: imageHeight,
                      latitude: latitude,
                      longitude: longitude,
                    ),
                  ),
                );
              } catch (e) {
                print(e);
              }
            },
            child: Icon(Icons.camera),
          ),
        ],
      ),
    );
  }
}
///////////////////////////////////////////////////////
// class ALLSKING extends StatefulWidget {
//   const ALLSKING({super.key});

//   @override
//   State<ALLSKING> createState() => _ALLSKINGState();
// }

// class _ALLSKINGState extends State<ALLSKING> {
//   File? _image;
//   final picker = ImagePicker();

//   Future getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Take a Picture'),
//       ),
//       body: Center(
//         child:
//             _image == null ? Text('No image selected.') : Image.file(_image!),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           getImage();
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => MyPreview()),
//           );
//         },
//         tooltip: 'Take Picture',
//         child: Icon(Icons.camera_alt),
//       ),
//     );
//   }
// }
////////////////////////////////////////////////////
///
// class ALLSKING extends StatefulWidget {
//   const ALLSKING({super.key});

//   @override
//   State<ALLSKING> createState() => _ALLSKINGState();
// }

// class _ALLSKINGState extends State<ALLSKING> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;

//   double overlayX = 50.0;
//   double overlayY = 100.0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ALLSKING'),
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Stack(
//               children: [
//                 CameraPreview(_controller),
//                 Positioned(
//                   left: overlayX,
//                   top: overlayY,
//                   child: Container(
//                     width: 200,
//                     height: 400,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white, width: 5),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           try {
//             final image = await _controller.takePicture();
//             XFile imageFile = await _controller.takePicture();
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MyPreview(
//                   imagePath: image.path,
//                 ),
//               ),
//             );
//           } catch (e) {
//             print(e);
//           }
//         },
//         child: Icon(Icons.camera),
//       ),
//     );
//   }
// }
