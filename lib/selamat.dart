

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Selamat extends StatefulWidget {
  @override
  _SelamatState createState() => _SelamatState();
}

class _SelamatState extends State<Selamat> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenUtil.instance = ScreenUtil.getInstance()
      ..init(context);
    ScreenUtil.instance =
    ScreenUtil(width: 750, height: 1304, allowFontScaling: true)
      ..init(context);
    return
      MaterialApp(

        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.green,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:
        Scaffold(
            appBar:
            AppBar(

              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: InkWell(
                borderRadius: BorderRadius.circular(30.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black54,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/login');
                  Navigator.of(context).popUntil(ModalRoute.withName('/login'));
                },
              ),),
            body:  Column(
              children: <Widget>[
                Container(
                  child: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child:  Column(
                        children: <Widget>[

                          Container(
                            alignment: Alignment.center,
                            height: 60,
                            margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Image.asset(
                              "assets/images/daftar_logo.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                  ),
                  width: 200,
                  height: 80,
                ),
                SizedBox(
                  height: 0,
                ),
                Container(
                  child: Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: true ? _showSignIn(context) : _showSignUp(context)),

                ),
              ],
            ) ,
          bottomSheet: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(25) ,
            child: Padding(
              padding: EdgeInsets.only(),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/home');
                  Navigator.of(context).popUntil(ModalRoute.withName('/home'));

                },
                child: new Container(
                  width: 100.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Color.fromARGB(255, 148, 193, 44),
                    border: new Border.all(
                        color: Color.fromARGB(255, 148, 193, 44), width: 1.0),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Center(child: new
                  Text('Telusuri',
                    style: new TextStyle(fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.white),),),
                ),
              ),
            ),
          ),
        ),

        debugShowCheckedModeBanner: true,
      );

  }

  Widget _showSignIn(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/images/berhasil_bergabung.png"),
                ],
              ),
            )
           ],
        ),
        Text("Selamat bergabung!", textAlign: TextAlign.center,style: TextStyle(

            fontFamily: "Nunito",fontWeight: FontWeight.w700,
            fontSize: 22)),
        SizedBox(
          height: 20,
        ),
        Text("Anda telah bergabung dengan GrosirMobil, pilih mobil dan segerala lakukan penawaran", textAlign: TextAlign.center,style: TextStyle(
            fontFamily: "Nunito",
            color: Color.fromARGB(255, 143, 143, 143),
            fontWeight: FontWeight.w500,height: 1.5,
            fontSize: 14)),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(50),
        ),








      ],
    );
  }

  Widget _showSignUp(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: false,
              style: CustomTextStyle.formField(context),
              controller: null,
              decoration: InputDecoration(
                //Add th Hint text here.
                hintText: "Controller.displayHintTextNewEmail",
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme
                            .of(context)
                            .accentColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme
                            .of(context)
                            .accentColor, width: 1.0)),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(50),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: true,
              style: CustomTextStyle.formField(context),
              controller: null,
              decoration: InputDecoration(
                //Add the Hint text here.
                hintText: "Controller.displayHintTextNewPassword",
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme
                            .of(context)
                            .accentColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme
                            .of(context)
                            .accentColor, width: 1.0)),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(80),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: RaisedButton(
              child: Text(
                "Controller.displaySignUpMenuButton",
                style: CustomTextStyle.button(context),
              ),
              color: Colors.blueGrey,
              onPressed:  null,
            ),
          ),
        ),
      ],
    );
  }

  Widget horizontalLine() =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.white.withOpacity(0.6),
        ),
      );

  Widget emailErrorText() => Text("Controller.displayErrorEmailLogIn");
}



class CustomTextStyle {
  static TextStyle formField(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .title
        .copyWith(
        fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle title(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .title
        .copyWith(
        fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white);
  }

  static TextStyle subTitle(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .title
        .copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle button(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .title
        .copyWith(
        fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle body(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .title
        .copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white);
  }
}