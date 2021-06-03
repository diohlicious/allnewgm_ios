import 'dart:collection';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';
import 'package:http/http.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LogInPageState extends State<Login> {
  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print("onWillPop");

          Navigator.of(context).pop();
        },
        child: MaterialApp(
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
          home: null,
          debugShowCheckedModeBanner: true,
        ));
  }
}

class _LoginState extends State<Login> {
  String _token;
  Stream<String> _tokenStream;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController myEmail = TextEditingController();
  TextEditingController myPassword = TextEditingController();
  bool showpass = true;
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    // TODO: implement initState
    //this.initializeFlutterFire();
    super.initState();

    //baihakitanjung12@gmail.com
    myEmail.text = 'baihakitanjung12@gmail.com';
    myEmail.text = 'rkrzmail@gmail.com';
    myEmail.text = 'sunu@studioh.id';
    myPassword.text = '123456789';
    //firebase token
    FirebaseMessaging.instance.getToken().then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);

  }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  void setToken(String token) {
    print('FCM Token: $token');
    setState(() {
      _token = token;
    });
  }

  void _onLoading() async {
    App.showBusy(context);
    ApiService apiService = ApiService();

    //var response = await apiService.loginMasuk("baihakitanjung12@gmail.com", "123456789") ;
    var response = await apiService.loginMobile(myEmail.text, myPassword.text, _token);
    App.log(myEmail.text);
    App.log(response.body);

    await App.setSetting("email", myEmail.text);
    Nson nson = await apiService.getNson(response);
    App.log(nson.toJson());

    Navigator.pop(context); //pop dialog
    if (response.statusCode == 200) {
      //berhasil disini
      if (nson.get('message').asString() == 'error') {
        App.showDialogBox(context, nson.get("description").asString(), '',
            onClick: () async {
          Navigator.of(context).pop();
        });
      } else {
        App.setSetting("sign", "true");
        App.setSetting("auth", nson.get('data').get('token').asString());
        App.setSetting(
            "userid",
            nson
                .get('data')
                .get('logged_in_user')
                .get('user')
                .get('id')
                .asString());
        App.setSetting("profile", nson.toJson());
        print("ini auth yang ada ${App.getSetting("auth")}");
        App.log(nson.toStream());
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/home');
      }
    } else {
      App.showDialogBox(context, nson.get("error").asString(), '',
          onClick: () async {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1304, allowFontScaling: true)
          ..init(context);
    return MaterialApp(
      title: 'Grosir Mobil',
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
      home: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Column(
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
              height: ScreenUtil.getInstance().setHeight(10),
            ),
            Container(
              child: Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: _showSignIn(context)),
            ),
          ],
        ),
        bottomSheet: Container(
          height: 130,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(),
                  child: InkWell(
                    onTap: () {
                      print('hello');
                      //Navigator.of(context).pushNamed('/otp');
                      _onLoading();
                    },
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
                          'Masuk',
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
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum mempunyai akun ? ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromARGB(255, 143, 143, 143))),
                  FlatButton(
                    onPressed: () {
                      print('daftar');
                      Navigator.of(context).pushNamed('/daftar');
                    },
                    child: Text("Daftar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 148, 193, 44),
                            fontSize: 14)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _showSignIn(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text("Masuk",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
        SizedBox(
          height: 20,
        ),
        Text("Selamat datang silahkan masukan akun anda",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color.fromARGB(255, 143, 143, 143))),
        SizedBox(
          height: 40,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              style: TextStyle(color: Theme.of(context).accentColor),
              controller: myEmail,
              decoration: InputDecoration(
                labelText: "Email",
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.black,
                ),
              ),
              obscureText: false,
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
              obscureText: showpass,
              style: TextStyle(color: Theme.of(context).accentColor),
              controller: myPassword,
              decoration: InputDecoration(
                //Add th Hint text here.
                labelText: "Password",
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.black,
                ),
                suffixIcon: FlatButton(
                  onPressed: () {
                    setState(() {
                      showpass = !showpass;
                    });
                  },
                  child: Icon(
                      showpass ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(80),
        ),
        /*Container(
          child: TextButton(
            onPressed: () {
              print('Lupa Password');
              //Navigator.of(context).pushNamed('/ubah');
              if (App.isEmail(myEmail.text)) {
                App.newProses(context, () async {
                  Nson n = await ApiService.get().changePasswordApi(
                      Nson.newObject().set('email', myEmail.text));
                  App.log(n.toStream());
                }, () {
                  Navigator.of(context).pushNamed('/checksms',
                      arguments: {'email': myEmail.text});
                });
              } else {
                App.showError('Mohon isi Email dengan benar');
              }
            },
            child: Text("Lupa Password ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 148, 193, 44),
                    fontSize: 14)),
          ),
        ),*/
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(80),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                horizontalLine(),
                Text("Masuk", style: CustomTextStyle.body(context)),
                horizontalLine()
              ],
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
      ],
    );
  }

  Widget horizontalLine() => Padding(
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
    return Theme.of(context).textTheme.title.copyWith(
        fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.title.copyWith(
        fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white);
  }

  static TextStyle subTitle(BuildContext context) {
    return Theme.of(context).textTheme.title.copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle button(BuildContext context) {
    return Theme.of(context).textTheme.title.copyWith(
        fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle body(BuildContext context) {
    return Theme.of(context).textTheme.title.copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white);
  }
}
