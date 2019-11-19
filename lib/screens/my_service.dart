import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pasadu/screens/home.dart';
import 'package:pasadu/screens/my_style.dart';
import 'package:pasadu/widget/main_home.dart';
import 'package:pasadu/widget/page1.dart';
import 'package:pasadu/widget/page2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyService extends StatefulWidget {
  final String keyRunrecno;
  MyService({Key key, this.keyRunrecno}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Field
  String loginString = '...';
  String runrecnoString;
  Widget currentWidget = MainHome();

  // Method
  @override
  void initState() {
    super.initState();
    runrecnoString = widget.keyRunrecno;
    if (runrecnoString != null) {
      readUserData();
    }
  }

  Future<void> readUserData() async {
    String url =
        'https://appdb.tisi.go.th/ForApp/getUserWhereRunrecno.php?isAdd=true&runrecno=$runrecnoString';

    Response response = await get(url);
    var result = json.decode(response.body);
    if (result != 'null') {
      for (var map in result) {
        setState(() {
          String name = map['reg_fname'];
          String surName = map['reg_lname'];
          loginString = '$name $surName';
        });
      }
    }
  }

  Widget menuHome() {
    return ListTile(
      leading: Icon(
        Icons.home,
        size: 36.0,
        color: Colors.purple,
      ),
      title: Text('Home'),
      subtitle: Text('Description of Home'),
      onTap: () {
        setState(() {
          currentWidget = MainHome();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuPage1() {
    return ListTile(
      leading: Icon(
        Icons.pets,
        size: 36.0,
        color: Colors.green.shade800,
      ),
      title: Text('Page1'),
      subtitle: Text('Description of Page1'),
      onTap: () {
        setState(() {
          currentWidget = Page1();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuPage2() {
    return ListTile(
      leading: Icon(
        Icons.add_comment,
        size: 36.0,
        color: Colors.blue.shade800,
      ),
      title: Text('Page2'),
      subtitle: Text('Description of Page2'),
      onTap: () {
        setState(() {
          currentWidget = Page2();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuExit() {
    return ListTile(
      leading: Icon(
        Icons.close,
        size: 36.0,
        color: Colors.pink.shade600,
      ),
      title: Text('Exit'),
      subtitle: Text('Exit and Close Application'),
      onTap: () {
        Navigator.of(context).pop();
        exit(0);
      },
    );
  }

  Widget menuSignOut() {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        size: 36.0,
        color: Colors.orange.shade700,
      ),
      title: Text('Sign Out'),
      subtitle: Text('Sign Out and Back Authen'),
      onTap: () {
        Navigator.of(context).pop();
        processSignOut();
      },
    );
  }

  Future<void> processSignOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) {
      return Home();
    });
    Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
        (Route<dynamic> route) {
      return false;
    });
  }

  Widget showLogin() {
    return Text(
      'Login by $loginString',
      style: TextStyle(color: Colors.red.shade600),
    );
  }

  Widget showAppName() {
    return Text(
      'Monitor',
      style: TextStyle(
        fontSize: MyStyle().h2,
        color: MyStyle().textColor,
        fontFamily: MyStyle().fontString,
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget head() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          showLogo(),
          showAppName(),
          showLogin(),
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          head(),
          menuHome(),
          Divider(),
          menuPage1(),
          Divider(),
          menuPage2(),
          Divider(),
          menuSignOut(),Divider(),
          menuExit(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Service'),
      ),
      body: currentWidget,
      drawer: showDrawer(),
    );
  }
}
