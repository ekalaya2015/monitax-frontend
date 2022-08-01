import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  final String strimage;
  final VoidCallback onPressed;

  // Constructor
  const DisplayImage({
    Key? key,
    required this.strimage,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Colors.blue;
    return buildImage(color, strimage);
  }

  // Builds Profile Image
  Widget buildImage(Color color, String strimage) {
    var image;
    if (strimage.isNotEmpty) {
      var savedir = io.Directory.systemTemp;
      debugPrint(savedir.path);
      String filePath = '${savedir.path}/profile.jpg';
      io.File file = io.File(filePath);
      final List<int> decodedBytes = base64Decode(strimage);
      file.writeAsBytesSync(decodedBytes, mode: io.FileMode.write, flush: true);
      image = FileImage(io.File(filePath));
    }

    return Center(
        child: (strimage.isEmpty)
            ? const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 70,
              )
            : CircleAvatar(
                backgroundImage: image as ImageProvider,
                radius: 70,
              ));
  }

  // Builds Edit Icon on Profile Picture
  Widget buildEditIcon(Color color) => buildCircle(
      all: 8,
      child: Icon(
        Icons.edit,
        color: color,
        size: 20,
      ));

  // Builds/Makes Circle for Edit Icon on Profile Picture
  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
          child: Container(
        padding: EdgeInsets.all(all),
        color: Colors.white,
        child: child,
      ));
}
