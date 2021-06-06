

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/Nikita/app.dart';
import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LokasiUnit extends StatefulWidget {
  @override
  _LokasiUnitState createState() => _LokasiUnitState();
}



class _LokasiUnitState extends State<LokasiUnit> {
  GoogleMapController mapController;
  Set<Marker> _markers = {};
  final LatLng _center = const LatLng(-6.2697656,106.7824432);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  void initState() {
    super.initState();
    _markers.add(
        Marker(
            markerId: MarkerId('wakakka'),
            position: _center,
        )
    ) ;
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
    return
      ScreenUtilInit(
        designSize: Size(750, 1304),
        builder: () => MaterialApp(

          title: 'Flutter Demo',
          theme: ThemeData(

            primarySwatch: Colors.green,

            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home:
          Scaffold(

            appBar: AppBar(
              title: Text( "Lokasi Unit",
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 24),
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

            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(child:
            Column(
              children: <Widget>[

                SizedBox(
                  height: 20,
                ),
                Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child:  _content(context),)
                ),
              ],
            ),
            ) ,

            bottomSheet: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(25) ,
              child: Padding(
                padding: EdgeInsets.only(),
                child: InkWell(
                  onTap: () {
                    print('hello');
                     //Navigator.of(context).pop();
                    //_center
                      App.openMapnavigateTo(_center.latitude, _center.longitude);

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
                    Text('Arahkan ke lokasi',
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
  Widget
  textViewPembayaran(context, String text, String val ,{ bool copy}){
    copy = (copy==true?true:false);
    return
      Container(
        margin: EdgeInsets.only(bottom: 15),
        child:  Row(
        mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,
        crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
        children: [
          Container(
            width: MediaQuery.of(context).size.width/2 - 20,
            child:  Text(
                text, textAlign: TextAlign.left, style:
            TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w500,
                fontSize: 14)),
          ),
          Container(
            width: MediaQuery.of(context).size.width/2,
            child:
              Row(children: [ Text(
                  val, textAlign: TextAlign.left, style:
              TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
                  copy?
                  Container(
                    alignment: Alignment.center,
                    height: 12,
                    child: IconButton(
                    padding: EdgeInsets.all(0),
                    iconSize: 20,
                    //onPressed: () => _controller.clear(),
                    icon: Icon(Icons.content_copy),
                  ),)
                  :Text(''),
              ],) ,
          ),
        ],) ,)
      ;
  }
  Widget _content(context) {
    return Column(children: [
      _galeryCardLokasi(context, plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  selected :false),
      SizedBox(height: 10,),
      _mapView(context),
      SizedBox(height: 20,),
      Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Text( "Lokasi",
          style: TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 12),
        ),),

      SizedBox(
        height:10,
      ),
      Container(
        margin: EdgeInsets.only(left: 20,bottom:30),
        alignment: Alignment.centerLeft,
        child: Text( "Jl. Lengkong Gudang Timur Raya, Lengkong Gudang Tim., Kec. Serpong, Kota Tangerang Selatan, Banten 15310",
          style: TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 143, 143, 143),

              fontSize: 12),
        ),),

      SizedBox(
        height:10,
      ),
      ],)  ;
  }

  Widget _timeView(int digit) {
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
          color: Colors.white12,
          image: DecorationImage(
            image: AssetImage("assets/images/timebox.png"),
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.all(Radius.circular(7)),
          border: Border.all(
            width: 1.0,
            color: Colors.black12,
          )),
    );
  }
  Widget _mapView(context){
    return Container(
      height: 240,
      child:  GoogleMap(
        markers: _markers,
        mapType: MapType.normal,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
    ),);
  }

  Widget _galeryCardLokasi(context, {String plan, String title,  bool selected } ){
    Color color = selected?  Color(0xffE4F1BF):  Colors.white;
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(  Radius.circular(15)),
            side: BorderSide(width: 1, color: color)),

        color: color,
        margin: EdgeInsets.all(0.0),
        child: Container(
          /*
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red[700],
            ),

            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
      */
          child:  Row(
            children: [
              Expanded(
                flex: 2,
                child:
                Container(
                   height: 100,
                    margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.only( topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                      child: Image.asset(
                        "assets/images/mob1.png",
                        fit: BoxFit.cover,
                      ),
                    )
                ),
              ),
              Expanded(
                flex: 5,
                child:
                Container(
                  margin: EdgeInsets.only(left: 20),
                  padding: EdgeInsets.only(top: 15, right: 5),
                  child:
                  Column(children: [ Stack( children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Masserati DSE AT 2015",
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            color: Colors.black,

                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),



                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child:
                          Row(children: [
                            Text(
                              "NI 21231324 ",
                              style: const TextStyle(fontSize: 11.0,
                                fontFamily: "Nunito",
                                color: Color.fromARGB(255, 143, 143, 143),

                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              "Jakarta",
                              style: const TextStyle(fontSize: 11.0,
                                fontFamily: "Nunito",
                                color: Color.fromARGB(255, 148, 193, 44),

                              ),
                            ),
                          ],),
                        ),

                        SizedBox(height: 10,),
                        Text(
                          'Dimenangkan seharga',
                          style: const TextStyle(fontSize: 11.0 ,
                            fontFamily: "Nunito",
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'Rp 110.000.000',
                          style: const TextStyle(fontSize: 16.0,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,),
                        ),

                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: CircleAvatar(
                          child: Text("B",
                            style: TextStyle(
                              color: Colors.white,  fontWeight: FontWeight.w700, fontSize: 18 , ),
                          ),
                          backgroundColor:  Color.fromARGB(255, 148, 193, 44) ,
                        ),
                      ),),

                  ],),

                  ],),


                ),
              ),

            ],
          ) ,
        )
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