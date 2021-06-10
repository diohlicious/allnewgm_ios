
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class App {
  static Nson Arguments = Nson.newObject();
  static bool needBuild = true;
  static String formatCurrency(double amount){
    /*FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
        amount: amount,
        settings: MoneyFormatterSettings(
            symbol: '',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 3,
            compactFormatType: CompactFormatType.short
        )
    );*/

    MoneyFormatterOutput fo = FlutterMoneyFormatter(
        amount:amount
    ).output;
        return fo.withoutFractionDigits;
  }
  static Map settings = Map<String, String>();
  static SharedPreferences settingpreff;
  static showError(String message){

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  static showDialogBox(BuildContext context, String title, String msg, {String buttonText, VoidCallback onClick}){
    AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        title: title,
        desc: msg,
        btnOk: Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap: onClick,
              child: new Container(
                width: 100.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  color: Color.fromARGB(255, 148, 193, 44),
                  border: new Border.all(
                      color: Color.fromARGB(255, 148, 193, 44),
                      width: 1.0),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Center(
                  child: new Text(
                    buttonText??"OK",
                    style: new TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
        dismissOnTouchOutside: true) .show();
  }
  static showBusy(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(15),
            child:   Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 15,),
              Text("Loading"),
            ],
          ),),
        );
      },
    );
  }

  String generateMd5(String input) {
    String salt = 'Gr0\$iR';
    String email = 'email';
    return md5.convert(utf8.encode(input)).toString();
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      //throw 'Could not open the map.';
    }
  }
  static void openMapAddress(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }
  static void openMapGeo({String lat = "47.6", String long = "-122.3"}) async{
    var mapSchema = 'geo:$lat,$long';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    } else {
      //throw 'Could not launch $mapSchema';
    }
  }
  static void launchURL(String url) async {
    // const url ='https://www.google.com/maps/dir/?api=1&origin=43.7967876,-79.5331616&destination=43.5184049,-79.8473993&waypoints=43.1941283,-79.59179|43.7991083,-79.5339667|43.8387033,-79.3453417|43.836424,-79.3024487&travelmode=driving&dir_action=navigate';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
     // throw 'Could not launch $url';
    }
  }
  static void openMapnavigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      //throw 'Could not launch ${uri.toString()}';
    }
  }




  static newProses(BuildContext context, VoidCallback run, VoidCallback ui) async {
     showBusy(context);
     await run.call();
     Navigator.pop(context);
     ui.call();
  }
  static bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
  static log (dynamic dyn){
    print (dyn);
  }

  static Future<bool> delSetting(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key) ;
  }
  static Future<String> getSetting(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }
  static Future<bool> setSetting(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/SharedPreferences.ini');
  }
  static Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return '';
    }
  }
  static Future<File> writeCounter(String data) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString('$data');
  }

  Future<void> getImage() async {
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    /*setState(() {
      _image = image;
    });*/
  }
  static int datedif(String date1, String date2) {
    try {
      DateTime sdate1 = DateTime.parse(date1);
      DateTime sdate2 = DateTime.parse(date2);

      int difference = sdate1 .difference(sdate2)  .inSeconds;
      //DateTime startNow =  compare.add(Duration(seconds:difference*-1));
      return difference;
    } on Exception catch (_) {
      return 0;
    }
  }
  static int wcounterlead(String serverdate){
    try {
      DateTime sdate1 = DateTime.parse(serverdate);
      DateTime today = DateTime.now();

      int difference = sdate1.difference(today).inSeconds;
      return difference;
    } on Exception catch (_) {

    }
      return 0;
  }
  static String  dateAdd(String serverdate, int lead){
    try {
      DateTime compare = DateTime.parse(serverdate);

      DateTime now =  compare.add(Duration(seconds:lead));
      return  DateFormat( 'yyyy-mm-dd HH:mm:ss').format(now);;
    } on Exception catch (_) {

    }
    return serverdate;
  }
  static double getDouble(String v){
    try {
      return double.parse(v);
    } on Exception catch (_) { }
    return 0;
  }
  static int getInt(String v){
    try {
      return int.parse(v);
    } on Exception catch (_) {
    }
    return 0;
  }
  static final _numberRegex = RegExp(r'-?\d+(\.\d+)?');
  static final _doubleRegex = RegExp(r'^[-+]?[0-9]*.?[0-9]+([eE][-+]?[0-9]+)?$' );
  static final _intRegex = RegExp(r'-?\d+' );

  static T cast<T>(x) => x is T ? x : null;
  static String replace(String _text, String _searchStr, String _replacementStr){
    StringBuffer sb = new StringBuffer();
    int searchStringPos = _text.indexOf(_searchStr);
    int startPos = 0;
    int searchStringLength = _searchStr.length;
    while (searchStringPos != -1) {
      sb.write(_text.substring(startPos, searchStringPos));
      sb.write(_replacementStr);
      startPos = searchStringPos + searchStringLength;
      searchStringPos = _text.indexOf(_searchStr, startPos);
    }
    sb.write(_text.substring(startPos, _text.length));
    return sb.toString();
  }
  static List<String> split(String original, String separator) {
    List<String> nodes = [];//growup
    int index = original.indexOf(separator);
    while (index >= 0) {
      nodes.add(original.substring(0, index));
      original = original.substring(index + separator.length);
      index = original.indexOf(separator);
    }
    nodes.add(original);
    return nodes;
  }
}