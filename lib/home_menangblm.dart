

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/menang_bayar.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

Widget _galeryHeader(context, {String plan, String title, String desc, Color color, Color color2} ){
  return Card(
      color: Colors.lightBlue,
      margin: EdgeInsets.all(0.0),
      /*shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.lightGreen, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),*/
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 190,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color,  color2
                ]
            )
        ) ,
        child:  Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, top: 15),
                child: Text(
                  plan,
                  style: TextStyle(fontWeight: FontWeight.w500,
                      fontSize: 20.0,
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
                  title,
                  style: TextStyle(fontWeight: FontWeight.w500,
                      fontSize: 18.0,
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
                      fontSize: 14.0,
                      color: Colors.white
                  ),
                ) ,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: _Buton(context,  "Lihat Semua Kendaraan", null),
            )

          ], )  ,
      )
  );
}
Widget _Butona(context, String text, VoidCallback callback){
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
        child:  Row(
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 120,
                  margin: const EdgeInsets.only(left: 0.0, right: 20.0),
                  child: Image.asset(
                    "assets/images/mobil.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],),
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
              child: Stack(
                children: [


                  Container(
                    alignment:  Alignment.centerRight ,
                    padding: EdgeInsets.only(top: 15, right: 5),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Masserati DSE AT 2015",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),


                        const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),

                        Text(
                          "NI 21231324 - Jakarta",
                          style: const TextStyle(fontSize: 10.0,
                              color: Colors.green
                          ),
                        ),


                        Padding(
                          padding: EdgeInsets.only(left: 120),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[

                              Checkbox(
                                value: false,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Dimenanangkan seharga',
                          style: const TextStyle(fontSize: 12.0),
                        ),
                        Stack(
                          children: [

                            Text(
                              'Rp 120.000.000',
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ], ),
                        SizedBox(height: 10,),

                      ],
                    ),
                  )],
              ),
            )
          ],
        ) ,
      )
  );
}

class BlmMenang extends StatefulWidget {
  @override
  _BlmMenangState createState() => _BlmMenangState();
}
class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
class _BlmMenangState extends State<BlmMenang> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _Content(context);
  }
}
Widget _TextSetting(context, String text, String value) {
  return Container(
    margin: EdgeInsets.only(bottom: 5),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(text),),
        Align(
          alignment: Alignment.centerRight,
          child: Text(value),),
      ],),
  );
}
Widget _Buton(BuildContext context, String text, VoidCallback callback){
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

Widget _Content(context) {
  return
    Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Menang", textAlign: TextAlign.center,style: TextStyle(
              fontFamily: "Nunito", fontWeight: FontWeight.w700,
              fontSize: 28
          ),),),

        SizedBox(
          height: 40,
        ),
        Text("Anda belum menang", textAlign: TextAlign.center,style: TextStyle(
            fontFamily: "Nunito", fontWeight: FontWeight.w500,
            fontSize: 22
        ),),
        SizedBox(
          height: 20,
        ),
        Image.asset("assets/images/belum_menang.png"),
        SizedBox(
          height: 20,
        ),

        Text("Anda belum memenangkan penawaran apapun. Telusuri semua kendaraan yang kami tawarkan dan lakukan tawar/buy now", textAlign: TextAlign.center,style: TextStyle(
          fontFamily: "Nunito",
          color: Color.fromARGB(255, 143, 143, 143),
          fontWeight: FontWeight.w500,height: 1.5,
          fontSize: 14,   )),
        SizedBox(
          height: 10,
        ),

        _Buton(context, "Telusuri Kendaraan", () {
            Navigator.of(context).pushNamed('/menang');
        }),

      ],
    ),
  );
}