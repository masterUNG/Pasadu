import 'package:flutter/material.dart';
import 'package:pasadu/screens/my_service.dart';
import 'package:pasadu/screens/my_style.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Explicit
  bool statusRemember = false; // false => Non Save, true => Save Member
  final formKey = GlobalKey<FormState>();
  String emailString, passwordString, runrecnoString;

  // Method
  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  Future checkStatus() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      bool currentRemember = sharedPreferences.getBool('remember');
      if (currentRemember) {
        runrecnoString = sharedPreferences.getString('runrecno');
        routeToMyService();
      }
    } catch (e) {}
  }

  Widget showLogo() {
    return Container(
      width: 50.0,
      height: 50.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'Monitor',
      style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          color: MyStyle().textColor,
          fontFamily: 'Mansalva'),
    );
  }

  Widget userText() {
    return Container(
      width: 250.0,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            color: MyStyle().textColor,
          ),
          labelText: 'User Name :',
          labelStyle: TextStyle(color: MyStyle().textColor),
          helperText: 'Type Your Email',
          helperStyle: TextStyle(color: MyStyle().textColor),
          hintText: 'you@email.com',
        ),
        validator: (String value) {
          if (!((value.contains('@')) && (value.contains('.')))) {
            return 'Please Keep Email Format';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          emailString = value.trim();
        },
      ),
    );
  }

  Widget passwordText() {
    return Container(
      width: 250.0,
      child: TextFormField(
        obscureText: true,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          labelText: 'Password :',
          helperText: 'Type Your Password',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please Type Password In The Blank';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          passwordString = value.trim();
        },
      ),
    );
  }

  Widget loginButton() {
    return Container(
      width: 250.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: MyStyle().textColor,
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            print('email = $emailString, password = $passwordString');
            checkAuthen();
          }
        },
      ),
    );
  }

  Future<void> checkAuthen() async {
    String urlAPI =
        'https://appdb.tisi.go.th/ForApp/getUserWhereUserEmailEad.php?isAdd=true&reg_email=$emailString&reg_unmd5=$passwordString';

    Response response = await get(urlAPI);
    var result = json.decode(response.body);
    print('result = $result');

    if (result.toString() == 'null') {
      myAlert('Authen False', 'Please Cheack User or Password Agains');
    } else {
      for (var myData in result) {
        runrecnoString = myData['runrecno'];
        print('runrecno = $runrecnoString');

        if (statusRemember) {
          // Save runrecno
          saveUserThread();
        }

        routeToMyService();
      }
    }
  }

  void routeToMyService() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) {
      return MyService(
        keyRunrecno: runrecnoString,
      );
    });
    Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
        (Route<dynamic> route) {
      return false;
    });
  }

  Future<void> saveUserThread() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('runrecno', runrecnoString);
    sharedPreferences.setBool('remember', statusRemember);
  }

  Widget showTitle(String title) {
    return ListTile(
      leading: Icon(
        Icons.add_alert,
        size: 48.0,
        color: MyStyle().textColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: MyStyle().h2,
          color: MyStyle().textColor,
        ),
      ),
    );
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: showTitle(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget rememberCheck() {
    return Container(
      width: 250.0,
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text('Remember Me'),
        value: statusRemember,
        onChanged: (bool value) {
          onRememberCheck(value);
        },
      ),
    );
  }

  void onRememberCheck(bool value) {
    setState(() {
      statusRemember = value;
    });
  }

  Widget showLogoAndName() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showLogo(),
        SizedBox(
          width: 4.0,
        ),
        showAppName(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, MyStyle().mainColor],
              radius: 0.8,
            ),
          ),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  showLogoAndName(),
                  userText(),
                  passwordText(),
                  rememberCheck(),
                  loginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
