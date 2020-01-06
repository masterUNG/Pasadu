import 'package:flutter/material.dart';
import 'package:pasadu/screens/my_style.dart';

Widget showTitle(String title) {
  return ListTile(
    leading: Icon(
      Icons.add_alert,
      color: MyStyle().textColor,
      size: 36.0,
    ),
    title: Text(
      title,
      style: MyStyle().h2TextStyle,
    ),
  );
}

Future<void> normalDialog(
    BuildContext context, String title, String message) async {
  showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: showTitle(title),
          content: Text(message),
          actions: <Widget>[
            okButton(context)
          ],
        );
      });
}

FlatButton okButton(BuildContext context) {
  return FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
}
