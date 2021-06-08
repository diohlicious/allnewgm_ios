import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/Nikita/app.dart';

import 'Nikita/Nson.dart';
import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  String userId;
  String email;
  Nson daftarNson = Nson.newObject();
  Nson _nsonBody = Nson.newObject();
  TextEditingController ctrler1 = TextEditingController();
  TextEditingController ctrler2 = TextEditingController();
  TextEditingController ctrler3 = TextEditingController();
  TextEditingController ctrler4 = TextEditingController();
  TextEditingController ctrler5 = TextEditingController();
  TextEditingController ctrler6 = TextEditingController();
  FocusNode text1FocusNode = FocusNode();
  FocusNode text2FocusNode = FocusNode();
  FocusNode text3FocusNode = FocusNode();
  FocusNode text4FocusNode = FocusNode();
  FocusNode text5FocusNode = FocusNode();
  FocusNode text6FocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    daftarNson = arguments["daftarNson"];
    userId = daftarNson.get('userId').asString();
    email = daftarNson.get('email').asString();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    //ScreenUtil.instance =
    //    ScreenUtil(width: 750, height: 1304, allowFontScaling: true)
    //      ..init(context);
    return ScreenUtilInit(
      designSize: Size(750, 1304),
      builder: () => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
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
                height: ScreenUtil().setHeight(10),
              ),
              Container(
                child: Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: _showSignIn(context)),
              ),
            ],
          ),
          bottomSheet: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.only(),
              child: InkWell(
                onTap: () {
                  print('hello');
                  //Navigator.of(context).pop();
                  //Navigator.of(context).pushNamed('/andaberhasil');
                  _onLoading();
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
                  child: new Center(
                    child: new Text(
                      'Verifikasi',
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
        ),
        debugShowCheckedModeBanner: true,
      ),
    );
  }

  void _onNext() async {
    App.showBusy(context);
    var otp =
        '${ctrler1.text}${ctrler2.text}${ctrler3.text}${ctrler4.text}${ctrler5.text}${ctrler6.text}';
    print(otp);
    ApiService apiService = ApiService();
    var response = await apiService.validasiOtpMobile(otp, email);
    Nson _nres = await apiService.getNson(response);
    print(_nres.asString());
    Navigator.pop(context); //pop dialog
      //dari sini
      if (_nres.get('message').asString() == 'success') {
        //berhasil disini
        if (daftarNson.get('state').asString()=='login'){
          App.showDialogBox(context, 'Sukses', 'Silahkan Login Kembali',
              onClick: () async {
                Navigator.of(context).pushNamed('/login');
              });
        } else {
          Navigator.of(context).pushNamed(
              '/andaberhasil', arguments: {'daftarNson': daftarNson});
        }
      } else {
        App.showDialogBox(context, 'otp: $otp userId: $userId', _nres.get('description').asString(),
            onClick: () async {
              Navigator.of(context).pop();
            });
      }
      //ke sini
  }

  void _onLoading() async {
    //var response = await apiService.loginMasuk("baihakitanjung12@gmail.com", "123456789") ;
    ctrler1.text.length == 0
        ? App.showDialogBox(context, "Isi OTP", "", onClick: () async {
            Navigator.of(context).pop();
          })
        : ctrler2.text.length == 0
            ? App.showDialogBox(context, "Isi OTP", "", onClick: () async {
                Navigator.of(context).pop();
              })
            : ctrler3.text.length == 0
                ? App.showDialogBox(context, "Isi OTP", "", onClick: () async {
                    Navigator.of(context).pop();
                  })
                : ctrler4.text.length == 0
                    ? App.showDialogBox(context, "Isi OTP", "",
                        onClick: () async {
                        Navigator.of(context).pop();
                      })
                    : ctrler5.text.length == 0
                        ? App.showDialogBox(context, "Isi OTP", "",
                            onClick: () async {
                            Navigator.of(context).pop();
                          })
                        : ctrler6.text.length == 0
                            ? App.showDialogBox(context, "Isi OTP", "",
                                onClick: () async {
                                Navigator.of(context).pop();
                              })
                            : _onNext();
  }

  void _onResend() async {
    App.showBusy(context);
    ApiService apiService = ApiService();

    //var response = await apiService.loginMasuk("baihakitanjung12@gmail.com", "123456789") ;
    var response = await apiService.ResendOtp(
        daftarNson.get('namalengkap').asString(),
        daftarNson.get('phone').asString(),
        daftarNson.get('userId').asString(),
        email);

    print(response.body + daftarNson.get('email').asString());

    _nsonBody = await apiService.getNson(response);

    // //pop dialog
    if (_nsonBody.get("message").asString() == "success") {
      //berhasil disini
      Navigator.pop(context);
      App.showDialogBox(context, "Informasi", _nsonBody.get("description").asString(),
          onClick: () async {
        Navigator.of(context).pop();
      });
    } else {
      Navigator.pop(context);
      print("ini description" + daftarNson.get('email').asString());
      App.showDialogBox(context, "Peringatan", _nsonBody.get('description').asString(),
          onClick: () async {
        Navigator.of(context).pop();
      });
    }
  }

  Widget _showSignIn(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text("Kode OTP terkirim!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                fontSize: 20)),
        SizedBox(
          height: 20,
        ),
        Text(
            "Check email atau sms dan melalui OTP Anda untuk memverifikasi akun",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color.fromARGB(255, 143, 143, 143))),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _otpTextField(1),
            _otpTextField(2),
            _otpTextField(3),
            _otpTextField(4),
            _otpTextField(5),
            _otpTextField(6),
          ],
        ),
        /*Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              maxLength: 1,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Theme
                  .of(context)
                  .accentColor),
              controller: null,
              decoration: InputDecoration(
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(  color: Theme .of(context)  .accentColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme .of(context) .accentColor, width: 1.0)),

              ),
              obscureText: false,
            ),
          ),
        ),*/
        SizedBox(
          height: 80,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: FlatButton(
              onPressed: () {
                // print('Kirim Ulang Kode OTP');
                // Navigator.of(context).pushNamed('/ganti');
                _onResend();
              },
              child: Text("Kirim Ulang Kode OTP",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 148, 193, 44),
                      fontSize: 14)),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil().setWidth(120),
          height: 1.0,
          color: Colors.white.withOpacity(0.6),
        ),
      );

  Widget emailErrorText() => Text("Controller.displayErrorEmailLogIn");

  // Return "OTP" input field
  /*get _getInputField {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(0),
        _otpTextField(0),
        _otpTextField(0),
        _otpTextField(0),
      ],
    );
  }*/

  // Returns "Otp custom text field"
  textEditingController(int pos) {
    switch (pos) {
      case 1:
        return ctrler1; //HomeView();
      case 2:
        return ctrler2;
      case 3:
        return ctrler3;
      case 4:
        return ctrler4;
      case 5:
        return ctrler5;
      default:
        return ctrler6;
    }
  }

  focusNode(int pos) {
    switch (pos) {
      case 1:
        return text1FocusNode;
      case 2:
        return text2FocusNode;
      case 3:
        return text3FocusNode;
      case 4:
        return text4FocusNode;
      case 5:
        return text5FocusNode;
      case 6:
        return text6FocusNode;
      default:
        return null;
    }
  }

  focusScope(int pos) {
    switch (pos) {
      case 1:
        return text2FocusNode;
      case 2:
        return text3FocusNode;
      case 3:
        return text4FocusNode;
      case 4:
        return text5FocusNode;
      case 5:
        return text6FocusNode;
      default:
        return null;
    }
  }

  Widget _otpTextField(int id) {
    return Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: TextField(
        //maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: textEditingController(id),
        onChanged: (String value) {
          focusNode(id).unfocus();
          FocusScope.of(context).requestFocus(focusScope(id));
        },
        focusNode: focusNode(id),
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
          //            color: Colors.grey.withOpacity(0.4),
          border: Border(
              bottom: BorderSide(
        width: 2.0,
        color: Colors.black,
      ))),
    );
  }
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
