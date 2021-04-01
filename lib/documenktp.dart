
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';


import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';

class DocumentKTP extends StatefulWidget {
  @override
  _DocumentKTPState createState() => _DocumentKTPState();
}



class _DocumentKTPState extends State<DocumentKTP> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return
      MaterialApp(

        title: 'Data Diri',
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
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text( "Dokumen Ktp",
                style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black,
                fontSize: 28),
            ),
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
            ),),
          body:  SingleChildScrollView(child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child:  Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,

                        margin: const EdgeInsets.only(left: 1.0, right: 1.0),
                        child: Image.asset(
                          "assets/images/step4.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 80,
              ),


              SizedBox(
                height: 10,
              ),
              Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child:  _showContent(context),
                  )

              ),
            ],
          ),) ,
          bottomSheet: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(25) ,
            child: Padding(
              padding: EdgeInsets.only(),
              child: InkWell(
                onTap: () {
                  print('hello');
                  //Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/alamat');
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
                  Text('Selanjutnya',
                    style: new TextStyle(fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.white),),),
                ),
              ),
            ),
          ),
        ),

        debugShowCheckedModeBanner: false,
      );

  }
  Widget _Buton(String text, VoidCallback callback){
    return  Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
         Container(
            child: Padding(

              padding: EdgeInsets.only(),
              child: InkWell(
                onTap: callback,
                /*() {
                  print('hello');
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Daftar berhasil',
                      desc: 'Registrasi berhasil',
                      btnOkOnPress: () {},
                      dismissOnTouchOutside: false
                  )..show();

                }*/
                child: new Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Color.fromARGB( 255,    148,193,44  ),
                    border: new Border.all(color: Color.fromARGB(255,148,193,44), width: 1.0),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Center(child: new Text(text, style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0, color: Colors.white),),),
                ),
              ),
            ),
          ),
        ]) ;
  }
  Widget _Textbox(IconData icon, String label){
    return  Column(
        children: <Widget>[
        SizedBox(
        height: 15,
        ),
      Container(
        child: Padding(
          padding: EdgeInsets.only(),
          child: TextField(
            style: TextStyle(color: Theme .of(context)  .accentColor),
            controller: null,
            decoration: InputDecoration(
              labelText: label,
              hintStyle: CustomTextStyle.formField(context),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(  color: Theme .of(context) .accentColor, width: 1.0)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide( color: Theme .of(context)  .accentColor, width: 1.0)),
              prefixIcon:  Icon(
                icon,
                color: Colors.black,
              ),
            ),
            obscureText: false,
          ),
        ),
        )
       ]) ;
  }
  Widget _showContent(context) {
    bool syaratketentuan = false;
    return

        Column(
          children: <Widget>[
             Row(
               mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,
               crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
               children: [
                 Column(
                   children: [
                     Container(
                       alignment: Alignment.center,
                       width: 150,
                       height: 120,
                       margin: const EdgeInsets.only(left: 0.0, right: 20.0),
                       child: Image.asset(
                         "assets/images/upload_foto_ktp.png",
                         fit: BoxFit.fitWidth,
                       ),
                     ),
                   ],)
                 ,
                 Column(
                   children: [
                     Container(
                       alignment: Alignment.center,
                       width: 150,
                       height: 120,
                       margin: const EdgeInsets.only(left: 20.0, right: 0.0),
                       child: Image.asset(
                         "assets/images/upload_selfie_ktp.png",
                         fit: BoxFit.fill,
                       ),
                     ),
                   ],)
             ],),

            SizedBox(height: 20,),
             Container( alignment: Alignment.centerLeft,
               child:  Text('Panduan Foto KTP',
               textAlign: TextAlign.left,
               style:
               TextStyle(fontWeight: FontWeight.w500,
                 fontSize: 18.0,
                 color: Colors.black,
               ),
             ),),

            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 120,
                      margin: const EdgeInsets.only(left: 0.0, right: 20.0),
                      child: Image.asset(
                        "assets/images/ktp.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],)
                ,
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 120,
                      margin: const EdgeInsets.only(left: 20.0, right: 0.0),
                      child: Image.asset(
                        "assets/images/ktp.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],)
              ],),

            SizedBox(height: 10,),
            Container(
              alignment: Alignment.centerLeft,
              child:  Text('Panduan Selfie KTP',
              textAlign: TextAlign.left,
              style:
              TextStyle(fontWeight: FontWeight.w500,
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),),

            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 120,
                      margin: const EdgeInsets.only(left: 0.0, right: 20.0),
                      child: Image.asset(
                        "assets/images/selfie.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],)
                ,
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 120,
                      margin: const EdgeInsets.only(left: 20.0, right: 0.0),
                      child: Image.asset(
                        "assets/images/selfie.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],)
              ],),
            SizedBox(height: 20,),
            Text('''
1. Pastikan foto wajah dan foto KTP Anda tidak blur
2. Pastikan foto wajah dan foto KTP Anda muat dalam layar foto atau foto tidak terpotong
3. Pastikan KTP Anda masih berlaku
4. Pastikan Anda mengambil foto KTP dan wajah versi asli, bukan scan atau fotokopi
            ''',
              style: new TextStyle(fontWeight: FontWeight.w500,
                  fontFamily: "Nunito",height: 1.5,
                  color: Color.fromARGB(255, 143, 143, 143),
                  fontSize: 14.0, ),
            ),


/*
            _Buton("Selanjutnya" , (){
              print('Document KTP');
              Navigator.of(context).pushNamed('/alamat');
            }),*/



            SizedBox(
              height: 100,
            ),


        ],
        );


  }




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