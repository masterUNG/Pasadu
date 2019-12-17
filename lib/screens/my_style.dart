import 'package:flutter/material.dart';

class MyStyle {
  // Field
  double h1 = 30.0, h2 = 18.0;
  Color textColor = Color.fromARGB(255, 255, 124, 36);
  Color mainColor = Color.fromARGB(0xff, 0x39, 0xb6, 0xcc);

  String fontString = 'Mansalva';

  TextStyle h2TextStyle = TextStyle(
    fontSize: 20.0,
    color: Color.fromARGB(255, 255, 124, 36),
    fontWeight: FontWeight.bold,
  );

  TextStyle h3TextStyle = TextStyle(
    fontSize: 18.0,
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  );

  // Constructor
  MyStyle();
}
