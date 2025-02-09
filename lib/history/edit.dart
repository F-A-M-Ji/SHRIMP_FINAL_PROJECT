import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyEdit extends StatefulWidget {
  final String uiddata;
  final String docId;
  final String namename;

  const MyEdit({
    Key? key,
    required this.uiddata,
    required this.docId,
    required this.namename,
  }) : super(key: key);

  @override
  State<MyEdit> createState() => _MyEditState();
}

class _MyEditState extends State<MyEdit> {
  late TextEditingController _nameController;
  late bool _isNormal;
  late bool _isAbnormal;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.namename);
    _fetchResult();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data"),
        backgroundColor: Colors.deepPurple[100],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 20.0,
            ),
            child: Card(
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Result: '),
                      SizedBox(width: 10),
                      Switch(
                        value: _isNormal,
                        onChanged: (value) {
                          setState(() {
                            _isNormal = value;
                            _isAbnormal = !value;
                          });
                        },
                      ),
                      Text('Normal'),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Result: '),
                      SizedBox(width: 10),
                      Switch(
                        value: _isAbnormal,
                        onChanged: (value) {
                          setState(() {
                            _isAbnormal = value;
                            _isNormal = !value;
                          });
                        },
                      ),
                      Text('Abnormal'),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      _saveData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _fetchResult() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('USERS')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("DATA")
          .doc(widget.uiddata)
          .get();
      setState(() {
        _isNormal = document['result'] == 'Normal';
        _isAbnormal = document['result'] == 'Abnormal';
      });
    } catch (error) {
      print("Failed to fetch result: $error");
    }
  }

  void _saveData() {
    String result = _isNormal ? 'Normal' : 'Abnormal';
    FirebaseFirestore.instance
        .collection('USERS')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("DATA")
        .doc(widget.uiddata)
        .update({
      'name': _nameController.text,
      'result': result,
    }).then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      print("Failed to update data: $error");
      // Handle the error
    });
  }
}
