import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pasadu/screens/normal_dialog.dart';
import '../models/marker_model.dart';
import 'my_style.dart';

class DetailJob extends StatefulWidget {
  final MarkerModel markerModel;
  DetailJob({Key key, this.markerModel}) : super(key: key);

  @override
  _DetailJobState createState() => _DetailJobState();
}

class _DetailJobState extends State<DetailJob> {
  // Explicit
  MarkerModel currentMarkerModel;
  File file;
  LocationData currentLocationData;
  LatLng currentLatLng;
  CameraPosition cameraPosition;
  String _descripPic, _dateTime, _time;
  final formKey = GlobalKey<FormState>();

  // Method
  @override
  void initState() {
    super.initState();
    currentMarkerModel = widget.markerModel;
    findLatLng();
    print('currentLatLng ===========>>>>>> $currentLatLng');
  }

  Future<void> findLatLng() async {
    currentLocationData = await locationData();
    print('Lat ======> ${currentLocationData.latitude}');
    print('Lng ======> ${currentLocationData.longitude}');

    setState(() {
      currentLatLng =
          LatLng(currentLocationData.latitude, currentLocationData.longitude);
    });
  }

  Future<LocationData> locationData() async {
    Location location = Location();

    try {
      return await location.getLocation();
    } catch (e) {}
  }

