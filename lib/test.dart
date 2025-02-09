// // // import 'dart:io';

// // // import 'package:flutter/material.dart';
// // // import 'package:camera/camera.dart';
// // // import 'package:firebase_core/firebase_core.dart';
// // // import 'package:firebase_storage/firebase_storage.dart';

// // // List<CameraDescription> cameras = [];

// // // void main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   await Firebase.initializeApp(
// // //       options: FirebaseOptions(
// // //           apiKey: "AIzaSyCEgKwNx--IT-G0ATDbGIEZSDgEh_G3Tfc",
// // //           appId: "1:149725229078:android:a57495374a8b9b58074537",
// // //           messagingSenderId: "149725229078",
// // //           projectId: "koko-a63dd",
// // //           storageBucket: "koko-a63dd.appspot.com"));

// // //   // Platform.isAndroid
// // //   //     ? await Firebase.initializeApp(
// // //   //         options: const FirebaseOptions(
// // //   //             apiKey: 'AIzaSyCEgKwNx--IT-G0ATDbGIEZSDgEh_G3Tfc',
// // //   //             appId: '1:149725229078:android:a57495374a8b9b58074537',
// // //   //             messagingSenderId: '149725229078',
// // //   //             projectId: 'koko-a63dd'))
// // //   //     : await Firebase.initializeApp();
// // //   cameras = await availableCameras();
// // //   runApp(MyApp());
// // // }

// // // class MyApp extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'Card Scanner',
// // //       theme: ThemeData(
// // //         primarySwatch: Colors.blue,
// // //       ),
// // //       home: CameraScreen(),
// // //     );
// // //   }
// // // }

// // // class CameraScreen extends StatefulWidget {
// // //   @override
// // //   _CameraScreenState createState() => _CameraScreenState();
// // // }

// // // class _CameraScreenState extends State<CameraScreen> {
// // //   late CameraController _controller;
// // //   late Future<void> _initializeControllerFuture;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _controller = CameraController(
// // //       cameras[0],
// // //       ResolutionPreset.medium,
// // //     );
// // //     _initializeControllerFuture = _controller.initialize();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text('Take a Picture')),
// // //       body: FutureBuilder<void>(
// // //         future: _initializeControllerFuture,
// // //         builder: (context, snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.done) {
// // //             return Stack(
// // //               children: <Widget>[
// // //                 CameraPreview(_controller),
// // //                 Center(
// // //                   child: Container(
// // //                     width: 200,
// // //                     height: 150,
// // //                     decoration: BoxDecoration(
// // //                       border: Border.all(
// // //                         color: Colors.red,
// // //                         width: 3,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             );
// // //           } else {
// // //             return Center(child: CircularProgressIndicator());
// // //           }
// // //         },
// // //       ),
// // //       floatingActionButton: FloatingActionButton(
// // //         child: Icon(Icons.camera),
// // //         onPressed: () async {
// // //           try {
// // //             await _initializeControllerFuture;
// // //             final image = await _controller.takePicture();
// // //             Navigator.push(
// // //               context,
// // //               MaterialPageRoute(
// // //                 builder: (context) =>
// // //                     DisplayPictureScreen(imagePath: image.path),
// // //               ),
// // //             );
// // //           } catch (e) {
// // //             print(e);
// // //           }
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _controller.dispose();
// // //     super.dispose();
// // //   }
// // // }

// // // class DisplayPictureScreen extends StatelessWidget {
// // //   final String imagePath;

// // //   const DisplayPictureScreen({Key? key, required this.imagePath})
// // //       : super(key: key);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text('Display the Picture')),
// // //       body: Image.file(File(imagePath)),
// // //       floatingActionButton: FloatingActionButton(
// // //         onPressed: () async {
// // //           await uploadImageToFirebase(imagePath);
// // //         },
// // //         tooltip: 'Save Image',
// // //         child: Icon(Icons.save),
// // //       ),
// // //     );
// // //   }

