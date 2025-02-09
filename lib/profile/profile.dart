import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shrimp/camera/camera.dart';
import 'package:shrimp/history/history.dart';
import 'package:shrimp/home/home.dart';
import 'package:shrimp/login.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Future<String> getImageUrl() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('USER')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final data = snapshot.data() as Map<String, dynamic>;
    return data['user_image'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profiles',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.deepPurple[100],
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       FirebaseAuth.instance.signOut();
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => const MyLogin()),
        //       );
        //     },
        //     icon: const Icon(Icons.login),
        //   ),
        // ],
      ),
      // drawer: FutureBuilder<DocumentSnapshot>(
      //   future: FirebaseFirestore.instance
      //       .collection('USER')
      //       .doc(FirebaseAuth.instance.currentUser!.uid)
      //       .get(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const CircularProgressIndicator();
      //     } else {
      //       if (snapshot.hasError) {
      //         return Text('Error: ${snapshot.error}');
      //       } else {
      //         String username = snapshot.data!.get('username');
      //         return Drawer(
      //           child: ListView(
      //             padding: EdgeInsets.zero,
      //             children: [
      //               DrawerHeader(
      //                 child: Text('I am , $username'),
      //                 decoration: BoxDecoration(
      //                   color: Colors.deepPurple[100],
      //                 ),
      //               ),
      //               ListTile(
      //                 leading: const Icon(Icons.home),
      //                 title: const Text('Home'),
      //                 onTap: () {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => const MyHome()),
      //                   );
      //                 },
      //               ),
      //               ListTile(
      //                 leading: const Icon(Icons.camera_alt),
      //                 title: const Text('Camera'),
      //                 onTap: () {
      //                   Navigator.pop(context);
      //                 },
      //               ),
      //               ListTile(
      //                 leading: const Icon(Icons.history),
      //                 title: const Text('History'),
      //                 onTap: () {
      //                   Navigator.pop(context);
      //                 },
      //               ),
      //               ListTile(
      //                 leading: const Icon(Icons.person),
      //                 title: const Text('profile'),
      //                 onTap: () {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => const MyProfile()),
      //                   );
      //                 },
      //               ),
      //               const Divider(),
      //               ListTile(
      //                 leading: const Icon(Icons.logout),
      //                 title: const Text('Logout'),
      //                 onTap: () {
      //                   FirebaseAuth.instance.signOut();
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => const MyLogin()),
      //                   );
      //                 },
      //               ),
      //             ],
      //           ),
      //         );
      //       }
      //     }
      //   },
      // ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(),
            // DrawerHeader(
            //   child: Text('Drawer Header'),
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //   ),
            // ),
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
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('USERS')
              .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    //Text(snapshot.data!.docs[index]['name']);
                    // return UserAccountsDrawerHeader(
                    //   accountName: Text(data['username']),
                    //   accountEmail: Text(data['email']),
                    // );
                    if (data['user_image'] != "") {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40.0,
                          horizontal: 50.0,
                        ),
                        child: Card(
                          child: Column(
                            children: [
                              //Image.network(data['username'])
                              const SizedBox(
                                height: 50.0,
                              ),
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.lightGreen, width: 7),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(200),
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        data['user_image'],
                                        //'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg',
                                        //'https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg?w=170&h=170',
                                        //'https://www.creativefabrica.com/wp-content/uploads/2022/10/25/Person-icon-Graphics-43204353-1-1-580x386.jpg',
                                        width: 170,
                                        height: 170,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              Text(
                                'Username : ' + data['username'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                ),
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              Text(
                                'Email : ' + data['email'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                ),
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40.0,
                          horizontal: 50.0,
                        ),
                        child: Card(
                          child: Column(
                            children: [
                              //Image.network(data['username'])
                              const SizedBox(
                                height: 50.0,
                              ),
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.lightGreen, width: 7),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(200),
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        //data['user_image'],
                                        //'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg',
                                        'https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg?w=170&h=170',
                                        //'https://www.creativefabrica.com/wp-content/uploads/2022/10/25/Person-icon-Graphics-43204353-1-1-580x386.jpg',
                                        width: 170,
                                        height: 170,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              Text(
                                'Username : ' + data['username'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                ),
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              Text(
                                'Email : ' + data['email'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                ),
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  });
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  _buildHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.deepPurple[100],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('USERS')
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      Text(
                        'I am ' + data['userame'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                        ),
                      );
                      return null;
                    });
              } else {
                return Container();
              }
            },
          ),
          const Text(
            'HARDCODE',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// Future getUser() async {
//   var data = await FirebaseFirestore.instance
//       .collection("USERS")
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .get();
// }