  Widget showMapLocation() {
    if (currentLatLng != null) {
      cameraPosition = CameraPosition(
        target: currentLatLng,
        zoom: 16.0,
      );
    }

    return currentLatLng == null
        ? Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController googleMapController) {},
              markers: myMarker(),
            ),
          );
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
          position: currentLatLng,
          markerId: MarkerId('idUser'),
          infoWindow: InfoWindow(
            title: currentMarkerModel.traderName,
            snippet: '${currentLatLng.latitude}, ${currentLatLng.longitude}',
          ))
    ].toSet();
  }

  Widget cameraButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      color: MyStyle().textColor,
      icon: Icon(
        Icons.add_a_photo,
        color: Colors.white,
      ),
      label: Text(
        'Camera',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        cameraOrGallery(ImageSource.camera);
      },
    );
  }

  Future<void> cameraOrGallery(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
          source: imageSource, maxWidth: 800.0, maxHeight: 600.0);

      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget galleryButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      color: MyStyle().mainColor,
      icon: Icon(
        Icons.add_photo_alternate,
        color: Colors.white,
      ),
      label: Text(
        'Gallery',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        cameraOrGallery(ImageSource.gallery);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showPic() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: file == null ? Image.asset('images/pic.png') : Image.file(file),
    );
  }

  Widget mySizeBox() {
    return SizedBox(
      height: 10.0,
    );
  }

  Widget showTraderName() {
    return Text(
      currentMarkerModel.traderName,
      style: MyStyle().h2TextStyle,
    );
  }

  Widget showType() {
    return Text(
      currentMarkerModel.type,
      style: MyStyle().h3TextStyle,
    );
  }

  Widget showAddress() {
    return Text(currentMarkerModel.address);
  }

  Widget showDate() {
    DateTime dateTime = DateTime.now();
    _dateTime = DateFormat('D MMMM yyyy').format(dateTime);

    return Text(
      'Date Time = $_dateTime',
      style: MyStyle().h3TextStyle,
    );
  }

  Widget showTime() {
    DateTime dateTime = DateTime.now();
    _time = DateFormat('HH:mm').format(dateTime);

    return Text(
      'Time = $_time',
      style: MyStyle().h2TextStyle,
    );
  }

  Widget descripImage() {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: Colors.black12,
      ),
      child: Form(
        key: formKey,
        child: TextFormField(
          onSaved: (String string) {
            _descripPic = string.trim();
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.photo),
            hintText: 'Description Picture :',
          ),
        ),
      ),
    );
  }

  Widget confirmButton() {
    return RaisedButton(
      color: MyStyle().textColor,
      child: Text(
        'Confirm Data',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        formKey.currentState.save();

        if (file == null) {
          normalDialog(context, 'ยังไม่เลือกรูปภาพ', 'กรุณา เลือกรูปภาพ ด้วย');
        } else if (_descripPic.isEmpty) {
          normalDialog(context, 'ยังไม่ใสรายละเอียดรูปภาพ',
              'กรุณาใส รายละเอียดรูปภาพ ด้วยคะ');
        } else {
          myAlertDialog();
        }
      },
    );
  }

  Widget showTitle() {
    return ListTile(
      leading: Icon(
        Icons.account_box,
        size: 36.0,
        color: MyStyle().textColor,
      ),
      title: Text(
        'Are You Sure ?',
        style: MyStyle().h3TextStyle,
      ),
    );
  }

  Widget showDialogImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        image: DecorationImage(
          image: FileImage(file),
          fit: BoxFit.cover,
        ),
      ),
      height: 120.0, width: 180.0,
      // child: Image.file(file),
    );
  }

  Widget showContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showTraderName(),
        showDialogImage(),
        showText(_descripPic),
        showText('latitude = ${currentLatLng.latitude}'),
        showText('longtitude = ${currentLatLng.longitude}'),
      ],
    );
  }

  Widget saveButton() {
    return FlatButton(
      child: Text(
        'Save',
        style: TextStyle(color: Colors.blue.shade800),
      ),
      onPressed: () {
        uploadPicture();
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> uploadPicture() async {
    String url = 'https://appdb.tisi.go.th/ForApp/saveFile.php';

    // Random random = new Random();
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'id${currentMarkerModel.autoNo}_$i.jpg';
    print('nameFile = $nameFile');

    try {
      Map<String, dynamic> map = Map();
      map['file'] = UploadFileInfo(file, nameFile);
      FormData formData = FormData.from(map);

      Response response = await Dio().post(url, data: formData);
      print('response = $response');
      insertValueToServer(nameFile);
    } catch (e) {
      print('e =======>>>>>>> $e');
    }
  }

  Future<void> insertValueToServer(String nameFile) async {

    String autuNoRef = currentMarkerModel.autoNo.toString();
    String latString = currentLatLng.latitude.toString();
    String lngString = currentLatLng.longitude.toString();
    String pathImage = 'https://appdb.tisi.go.th/ForApp/picture_market/$nameFile';
    String dateUpdate = _dateTime;
    String timeUpdate = _time;
    String isCheck = currentMarkerModel.idCheck;
    String descrip = _descripPic;

    
 
    String url =
        'https://appdb.tisi.go.th/ForApp/addDataINPECTOR_marker_picture.php?isAdd=true&auto_no_ref=$autuNoRef&lat=$latString&lng=$lngString&path_image=$pathImage&date_update=$dateUpdate&time_update=$timeUpdate&idCheck=$isCheck&Description=$descrip';

    Response response = await Dio().get(url);
    var result = json.decode(response.data);
    if (result.toString() == 'true') {
      Navigator.of(context).pop();
    } else {
      normalDialog(context, 'Cannot Upload', 'Please Try Again');
    }

  }

  Widget cancelButton() {
    return FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget showText(String string) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 230.0,
          child: Text(
            string,
            style: MyStyle().h4TextStyle,
          ),
        ),
      ],
    );
  }

  Future<void> myAlertDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            title: showTitle(),
            content: showContent(),
            actions: <Widget>[
              saveButton(),
              cancelButton(),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: ListView(
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          showTraderName(),
          mySizeBox(),
          showType(),
          mySizeBox(),
          showAddress(),
          showPic(),
          mySizeBox(),
          descripImage(),
          showButton(),
          mySizeBox(),
          showMapLocation(),
          mySizeBox(),
          showDate(),
          mySizeBox(),
          showTime(),
          mySizeBox(),
          confirmButton(),
        ],
      ),
    );
  }
}
