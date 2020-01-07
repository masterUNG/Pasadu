import 'package:flutter/material.dart';

class MyStyle {
  // Field
  double h1 = 30.0, h2 = 18.0;
  Color textColor = Colors.orange.shade900;
  Color mainColor = Color.fromARGB(0xff, 0x39, 0xb6, 0xcc);

  String fontString = 'Mansalva';

  TextStyle h2TextStyle = TextStyle(
    fontSize: 20.0,
    color: Colors.orange.shade900,
    fontWeight: FontWeight.bold,
  );

  TextStyle h3TextStyle = TextStyle(
    fontSize: 18.0,
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  );

  TextStyle h4TextStyle = TextStyle(
    fontSize: 14.0,
    color: Colors.blue.shade900,
    // fontWeight: FontWeight.bold,
  );

  // Constructor
  MyStyle();
}
