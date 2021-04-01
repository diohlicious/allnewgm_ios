


import 'package:shared_preferences/shared_preferences.dart';

class NsGlobal {
  static NsGlobal nsGlobal;
  static String title;
  static SharedPreferences settings;

  NsGlobal get(){

  }

  static init() async {
     settings = await SharedPreferences.getInstance();
  }
}