// // //   Future<void> uploadImageToFirebase(String imagePath) async {
// // //     try {
// // //       Reference ref =
// // //           FirebaseStorage.instance.ref().child("images").child("card.jpg");
// // //       UploadTask uploadTask = ref.putFile(File(imagePath));
// // //       await uploadTask.whenComplete(() => print("Image Uploaded"));
// // //     } catch (e) {
// // //       print(e);
// // //     }
// // //   }
// // // }

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:shrimp/camera/camera.dart';
// // import 'package:shrimp/home/home.dart';
// // import 'package:shrimp/login.dart';
// // import 'package:shrimp/profile/profile.dart';

// // class MyHistory extends StatefulWidget {
// //   const MyHistory({super.key});

// //   @override
// //   State<MyHistory> createState() => _MyHistoryState();
// // }

// // class _MyHistoryState extends State<MyHistory> {
// //   final TextEditingController _searchController = TextEditingController();
// //   void initState() {
// //     //getClientStream();
// //     _searchController.addListener(_onSearchChanged);
// //     super.initState();
// //   }

// //   _onSearchChanged() {
// //     print(_searchController.text);
// //     searchResultList();
// //   }

// //   List _allResults = [];
// //   List _resultList = [];

// //   searchResultList() {
// //     var showResults = [];
// //     if (_searchController.text != "") {
// //       for (var clientSnapShot in _allResults) {
// //         var nameE = clientSnapShot["name"].toString().toLowerCase();
// //         if (nameE.contains(_searchController.text.toLowerCase())) {
// //           showResults.add(clientSnapShot);
// //         }
// //       }
// //     } else {
// //       showResults = List.from(_allResults);
// //     }

// //     setState(() {
// //       _resultList = showResults;
// //     });
// //   }

// //   getClientStream() async {
// //     var data_a = await FirebaseFirestore.instance
// //         .collection("USERS")
// //         .doc(FirebaseAuth.instance.currentUser!.uid)
// //         .collection("DATA")
// //         .orderBy("create_at", descending: true)
// //         .get();

