

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';
import 'package:grosir/menang_pembayar.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MenangBayar extends StatefulWidget {
  @override
  _MenangBayarState createState() => _MenangBayarState();
}



class _MenangBayarState extends State<MenangBayar> {

  void lanjutPembayaran() async {



    /* Navigator.push(context, new MaterialPageRoute(
        builder: (context) =>
        new MyHomePage())
    );


    Navigator.of(context).pushNamed('/home-page');
//or
    Navigator.pushedName(context, '/home-page');*/

    /* Navigator.pushNamed(
        context, "/menangpembayar" ,
        arguments :  nPolupate.getIn(index).asMap());*/




    Nson args = App.Arguments.get("args");
    double total = 0;
    if (args.containsKey("array")){
      for (var i = 0; i < args.get("array").size(); i++) {
        double itotal = args.get("array").getIn(i).get("tertinggi").asDouble();
         total = total + itotal;
      }
    }else{
      total = args.get("tertinggi").asDouble();
    }


    App.log(args.toStream());

    App.showBusy(context);
    Nson nson = await ApiService.get().generateVaApi(args) ;
    App.log(nson.toStream());

    Navigator.pop(context);
    if (nson.get("message").asString() == 'success'){

    }else{

    }


    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MenangPemBayar()),
    ) ;//MenangPemBayar
  }
  Nson args = Nson.newObject();
  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenUtil.instance = ScreenUtil.getInstance()
      ..init(context);
    ScreenUtil.instance =
    ScreenUtil(width: 750, height: 1304, allowFontScaling: true)
      ..init(context);*/
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if(arguments!=null){
      args = Nson(arguments);
    }else{
      args = App.Arguments.get("args");
    }
    App.log(args.toJson());


    return  Scaffold(
      appBar: AppBar(
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

      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20,bottom:30),
              alignment: Alignment.centerLeft,
              child: Text( "Pembayaran",
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 24),
              ),),


            SizedBox(
              height: 10,
            ),
            Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child:  _content(context),)

            ),
          ],
        ),
      ),
    );

  }

  Widget _content(context) {
    double total = 0;
    if (args.containsKey("array")){
      for (var i = 0; i < args.get("array").size(); i++) {
        double itotal = args.get("array").getIn(i).get("tertinggi").asDouble();
        total = total + itotal;
      }
    }else{
      total = args.get("tertinggi").asDouble();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
            "Total yang harus dibayar!", textAlign: TextAlign.center, style: TextStyle(
            fontFamily: "Nunito",
            color: Color.fromARGB(255, 143, 143, 143),
            fontWeight: FontWeight.w500,
            fontSize: 14)),
        SizedBox(
          height: 30,
        ),
        Text(
            "Rp "+App.formatCurrency(total),
            textAlign: TextAlign.center, style: TextStyle(
            fontFamily: "Nunito",fontWeight: FontWeight.w700,
            fontSize: 26)),
        SizedBox(
          height: 50,
        ),

        Text('Rincian Pembayaran' ,
            style:  TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.0,
              fontFamily: "Nunito",
              color: Colors.black,
            )
        ),

        SizedBox(
          height: 50,
        ),

      _TextSetting(context, "Harga Kendaraan:","Rp "+App.formatCurrency(total)),
      _TextSetting(context, "Biaya Admin:","Rp 0"),
      _TextSetting(context, "Total:","Rp "+App.formatCurrency(total)),

        SizedBox(
          height: 50,
        ),

        Container(
          margin: EdgeInsets.only(bottom: 10),
          alignment: Alignment.centerLeft,
            child:Text(
            "Metode pembayaran", textAlign: TextAlign.center, style: TextStyle(
                fontFamily: "Nunito", fontWeight: FontWeight.w500,
            fontSize: 15)),

        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,
          crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 120,
                  height: 120,
                  margin: const EdgeInsets.only(left: 0.0, right: 20.0),
                  child: Image.asset(
                    "assets/images/pembayaran_bca.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],)
            ,
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 120,
                  height: 120,
                  margin: const EdgeInsets.only(left: 20.0, right: 0.0),
                  child: Image.asset(
                    "assets/images/pembayaran_mandiri.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ],)
          ],),

        SizedBox(
          height: 50,
        ),

        SizedBox(
          height: 30,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap: () {
                print('hello');
                generateVA();
                //Navigator.of(context).pushNamed('/menangpembayar');
               /* Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new MenangPemBayar())
                );*/
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
                Text('Bayar',
                  style: new TextStyle(fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Colors.white),),),
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
  void generateVA()async {
          double total = 0;
          Nson arg = Nson.newObject();
          Nson byrs =   Nson.newArray();
          if (args.containsKey("array")){
            for (var i = 0; i < args.get("array").size(); i++) {
              double itotal = args.get("array").getIn(i).get("tertinggi").asDouble();
              byrs.add(  Nson.newObject().set("kik", args.get("array").getIn(i).get("kik").asString()) .set("bayar", itotal)  );
              total = total + itotal;
            }
          }else{
            total = args.get("tertinggi").asDouble();
            byrs.add(   Nson.newObject().set("kik", args.get("kik").asString()) .set("bayar", total)  );
          }
           
          arg.set("pilihBANK", "BCA");
          arg.set("totamount", total);
          arg.set("pilihunitbayar", byrs );
      
      
          App.log(arg.toStream());
      
          App.showBusy(context);
          Nson nson = await ApiService.get().generateVaApi(arg) ;
          App.log(nson.toStream());
      
          Navigator.pop(context);
          if (nson.get("status").asString() == 'success'){
            Navigator.of(context).pushNamed(  "/menangpembayar", arguments: nson.asMap());
          }else{
            App.showError(nson.get("description").asString() );
          }
  }
  Widget _TextSetting(context, String text, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(text ,
                style:  TextStyle(
                  fontWeight: FontWeight.w400,
                fontSize: 12.0,
                  fontFamily: "Nunito",
                  color: Color.fromARGB(255, 143, 143, 143),
                )
            ),
              ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(value,
                style:  TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  fontFamily: "Nunito",
                  color: Colors.black,
                )),
            ),
        ],),
    );
  }

  Widget horizontalLine() =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: 120,
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