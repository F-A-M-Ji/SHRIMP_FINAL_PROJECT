import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shrimp/camera/camera.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  String message = '';

  @override
  void initState() {
    super.initState();
    fetchHello();
  }

  Future<void> fetchHello() async {
    final response =
        await http.get(Uri.parse('http://192.168.109.197:1707/hello'));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        message = jsonResponse['message'];
      });
    } else {
      throw Exception('Failed to load hello');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Result',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.deepPurple[100],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: message == 'Normal'
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNormalCard(),
                    SizedBox(
                        height: 20), // ระยะห่างระหว่าง Card กับ ElevatedButton
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyCamera()),
                        );
                      },
                      child: Text('Finish'), // ข้อความบนปุ่ม
                    ),
                  ],
                )
              : message == 'Abnormal'
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAbnormalCard(),
                        SizedBox(
                            height:
                                20), // ระยะห่างระหว่าง Card กับ ElevatedButton
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyCamera()),
                            );
                          },
                          child: Text('Finish'), // ข้อความบนปุ่ม
                        ),
                      ],
                    )
                  : CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildNormalCard() {
    return Card(
      color: Colors.lightGreenAccent[100],
      child: SizedBox(
        width: 300,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child:
                  Icon(Icons.check_circle, size: 100, color: Colors.green[500]),
            ),
            Text(
              'Normal',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbnormalCard() {
    return Card(
      color: Colors.redAccent,
      child: SizedBox(
        width: 200,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Icon(Icons.error, size: 50, color: Colors.red),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Abnormal',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
