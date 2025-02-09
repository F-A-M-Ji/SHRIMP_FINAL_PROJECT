import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shrimp/camera/camera.dart';
import 'package:shrimp/history/history.dart';
import 'package:shrimp/login.dart';
import 'package:shrimp/profile/profile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int unsuccessCount = 0;
  int successCount = 0;

  //@override
  void initState() {
    super.initState();
    getDataFromFirestore();
  }

  Future<void> getDataFromFirestore() async {
    var firestore = FirebaseFirestore.instance;
    var collectionReference = firestore
        .collection('USERS')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("DATA");

    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      var fieldValue = document['result'];
      if (fieldValue == "Abnormal") {
        unsuccessCount++;
      } else if (fieldValue == "Normal") {
        successCount++;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
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
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 50.0,
        ),
        child: Container(
          width: 450, // Set the width of the container
          height: 480, // Set the height of the container
          child: Card(
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Pie Chart',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 250, // Set the width of the pie chart
                    height: 250, // Set the height of the pie chart
                    //child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //children: <Widget>[
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.red[300],
                            value: unsuccessCount.toDouble(),
                            //title: 'abnormal',
                            title: '$unsuccessCount',
                          ),
                          PieChartSectionData(
                            color: Colors.green[300],
                            value: successCount.toDouble(),
                            //title: 'normal',
                            title: '$successCount',
                          ),
                        ],
                        centerSpaceRadius: 60,
                        //centerSpaceColor: Colors.blue,
                        sectionsSpace: 1,
                      ),
                    ),
                    //],
                    //),
                  ),
                  SizedBox(height: 20.0),
                  // Container(
                  //   color: const Color(0xff0293ee),
                  //   width: 20,
                  //   height: 20,
                  // ),
                  // Text("abnormal: $unsuccessCount"),
                  // Text("normal: $successCount"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        //color: const Color(0xff0293ee),
                        color: Colors.red[400],
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 10),
                      Text('abnormal'),
                      SizedBox(width: 20),
                      Container(
                        //color: const Color(0xfff8b250),
                        color: Colors.green[400],
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 10),
                      Text('normal'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
