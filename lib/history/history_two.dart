import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shrimp/camera/camera.dart';
import 'package:shrimp/history/edit.dart';
import 'package:shrimp/history/history.dart';
import 'package:shrimp/history/map.dart';
import 'package:shrimp/home/home.dart';
import 'package:shrimp/login.dart';
import 'package:shrimp/profile/profile.dart';

class MyHistoryData extends StatefulWidget {
  final String documentId;
  final String image;
  final String name;
  // final String result;
  final String uid_data;
  final String date;
  final double Latitude;
  final double Longitude;
  final String longAddress;
  final String shortAddress;

  const MyHistoryData(
      {super.key,
      required this.documentId,
      required this.image,
      required this.name,
      // required this.result,
      required this.uid_data,
      required this.date,
      required this.Latitude,
      required this.Longitude,
      required this.longAddress,
      required this.shortAddress});

  @override
  State<MyHistoryData> createState() => _MyHistoryDataState();
}

class _MyHistoryDataState extends State<MyHistoryData> {
  late String name = '';
  late String date = '';
  late String result = '';
  late String longAddress = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("USERS")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("DATA")
              .doc(widget.uid_data)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              name = data?['name'] ?? '';
              return Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              );
            } else {
              return Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              );
            }
          },
        ),
        backgroundColor: Colors.deepPurple[100],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("USERS")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("DATA")
              .doc(widget.uid_data)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final document = snapshot.data;
              name = document?['name'];
              date = document?['date'];
              result = document?['result'];
              longAddress = document?['longAddress'];

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: Card(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30.0,
                            ),
                            Container(
                              child: Image.network(
                                "${widget.image}",
                                height: 250,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              child: Text(
                                "name : $name",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              child: Text(
                                "date : $date",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              child: Text(
                                "result : $result",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              child: Text(
                                "address : $longAddress",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        late double Latitude = widget.Latitude;
                        late double Longitude = widget.Longitude;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyMap(
                              Latitude,
                              Longitude,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Map",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyEdit(
                              uiddata: widget.uid_data,
                              docId: widget.documentId,
                              namename: name,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        final docUser = FirebaseFirestore.instance
                            .collection('USERS')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("DATA")
                            .doc(widget.uid_data);
                        docUser.delete();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHistory(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