// //     setState(() {
// //       _allResults = data_a.docs;
// //     });
// //     searchResultList();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'History',
// //           style: TextStyle(
// //             color: Colors.black,
// //             fontSize: 30,
// //           ),
// //         ),
// //         backgroundColor: Colors.deepPurple[100],
// //       ),
// //       drawer: Drawer(
// //         child: ListView(
// //           padding: EdgeInsets.zero,
// //           children: [
// //             //_buildHeader(),
// //             DrawerHeader(
// //               child: Text('Drawer Header'),
// //               decoration: BoxDecoration(
// //                 color: Colors.deepPurple[100],
// //               ),
// //             ),
// //             ListTile(
// //               leading: Icon(Icons.home),
// //               title: Text('Home'),
// //               onTap: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => const MyHome()),
// //                 );
// //               },
// //             ),
// //             ListTile(
// //               leading: Icon(Icons.camera_alt),
// //               title: Text('Camera'),
// //               onTap: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => const MyCamera()),
// //                 );
// //               },
// //             ),
// //             ListTile(
// //               leading: Icon(Icons.history),
// //               title: Text('History'),
// //               onTap: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => const MyHistory()),
// //                 );
// //               },
// //             ),
// //             ListTile(
// //               leading: Icon(Icons.person),
// //               title: Text('profile'),
// //               onTap: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => const MyProfile()),
// //                 );
// //               },
// //             ),
// //             Divider(),
// //             ListTile(
// //               leading: Icon(Icons.logout),
// //               title: Text('Logout'),
// //               onTap: () {
// //                 FirebaseAuth.instance.signOut();
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => const MyLogin()),
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: Container(
// //         child: Column(
// //           children: [
// //             Padding(
// //               padding:
// //                   const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
// //               child: Column(
// //                 children: [
// //                   CupertinoSearchTextField(
// //                     controller: _searchController,
// //                   ),
// //                   const SizedBox(
// //                     height: 20.0,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Expanded(
// //               child: StreamBuilder(
// //                 stream: FirebaseFirestore.instance
// //                     .collection("USERS")
// //                     .doc(FirebaseAuth.instance.currentUser!.uid)
// //                     .collection("DATA")
// //                     .orderBy("create_at", descending: true)
// //                     .snapshots(),
// //                 builder: (context, snapshot) {
// //                   if (snapshot.hasData) {
// //                     return ListView.builder(
// //                         itemCount: _resultList.length,
// //                         itemBuilder: (context, index) {
// //                           return Card(
// //                             child: ListTile(
// //                               leading: Image.network(
// //                                 _resultList[index]['image'],
// //                               ),
// //                               title: Text(
// //                                 _resultList[index]['name'],
// //                                 style: const TextStyle(
// //                                   color: Colors.black,
// //                                   fontSize: 20,
// //                                 ),
// //                               ),
// //                               subtitle: Text(_resultList[index]['result'],
// //                                   style: const TextStyle(
// //                                     color: Colors.black,
// //                                     fontSize: 18,
// //                                   )),
// //                               onTap: () {
// //                                 Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (context) => MyDataShow(
// //                                       documentId: document.id,
// //                                       //             title: document['title'],
// //                                       // description: document['description'],
// //                                       Machine_Learning:
// //                                           document['Machine_Learning'],
// //                                       Weighing_Machine:
// //                                           document['Weighing_Machine'],
// //                                       image: document['image'],
// //                                       name: document['name'],
// //                                       result: document['result'],
// //                                       uid_data: document['uid_data'],
// //                                       weight_Result: document['weight_Result'],
// //                                       Latitude: document['Latitude'],
// //                                       Longitude: document['Longitude'],
// //                                       longAddress: document['longAddress'],
// //                                       shortAddress: document['shortAddress'],
// //                                     ),
// //                                   ),
// //                                 );
// //                               },
// //                             ),
// //                           );
// //                         });
// //                   } else {
// //                     return Container();
// //                   }
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Image with Frame at Custom Coordinates'),
//         ),
//         body: Center(
//           child: ImageOverlay(
//             imageUrl:
//                 'https://firebasestorage.googleapis.com/v0/b/koko-a63dd.appspot.com/o/images%2F20240212_171806%20(1).jpg?alt=media&token=d5a280b0-ae28-4959-b346-470b5e216820', //black
//             //'https://firebasestorage.googleapis.com/v0/b/koko-a63dd.appspot.com/o/images%2F20240212_163715(2)%20(1).jpg?alt=media&token=0fc7a493-5128-49d0-8251-0f61de787591', //white
//             //'https://firebasestorage.googleapis.com/v0/b/koko-a63dd.appspot.com/o/images%2F20240212_165613%20(2)%20(1).jpg?alt=media&token=54412cfe-feef-4676-bd37-4e8a83634d3e', //pink

//             //white 1
//             // overlayX: 35.0, // Adjust X coordinate as needed
//             // overlayY: 85.0, // Adjust Y coordinate as needed
//             // overlayWidth: 368.0, // Adjust width of the white square frame
//             // overlayHeight: 517.0, // Adjust height of the white square frame

//             //ALLKING 2
//             // overlayX: 40.0, // Adjust X coordinate as needed
//             // overlayY: 128.0, // Adjust Y coordinate as needed
//             // overlayWidth: 345.0, // Adjust width of the white square frame
//             // overlayHeight: 518.0, // Adjust height of the white square frame

//             //black 3
//             overlayX: 15.0, // Adjust X coordinate as needed
//             overlayY: 110.0, // Adjust Y coordinate as needed
//             overlayWidth: 413.0, // Adjust width of the white square frame
//             overlayHeight: 478.0, // Adjust height of the white square frame
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ImageOverlay extends StatelessWidget {
//   final String imageUrl;
//   final double overlayX;
//   final double overlayY;
//   final double overlayWidth;
//   final double overlayHeight;

//   const ImageOverlay({
//     required this.imageUrl,
//     required this.overlayX,
//     required this.overlayY,
//     required this.overlayWidth,
//     required this.overlayHeight,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: precacheImage(NetworkImage(imageUrl), context),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator(); // Loading indicator
//         }
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}'); // Error handling
//         }
//         return Stack(
//           children: [
//             Image.network(
//               imageUrl,
//               fit: BoxFit.cover,
//             ),
//             Positioned(
//               left: overlayX,
//               top: overlayY,
//               child: Container(
//                 width: overlayWidth,
//                 height: overlayHeight,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Color(0xfff21a1d), width: 5),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class MapPage extends StatefulWidget {
// //   @override
// //   _MapPageState createState() => _MapPageState();
// // }

// // class _MapPageState extends State<MapPage> {
// //   late GoogleMapController _controller;
// //   Set<Marker> _markers = {};

// //   Future<void> _fetchMarkers() async {
// //     final userId = FirebaseAuth.instance.currentUser!.uid;
// //     // final dataRef = FirebaseFirestore.instance
// //     //     .collection("USERS")
// //     //     .doc(userId)
// //     //     .collection("DATA")
// //     //     .get();

// //     final dataRef = await FirebaseFirestore.instance
// //         .collection("USERS")
// //         .doc(FirebaseAuth.instance.currentUser!.uid)
// //         .collection("DATA")
// //         .get();
// //     //final dataSnapshot = await dataRef.get();

// //     for (final dataDoc in dataRef.docs) {
// //       final latitude = dataDoc.data()['Latitude'] as double?;
// //       final longitude = dataDoc.data()['Longitude'] as double?;

// //       if (latitude != null && longitude != null) {
// //         final marker = Marker(
// //           markerId: MarkerId(dataDoc.id),
// //           position: LatLng(latitude, longitude),
// //           infoWindow: InfoWindow(title: 'Marker'),
// //         );

// //         setState(() {
// //           _markers.add(marker);
// //         });
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Main"),
// //       ),
// //       body: GoogleMap(
// //         initialCameraPosition: CameraPosition(
// //           target: LatLng(0, 0),
// //           zoom: 2,
// //         ),
// //         onMapCreated: (GoogleMapController controller) {
// //           _controller = controller;
// //           _fetchMarkers();
// //         },
// //         markers: _markers,
// //       ),
// //     );
// //   }
// // }

// // void main() {
// //   runApp(MaterialApp(
// //     home: MapPage(),
// //   ));
// // }

// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// // class MainMapPage extends StatefulWidget {
// //   @override
// //   _MainMapPageState createState() => _MainMapPageState();
// // }

// // class _MainMapPageState extends State<MainMapPage> {
// //   late GoogleMapController _mapController;
// //   Set<Marker> _markers = {};

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Main"),
// //       ),
// //       body: GoogleMap(
// //         initialCameraPosition: CameraPosition(
// //           target: LatLng(0, 0),
// //           zoom: 2,
// //         ),
// //         onMapCreated: _onMapCreated,
// //         markers: _markers,
// //       ),
// //     );
// //   }

// //   void _onMapCreated(GoogleMapController controller) {
// //     _mapController = controller;
// //     _fetchMarkers();
// //   }

// //   Future<void> _fetchMarkers() async {
// //     final userId = FirebaseAuth.instance.currentUser!.uid;
// //     final userDoc = FirebaseFirestore.instance.collection('USERS').doc(userId);
// //     final dataSnapshot = await userDoc.collection('data').get();

// //     print("Document data: ${dataSnapshot.docs}");

// //     dataSnapshot.docs.forEach((dataDoc) {
// //       final latitude = dataDoc.data()['Latitude'] as double?;
// //       final longitude = dataDoc.data()['Longitude'] as double?;

// //       print("Latitude: $latitude, Longitude: $longitude");

// //       if (latitude != null && longitude != null) {
// //         final marker = Marker(
// //           markerId: MarkerId(dataDoc.id),
// //           position: LatLng(latitude, longitude),
// //           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
// //         );

// //         setState(() {
// //           _markers.add(marker);
// //         });
// //       }
// //     });
// //   }
// // }

// // void main() {
// //   runApp(MaterialApp(
// //     home: MainMapPage(),
// //   ));
// // }

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shrimp/test1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyCamera(),
    );
  }
}

class MyCamera extends StatefulWidget {
  const MyCamera({Key? key}) : super(key: key);

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
      body: InkWell(
        onTap: () {
          _showAlertDialog(context);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green.shade100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(10.0)),
              Image.asset(
                "assets/images/ALLSKING.png",
                width: 170,
                height: 100,
              ),
              Text(
                "ALLSKING",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an option"),
          content: ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Do something when Button 1 is pressed
                  Navigator.of(context).pop();
                },
                child: Text("Button 1"),
              ),
              ElevatedButton(
                onPressed: () {
                  _getImage();
                },
                child: Text("Button 2"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getImage() async {
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
          builder: (context) => ImagePage(imagePath: _image!.path),
        ),
      );
    }
  }
}
