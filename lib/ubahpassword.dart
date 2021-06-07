



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


class UbahPass extends StatefulWidget {
  @override
  _UbahPassState createState() => _UbahPassState();
}



class _UbahPassState extends State<UbahPass> {
  TextEditingController myPassword = TextEditingController();
  TextEditingController myPasswordBaru = TextEditingController();
  TextEditingController myPasswordConf = TextEditingController();

  bool showpassLama = true;
  bool showpassBaru = true;
  bool showpassConf = true;


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
                  Navigator.pop(context);

                },
              ),
            ),
            body:  Column(children:[
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Container(
                  child: Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child:  _showSignIn(context)
                  ) ,

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
                    print('hello');
                    //Navigator.of(context).pop();// Navigator.of(context).pushNamed('/andaberhasil');
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
  void  _onLoading() async {
    App.showBusy(context);
    ApiService apiService = ApiService();
    var response = await apiService.changePasswordForgot("", myPassword.text) ;
     print (response.body);

    Navigator.pop(context); //pop dialog
    if (response.statusCode == 200) {
      //berhasil disini

    }else{
      /*AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Login Gagal',
          desc: '',


          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
          btnOk: Container(
            child: Padding(
              padding: EdgeInsets.only(),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();

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
                      'OK',
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
          dismissOnTouchOutside: false)  .show();*/
      App.showDialogBox(context, "Ubah Passwod","Gagal",  onClick: (){
        Navigator.of(context).pop();
      });
    }

  }
  Widget _showSignIn(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text("Ubah Password", textAlign: TextAlign.left,style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 27)),
        SizedBox(
          height: 20,
        ),
        Text("Rubah password lama anda", textAlign: TextAlign.left,style: TextStyle(
            fontFamily: "Nunito",
            color: Color.fromARGB(255, 143, 143, 143),
            fontWeight: FontWeight.w500,
            fontSize: 14)),
        SizedBox(
          height: ScreenUtil().setHeight(50),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              style: TextStyle(color: Theme
                  .of(context)
                  .accentColor),
              controller: myPassword,
              decoration: InputDecoration(
                labelText: "Password Lama",
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
                    showpassLama=!showpassLama;
                  });
                },

                  child:  Icon(
                    showpassLama ? Icons.visibility_off:   Icons.visibility ,
                    color: Colors.black)   ,
                ),
              ),
              obscureText: showpassLama,
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
              style: TextStyle(color: Theme
                  .of(context)
                  .accentColor),
              controller: myPasswordBaru,
              decoration: InputDecoration(
                labelText: "Password baru",
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
                    showpassBaru=!showpassBaru;
                  });
                },
                  child:  Icon(
                      showpassBaru ? Icons.visibility_off:   Icons.visibility ,
                      color: Colors.black)   ,
                ),
              ),
              obscureText: showpassBaru,
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
              obscureText: showpassConf,
              style: TextStyle(color: Theme
                  .of(context)
                  .accentColor),
              controller: myPasswordConf,
              decoration: InputDecoration(
                //Add th Hint text here.
                labelText: "Confim Pasword baru",
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
                    showpassConf=!showpassConf;
                  });
                },
                  child:  Icon(
                      myPasswordBaru.text == myPasswordConf.text ?  Icons.check : Icons.remove_circle_outline ,
                      color: myPasswordBaru.text == myPasswordConf.text ?    Colors.green :   Colors.red)   ,
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
        SizedBox(
          height: ScreenUtil().setHeight(30),
        ),
       /* Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap:  () {
                print('hello');
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.INFO,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Ubah password ',
                    desc: 'Ubah password  berhasil',
                    btnOkOnPress: () {
                      Navigator.of(context).pop();
                    },
                    dismissOnTouchOutside: false
                )..show();

              },
              child: new Container(
                width: 100.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  color: Color.fromARGB( 255,    148,193,44  ),
                  border: new Border.all(color: Color.fromARGB(255,148,193,44), width: 1.0),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Center(child: new Text('Ubah', style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0, color: Colors.white),),),
              ),
            ),
          ),
        ),*/
        SizedBox(
          height: 10,
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
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey)
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