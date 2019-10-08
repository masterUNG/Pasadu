import 'package:flutter/material.dart';
import 'package:pasadu/screens/my_style.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Explicit
  bool statusRemember = false; // false => Non Save, true => Save Member
  final formKey = GlobalKey<FormState>();
  String emailString, passwordString;

  // Method

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
        },onSaved: (value){
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
        ),validator: (value){
          if (value.isEmpty) {
            return 'Please Type Password In The Blank';
          } else {
            return null;
          }
        },onSaved: (value){
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
          }
        },
      ),
    );
  }

  Widget rememberCheck() {
    return Container(
      width: 250.0,
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text('Remember Me'),
        value: statusRemember,
        onChanged: (bool value) {},
      ),
    );
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
