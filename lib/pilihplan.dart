
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';


import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';

class PilihPlan extends StatefulWidget {
  @override
  _PilihPlanState createState() => _PilihPlanState();
}



class _PilihPlanState extends State<PilihPlan> {

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
            title: Text( "Pilih Plan",
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
                          "assets/images/step5.png",
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

  Widget _PilihCard(  {String plan, String title, String desc, Color color, Color color2} ){
    return Card(
        color: Colors.lightBlue,
        margin: EdgeInsets.all(0.0),
        /*shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.lightGreen, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),*/
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
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
                        fontSize: 20.0,
                        color: Colors.white
                    ),
                  ) ,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Text(
                    "Dengan memilih plan ini berarti anda akan mendapakana segala benefit dari plat berikut",
                    style: TextStyle(fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        color: Colors.white
                    ),
                  ) ,
                ),
              ),

            ],


          )  ,
        )
    );
  }
  Widget _showContent(context) {
    bool syaratketentuan = false;
    return

        Column(
          children: <Widget>[
            _PilihCard(  plan: "BASIC", title: "1 Bulan = Rp 100.000", desc: "",
                color:Colors.black,  color2:Colors.lightGreen,
            ),
             SizedBox(height: 20,),
            _PilihCard(  plan: "PRO", title: "6 Bulan = Rp 500.000", desc: "",
              color:Colors.black12,  color2:Colors.lightBlue,
            ),

            SizedBox(height: 20,),
            _PilihCard(  plan: "MASTER", title: "6 Bulan = Rp 500.000", desc: "",
              color:Colors.orangeAccent,  color2:Colors.amberAccent,
            ),
            SizedBox(height: 00,),




            SizedBox(height: 0,),



            _Buton("Selesai" , (){
              Navigator.of(context).pushNamed('/andaberhasil');
            }),



            SizedBox(
              height: 10,
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