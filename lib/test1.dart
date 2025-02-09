import 'dart:io';

import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  final String imagePath;

  const ImagePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Image'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
