

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Ganti extends StatefulWidget {
  @override
  _GantiState createState() => _GantiState();
}



class _GantiState extends State<Ganti> {
  TextEditingController myEmail = TextEditingController();
  TextEditingController myPassword = TextEditingController();
  bool showpass = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //ScreenUtil.instance = ScreenUtil.getInstance()
    //  ..init(context);
    //ScreenUtil.instance =
    //ScreenUtil(width: 750, height: 1304, allowFontScaling: true)
    //  ..init(context);

    final Map args = ModalRoute.of(context).settings.arguments as Map;
    myEmail.text = Nson(args).get('email').asString();

    return
      ScreenUtilInit(
        designSize: Size(750, 1304),
        builder: () => MaterialApp(

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
            body:  Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child:  Column(
                      children: <Widget>[

                        Container(
                          alignment: Alignment.center,
                          height: 120,
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
                  height: 130,
                ),


                SizedBox(
                  height: ScreenUtil().setHeight(10),
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
                    if ( myPassword.text != '' ){
                      App.newProses(context, () async {
                        Nson n = await ApiService.get().changePasswordApi(Nson.newObject().set('email', myEmail.text));
                        App.log(n.toStream());
                      }, () {

                        Navigator.of(context).pushNamed('/login');
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                      });
                    }else{
                      App.showError( 'Mohon isi Passowrd dengan benar');
                    }
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
                    Text('Ubah',
                      style: new TextStyle(fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white),),),
                  ),
                ),
              ),
            ),
          ),

          debugShowCheckedModeBanner: true,
        ),
      );

  }

  Widget _showSignIn(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text("Ganti Password", textAlign: TextAlign.center,style: TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.w700,
            fontSize: 22)),
        SizedBox(
          height: 20,
        ),
        Text("Rubah password yang anda lupa", textAlign: TextAlign.center,style: TextStyle(
            fontFamily: "Nunito",
            color: Color.fromARGB(255, 143, 143, 143),
            fontWeight: FontWeight.w500,
            fontSize: 14)),
        SizedBox(
          height: 70,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              enabled: false,
              style: TextStyle(color: Theme
                  .of(context)
                  .accentColor),
              controller: myEmail,
              decoration: InputDecoration(
                labelText: "Email",
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
                  Icons.lock_outline,
                  color: Colors.black,
                ),

              ),
              obscureText: false,
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(50),
        ),

        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: showpass,
              style: TextStyle(color: Theme
                  .of(context)
                  .accentColor),
              controller: myPassword,
              autofocus: true,

              decoration: InputDecoration(
                //Add th Hint text here.
                labelText: "Confirm Password Baru",
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
                  Icons.lock_outline,
                  color: Colors.black,
                ),
                suffixIcon: FlatButton(onPressed: (){
                  setState(() {
                    showpass=!showpass;
                  });
                }, child:  Icon(
                    showpass ? Icons.visibility_off:   Icons.visibility ,
                    color: Colors.black)   ,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(80),
        ),
        Container(



        ),

        SizedBox(
          height: ScreenUtil().setHeight(80),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                horizontalLine(),
                Text("Masuk",
                    style: CustomTextStyle.body(context)),
                horizontalLine()
              ],
            ),
          ),
        ),


      ],
    );
  }

  Widget _showSignUp(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: ScreenUtil().setHeight(30),
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
          height: ScreenUtil().setHeight(50),
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
          height: ScreenUtil().setHeight(80),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: ElevatedButton(
              child: Text(
                "Controller.displaySignUpMenuButton",
                style: CustomTextStyle.button(context),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
              ),
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
          width: ScreenUtil().setWidth(120),
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