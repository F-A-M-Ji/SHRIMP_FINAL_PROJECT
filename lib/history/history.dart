// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shrimp/camera/camera.dart';
// import 'package:shrimp/home/home.dart';
// import 'package:shrimp/login.dart';
// import 'package:shrimp/profile/profile.dart';

// class MyHistory extends StatefulWidget {
//   const MyHistory({super.key});

//   @override
//   State<MyHistory> createState() => _MyHistoryState();
// }

// class _MyHistoryState extends State<MyHistory> {
//   final TextEditingController _searchController = TextEditingController();
//   void initState() {
//     //getClientStream();
//     _searchController.addListener(_onSearchChanged);
//     super.initState();
//   }

//   _onSearchChanged() {
//     print(_searchController.text);
//     searchResultList();
//   }

//   List _allResults = [];
//   List _resultList = [];

//   searchResultList() {
//     var showResults = [];
//     if (_searchController.text != "") {
//       for (var clientSnapShot in _allResults) {
//         var nameE = clientSnapShot["name"].toString().toLowerCase();
//         if (nameE.contains(_searchController.text.toLowerCase())) {
//           showResults.add(clientSnapShot);
//         }
//       }
//     } else {
//       showResults = List.from(_allResults);
//     }

//     setState(() {
//       _resultList = showResults;
//     });
//   }

//   getClientStream() async {
//     var data_a = await FirebaseFirestore.instance
//         .collection("USERS")
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection("DATA")
//         .orderBy("create_at", descending: true)
//         .get();

