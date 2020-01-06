import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pasadu/screens/detail_job.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/marker_model.dart';
import '../screens/my_style.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  // Field
  String runRecNoString;
  List<MarkerModel> markerModels = List();

  // Method
  @override
  void initState() {
    super.initState();
    findRunRecNo();
  }

  Future<void> findRunRecNo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    runRecNoString = sharedPreferences.getString('runrecno');
    print('runRecNoString = $runRecNoString');
    if (runRecNoString != null) {
      readData();
    }
  }

  Future<void> readData() async {
    String url =
        'https://appdb.tisi.go.th/ForApp/getUserWhereidCheck.php?isAdd=true&idCheck=$runRecNoString';

    Response response = await get(url);
    var result = json.decode(response.body);
    print('result ============> $result');

    for (var map in result) {
      MarkerModel markerModel = MarkerModel.fromJson(map);
      setState(() {
        markerModels.add(markerModel);
      });
    }
  }

  Widget showTextName(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Text(
        markerModels[index].traderName,
        style: MyStyle().h2TextStyle,
      ),
    );
  }

  Widget showIcon() {
    return Icon(
      Icons.crop_din,
      color: Colors.red,
    );
  }

  Widget showTextType(int index) {
    return Row(
      children: <Widget>[
        Text(
          markerModels[index].type,
          style: MyStyle().h3TextStyle,
        ),
      ],
    );
  }

  Widget showTextAddress(int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Text(markerModels[index].address),
    );
  }

  Widget showTraderName(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        showTextName(index),
        showIcon(),
      ],
    );
  }

  Widget showListTrader() {
    return ListView.builder(
      itemCount: markerModels.length,
      itemBuilder: (BuildContext buildContext, int index) {
        return GestureDetector(
          onTap: () {
            MaterialPageRoute materialPageRoute =
                MaterialPageRoute(builder: (BuildContext buildContext) {
              return DetailJob(
                markerModel: markerModels[index],
              );
            });
            Navigator.of(context).push(materialPageRoute);
          },
          child: Card(
            color: index % 2 == 0
                ? Colors.cyan.shade100
                : Colors.cyanAccent.shade400,
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  showTraderName(index),
                  showTextType(index),
                  showTextAddress(index),
                  addMoreImage(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget addMoreImage() {
    return Row(mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () {
            print('You Click Add More');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showListTrader(),
    );
  }
}
