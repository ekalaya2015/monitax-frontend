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
    return Center(
        child: (strimage.isEmpty)
            ? CircleAvatar(
                minRadius: 75,
                backgroundColor: Colors.grey,
                child: const CircleAvatar(
                    backgroundColor: Colors.blue, radius: 70))
            : CircleAvatar(
                minRadius: 75,
                backgroundColor: Colors.grey,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(strimage),
                ),
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