//     setState(() {
//       _allResults = data_a.docs;
//     });
//     searchResultList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'History',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 30,
//           ),
//         ),
//         backgroundColor: Colors.deepPurple[100],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             //_buildHeader(),
//             DrawerHeader(
//               child: Text('Drawer Header'),
//               decoration: BoxDecoration(
//                 color: Colors.deepPurple[100],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('Home'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MyHome()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.camera_alt),
//               title: Text('Camera'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MyCamera()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.history),
//               title: Text('History'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MyHistory()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('profile'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MyProfile()),
//                 );
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () {
//                 FirebaseAuth.instance.signOut();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MyLogin()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
//               child: Column(
//                 children: [
//                   CupertinoSearchTextField(
//                     controller: _searchController,
//                     //decoration: const InputDecoration(hintText: "Search"),
//                   ),
//                   const SizedBox(
//                     height: 20.0,
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection("USERS")
//                     .doc(FirebaseAuth.instance.currentUser!.uid)
//                     .collection("DATA")
//                     .orderBy("create_at", descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return ListView.builder(
//                         itemCount: _resultList.length,
//                         itemBuilder: (context, index) {
//                           return Card(
//                             child: ListTile(
//                               leading: Image.network(
//                                 _resultList[index]['image'],
//                               ),
//                               title: Text(
//                                 _resultList[index]['name'],
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                               subtitle: Text(_resultList[index]['result'],
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 18,
//                                   )),
//                               onTap: () {
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //     builder: (context) => MyDataShow(
//                                 //       documentId: document.id,
//                                 //       //             title: document['title'],
//                                 //       // description: document['description'],
//                                 //       Machine_Learning:
//                                 //           document['Machine_Learning'],
//                                 //       Weighing_Machine:
//                                 //           document['Weighing_Machine'],
//                                 //       image: document['image'],
//                                 //       name: document['name'],
//                                 //       result: document['result'],
//                                 //       uid_data: document['uid_data'],
//                                 //       weight_Result: document['weight_Result'],
//                                 //       Latitude: document['Latitude'],
//                                 //       Longitude: document['Longitude'],
//                                 //       longAddress: document['longAddress'],
//                                 //       shortAddress: document['shortAddress'],
//                                 //     ),
//                                 //   ),
//                                 // );
//                               },
//                             ),
//                           );
//                         });
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shrimp/camera/camera.dart';
// import 'package:shrimp/home/home.dart';
// import 'package:shrimp/login.dart';
// import 'package:shrimp/profile/profile.dart';

// class MyHistory extends StatefulWidget {
//   const MyHistory({Key? key}) : super(key: key);

//   @override
//   State<MyHistory> createState() => _MyHistoryState();
// }

// class _MyHistoryState extends State<MyHistory> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Map<String, dynamic>> _allResults = [];
//   List<Map<String, dynamic>> _resultList = [];

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//     getClientStream();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   _onSearchChanged() {
//     print(_searchController.text);
//     searchResultList();
//   }

//   searchResultList() {
//     var showResults = <Map<String, dynamic>>[];
//     if (_searchController.text != "") {
//       for (var clientSnapShot in _allResults) {
//         var nameE = clientSnapShot["name"].toString().toLowerCase();
//         if (nameE.contains(_searchController.text.toLowerCase())) {
//           showResults.add(clientSnapShot);
//         }
//       }
//     } else {
//       showResults = List.from(_allResults);
//     }

//     setState(() {
//       _resultList = showResults;
//     });
//   }

//   getClientStream() async {
//     var data_a = await FirebaseFirestore.instance
//         .collection("USERS")
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection("DATA")
//         .orderBy("create_at", descending: true)
//         .get();

//     setState(() {
//       _allResults = data_a.docs.map((doc) => doc.data()).toList();
//       _resultList = List.from(_allResults);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'History',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 30,
//           ),
//         ),
//         backgroundColor: Colors.deepPurple[100],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             //_buildHeader(),
//             DrawerHeader(
//               child: Text('Drawer Header'),
//               decoration: BoxDecoration(
//                 color: Colors.deepPurple[100],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('Home'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MyHome()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.camera_alt),
//               title: Text('Camera'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MyCamera()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.history),
//               title: Text('History'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MyHistory()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('profile'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MyProfile()),
//                 );
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () {
//                 FirebaseAuth.instance.signOut();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MyLogin()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           children: [
//             CupertinoSearchTextField(
//               controller: _searchController,
//               placeholder: "Search",
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _resultList.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       leading: Image.network(
//                         _resultList[index]['image'],
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                       ),
//                       title: Text(
//                         _resultList[index]['name'],
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 20,
//                         ),
//                       ),
//                       subtitle: Text(
//                         _resultList[index]['date'] ?? '',
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                         ),
//                       ),
//                       onTap: () {
//                         // Add onTap functionality if needed
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shrimp/camera/camera.dart';
import 'package:shrimp/history/history_two.dart';
import 'package:shrimp/home/home.dart';
import 'package:shrimp/login.dart';
import 'package:shrimp/profile/profile.dart';

class MyHistory extends StatefulWidget {
  const MyHistory({super.key});

  @override
  State<MyHistory> createState() => _MyHistoryState();
}

class _MyHistoryState extends State<MyHistory> {
  final TextEditingController _searchController = TextEditingController();
  List _allResults = [];
  List _resultList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    getClientStream();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var clientSnapShot in _allResults) {
        var nameE = clientSnapShot["name"].toString().toLowerCase();
        if (nameE.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultList = showResults;
    });
  }

  getClientStream() async {
    var dataA = await FirebaseFirestore.instance
        .collection("USERS")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("DATA")
        .orderBy("create_at", descending: true)
        .get();

    setState(() {
      _allResults = dataA.docs;
      _resultList = List.from(_allResults);
    });
    searchResultList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
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
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Column(
              children: [
                CupertinoSearchTextField(
                  controller: _searchController,
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("USERS")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("DATA")
                  .orderBy("create_at", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: _resultList.length,
                      itemBuilder: (context, index) {
                        final document = snapshot.data!.docs[index];
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                              _resultList[index]['image'],
                            ),
                            title: Text(
                              _resultList[index]['name'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(_resultList[index]['date'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHistoryData(
                                    documentId: document.id,
                                    // Machine_Learning:
                                    //     document['Machine_Learning'],
                                    // Weighing_Machine:
                                    //     document['Weighing_Machine'],
                                    image: document['image'],
                                    name: document['name'],
                                    // result: document['result'],
                                    uid_data: document['uid_data'],
                                    // weight_Result: document['weight_Result'],
                                    date: document['date'],
                                    Latitude: document['Latitude'],
                                    Longitude: document['Longitude'],
                                    longAddress: document['longAddress'],
                                    shortAddress: document['shortAddress'],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      });
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
