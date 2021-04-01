

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

Widget _galeryHeader(context, {String plan, String title, String desc, Color color, Color color2} ){
  return Container(
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.all(0.0),

      child: Container(
        margin: EdgeInsets.all(0.0),
        padding: EdgeInsets.all(0.0),
        width: MediaQuery.of(context).size.width,
        height: 250,
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: ExactAssetImage("assets/images/background.png"),
            ),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color,  color2
                ]
            )
        ) ,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, top: 50),
                child: Text(
                  plan,
                  style: TextStyle(fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: Colors.white
                  ),
                ) ,
              ),
            ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10,top: 5),
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w500,
                      fontFamily: "Nunito",fontSize: 18.0,
                      color: Colors.white
                  ),
                ) ,
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10,top: 5),
                child: Text(
                  desc,
                  style: TextStyle(fontWeight: FontWeight.w500,
                      fontFamily: "Nunito",  fontSize: 14.0,
                      color: Colors.white
                  ),
                ) ,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child:
           _Buton(context,  "Lihat Semua Kendaraan", (){
              Navigator.of(context).pushNamed('/lokasiunit');

            } ),

          )

          ], )  ,
      )
  );
}
Widget _Buton(context, String text, VoidCallback callback){
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
Widget _galeryCard(context, {String plan, String title,  Color color } ){
  return Card(
      color: color,
      margin: EdgeInsets.all(0.0),
      child: Container(
        height: 120,
        child:  Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, top: 30),
                child: Text(
                  plan,
                  style: TextStyle(fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: Colors.black
                  ),
                ) ,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10,top: 5),
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: Colors.black
                  ),
                ) ,
              ),
            ),
          ],


        )  ,
      )
  );
}

class Info extends StatefulWidget {

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  BuildContext buildContext;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    buildContext = context;
   return _InfoW(context);
  }
}

Widget _InfoW(context) {
  return
    Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _galeryHeader(context, plan: "Pemberitahuan ",title: "Live Grosir",desc: "12 November 2020",color: Colors.black,color2: Colors.orangeAccent),


        ],
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        alignment: Alignment.center,
        child:  Text("Belum ada info tersedia",
        style: new TextStyle(fontFamily: "Nunito",fontWeight: FontWeight.w700,fontSize: 22.0, color: Colors.black),
      ),
      ),

      SizedBox(
        height: 10,
      ),
      Image.asset(
        "assets/images/noinfo.png",
        fit: BoxFit.fill,
      ),
      //_galeryCard(context, plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  color: Colors.white ),
      SizedBox(
        height: 10,
      ),
     // _galeryCard(context, plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  color: Color.fromARGB(255, 250, 211, 212) ),


      Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        alignment: Alignment.center,
        child: Text("Terus pantau informasi dari kami, serta ikuti penawaran untuk mendapat informasi penawaran terbaru Anda",
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontFamily: "Nunito",
              color: Color.fromARGB(255, 143, 143, 143),
              height: 1.5,
              fontWeight: FontWeight.w600,fontSize: 14.0,
               ),
        ),
      ),

      SizedBox(
        height: 10,
      ),
      //_galeryCard(context, plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  color: Color.fromARGB(255, 233, 242, 212)   ),
      SizedBox(
        height: 10,
      ),


    ],
  );
}