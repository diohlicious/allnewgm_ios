
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:grosir/Nikita/app.dart';


import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';

class Alamat extends StatefulWidget {
  @override
  _AlamatState createState() => _AlamatState();
}



class _AlamatState extends State<Alamat> {

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
            title: Text( "Alamat",
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

                  Navigator.of(context).pushNamed('/daftarpertanyaan');
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

  Map mPropinsi;
  @override
  void initState()   {
    super.initState();
    _onLoading().then((value) => {

    }).catchError(null);
  }

  Future<String>  _onLoading() async {
    App.showBusy(context);
    ApiService apiService = ApiService();

    //var response = await apiService.loginMasuk("baihakitanjung12@gmail.com", "123456789") ;
    var response = await apiService.Propinsi( ) ;
    print (response.body);
    mPropinsi = jsonDecode(response.body);

    response = await apiService.Kabupaten('' ) ;
    mPropinsi = jsonDecode(response.body);




    Navigator.pop(context); //pop dialog
    if (response.statusCode == 200) {
      //berhasil disini

    }else{

      App.showDialogBox(context, "Verifikasi Gagal","Gagal",  onClick: () async{
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/andaberhasil');//bypass

      });
    }

    return "";
  }

  Widget _Combo(IconData icon, String label, {String val}){
    String _valGender;
    List _listGender = [val];
    return  Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.only(left: 12),
            width: MediaQuery.of(context).size.width,
            child:
            Text(label, style: TextStyle(color: Colors.black54 ),),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            child:
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: 12,),
                Icon(
                  icon,
                  color: Colors.black,
                ),
                SizedBox(width: 12,),

                Column(
                    mainAxisSize: MainAxisSize.max,
                    children:[  DropdownButton(
                      hint: Container (
                        width: 260,
                        child: Text(label),),
                      value: _listGender[0],
                      items: _listGender.map((value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _valGender = value;
                        });
                      },
                    ),]
                ),],
            ),


          )
        ]) ;
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
          child:
          TextField(
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

            _Textbox(Icons.location_on, "Alamat Lengkap"),
            _Combo(Icons.location_on, "Provinsi", val: "Banten"),
            _Combo(Icons.location_on, "Kabupaten", val: "Tanggerang"),
            _Combo(Icons.location_on, "Kecamatan", val: "Serpong"),
            _Combo(Icons.location_on, "Kelurahan", val: "Rawabuntu"),
            _Combo(Icons.location_on, "Kodepos", val: "12400"),

           /* _Buton("Selanjutnya" , (){
              print('profile usaha');
              Navigator.of(context).pushNamed('/daftarpertanyaan');
            }),
*/
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