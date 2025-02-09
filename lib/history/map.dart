import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatefulWidget {
  final double Longitude;
  final double Latitude;
  // final String LlongAddress;
  // final String DdocumentId;
  // final String SshortAddress;
  MyMap(
    this.Latitude,
    this.Longitude,
  );

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.green[300],
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     // await FirebaseAuth.instance.signOut();
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) => const MyLogin()),
          //     // );
          //   },
          //   icon: const Icon(Icons.login),
          // ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.Latitude, widget.Longitude),
          zoom: 15.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: {
          Marker(
            markerId: MarkerId('location'),
            position: LatLng(widget.Latitude, widget.Longitude),
            infoWindow: InfoWindow(title: 'Location Marker'),
          ),
        },
      ),
    );
  }
}
