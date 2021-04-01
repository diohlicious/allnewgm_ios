

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/Nikita/app.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => _OTPState();
}



class _OTPState extends State<OTP> {

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

          primarySwatch: Colors.green,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:
        Scaffold(
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
                    child:   _showSignIn(context)
                ),

              ),
            ],
          ),
          bottomSheet: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(25) ,
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
                  child: new Center(child: new
                  Text('Verifikasi',
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
  void  _onLoading() async {
    App.showBusy(context);
    ApiService apiService = ApiService();

    //var response = await apiService.loginMasuk("baihakitanjung12@gmail.com", "123456789") ;
    var response = await apiService.validasiOtpMobile( "558568") ;


    print (response.body);




    Navigator.pop(context); //pop dialog
    if (response.statusCode == 200) {
      //berhasil disini

    }else{

      App.showDialogBox(context, "Verifikasi Gagal","Gagal",  onClick: () async{
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/andaberhasil');//bypass

      });
    }

  }
  void  _onResend() async {
    App.showBusy(context);
    ApiService apiService = ApiService();

    //var response = await apiService.loginMasuk("baihakitanjung12@gmail.com", "123456789") ;
    var response = await apiService.ResendOtp( ) ;


    print (response.body);




    Navigator.pop(context); //pop dialog
    if (response.statusCode == 200) {
      //berhasil disini
      App.showDialogBox(context, "Informasi","Kirim Ulang Kode OTP Berhasil",  onClick: () async{
        Navigator.of(context).pop();

      });
    }else{
      App.showDialogBox(context, "Peringatan","Kirim Ulang Kode OTP Gagal",  onClick: () async{
        Navigator.of(context).pop();

      });
    }

  }
  Widget _showSignIn(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
            "Kode OTP terkirim!", textAlign: TextAlign.center, style: TextStyle(
            fontFamily: "Nunito", fontWeight: FontWeight.w700,
            fontSize: 20)),
        SizedBox(
          height: 20,
        ),
        Text(
            "Check email atau sms dan melalui OTP Anda untuk memverifikasi akun",
            textAlign: TextAlign.center, style: TextStyle(
            fontFamily: "Nunito",fontWeight: FontWeight.w500,
            fontSize: 14, color: Color.fromARGB(255, 143, 143, 143))),
        SizedBox(
          height: 50,
        ),

        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            _otpTextField(0),
            _otpTextField(1),
            _otpTextField(2),
            _otpTextField(3),
              _otpTextField(4),
              _otpTextField(5),
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
            child:
            FlatButton(
              onPressed:
                  (){
                // print('Kirim Ulang Kode OTP');
                // Navigator.of(context).pushNamed('/ganti');

                 _onResend();
              }, child: Text("Kirim Ulang Kode OTP", textAlign: TextAlign.center,style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255,148,193,44),

                fontSize: 14)
            ),
            ),

          ),
        ),
        SizedBox(
          height: 10,
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

  // Return "OTP" input field
  get _getInputField {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(0),
        _otpTextField(0),
        _otpTextField(0),
        _otpTextField(0),
      ],
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int digit) {
    return Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: Text(
        digit != null ? digit.toString() : "",
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