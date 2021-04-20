
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';


import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();

}






class _ProfileState extends State<Profile> {
  Nson profile = Nson.newObject();


  @override
  void initState() {
      super.initState();
      App.getSetting("profile").then((value) => handleValue(value) );
  }

  void handleValue(String value){
    App.log(value);
    profile = Nson.parseJson(value).get("data").get("logged_in_user");

    setState(() {
      App.log(profile.toJson());

    });
  }
  String _valGender;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return
      MaterialApp(
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:

        Scaffold(
          resizeToAvoidBottomInset: true,
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
          body:  SingleChildScrollView(child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0,left: 20),
                  child:  Text("Profil Saya",
                      style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w500,
                          fontSize: 24.0,
                          color: Colors.black))
                ),
                width: MediaQuery.of(context).size.width,
                height: 60,
              ),



              Container(
                child:  Row(children: [
                    Container(
                      width: 110,height: 100,
                      padding: EdgeInsets.only(top: 0,left: 20),
                      alignment:  Alignment.centerLeft ,
                      child:
                      FlatButton(
                        padding: EdgeInsets.all(0),
                        child:  CircleAvatar(
                          radius: 35,
                         /* child:  ClipRRect(
                            borderRadius: new BorderRadius.circular(100.0),
                            child:Image.network("https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                          ),*/
                          backgroundImage: NetworkImage (profile.get("user").get("profile_photo_url").asString()),// AssetImage("assets/images/profile.jpg"),
                          //profile.get("user").get("profile_photo_url").asString()
                        ),
                        onPressed: () {
                          // do something
                          Navigator.of(context).pushNamed('/take');

                        },
                      ),
                    ),


                    Column(children: [
                      Container(
                        width: 240,
                        alignment: Alignment.centerLeft,
                        child:
                        Text( profile.get("profil").get("NamaDealer").asString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w500,
                                fontSize: 24.0,
                                color: Colors.black)
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          width: 240,
                          alignment: Alignment.centerLeft,
                          child:
                          Text("Anda masih dalam proses verifikasi",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                color: Color.fromARGB(255, 143, 143, 143),
                              ))
                      ),
                  ],),
                ],) ,
              ) ,

              Container(
                 margin: EdgeInsets.only(left: 20, bottom: 20),
                  alignment: Alignment.centerLeft,
                  child:
                  Text("Data Diri",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.black,
                      ))
              ),
              _viewProfile("Nama Lengkap",  profile.get("profil").get("NamaDealer").asString()),
              _viewProfile("Nomor Telepon", profile.get("profil").get("NmTelpDealer").asString()),
              _viewProfile("Email",         profile.get("user").get("email").asString()),

              Container(
                  margin: EdgeInsets.only(top:30 ,left: 20, bottom: 20),
                  alignment: Alignment.centerLeft,
                  child:
                  Text("Alamat",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.black,
                      ))
              ),
              _viewProfile("Alamat Dealer",  profile.get("profil").get("AlamatDealer").asString()),
              _viewProfile("Provinsi",    profile.get("profil").get("Propinsi").asString()),
              _viewProfile("Kelurahan",    profile.get("profil").get("Kelurahan").asString()),
              _viewProfile("Kode Pos",    profile.get("profil").get("postal_code").asString()),
              Container(
                  margin: EdgeInsets.only(top:30 ,left: 20, bottom: 20),
                  alignment: Alignment.centerLeft,
                  child:
                  Text("Riwayat",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.black,
                      ))
              ),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child:
                  Row(children: [
                    Expanded(
                      flex: 3,
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "/profileriwayat",
                                arguments :  {'riwayat': "Berhasil"});
                          },
                          child:
                          Container(
                              width: 120,
                              height: 120,
                              margin: EdgeInsets.only( left: 20, right: 10),
                              alignment: Alignment.centerLeft,
                              child: Column(children: [
                                SizedBox(height: 13,),
                                Text(" Penawaran  berhasil",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22.0,
                                      color: Colors.white,
                                    )),
                                SizedBox(height: 15,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Image(image: ExactAssetImage("assets/images/pmenang.png")),
                                  SizedBox(width: 10,),
                                  Text("12 Unit",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ))
                                ],),
                              ],),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: ExactAssetImage("assets/images/profil_berhasil.png"),
                                ),

                              ) ,

                          ),


                         )


                    ),
                    Expanded(
                      flex: 3,
                      child:
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, "/profileriwayat" ,
                              arguments :  {'riwayat': "Kalah"});
                        },
                        child:

                        Container(
                          width: 120,
                          height: 120,
                          margin: EdgeInsets.only( left: 20, right: 10),
                          alignment: Alignment.centerLeft,
                          child: Column(children: [
                            SizedBox(height: 13,),
                            Text(" Penawaran  kalah",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22.0,
                                  color: Colors.white,
                                )),
                            SizedBox(height: 15,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(image: ExactAssetImage("assets/images/pkalah.png")),
                                SizedBox(width: 10,),
                                Text("12 Unit",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ))
                              ],),
                          ],),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: ExactAssetImage("assets/images/profil_kalah.png"),
                            ),

                          ) ,

                        ),

                      )

                    ),

                  ],)
              ),

              Container(
                  margin: EdgeInsets.only(top:30 ,left: 20, bottom: 20),
                  alignment: Alignment.centerLeft,
                  child:
                  Text("Akun",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.black,
                      ))
              ),

              FlatButton(
                onPressed: (){
                  Navigator.of(context).pushNamed('/ubah');
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20,top:10) ,
                  alignment: Alignment.centerLeft,
                  child: Text("Ubah Password",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 148, 193, 44),
                      ))
                ),
              ),

              FlatButton(
                onPressed: () {
                  App.newProses(context, () async {
                      Nson log = await ApiService.get().logoutApiMobile(Nson.newObject());
                      App.log(log.toJson());
                      App.log(log.toStream());
                  }, () {
                    App.setSetting("sign", "");
                    Navigator.of(context).pushNamed('/login');
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                  });
                },
                child: Container(
                    margin: EdgeInsets.only(left: 20,top:10) ,
                    alignment: Alignment.centerLeft,
                    child:Text("Keluar Akun",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 230, 36, 44),
                        ))
                ),
              ),

            ],
          ),) ,

        ),

        debugShowCheckedModeBanner: false,
      );

  }
  Widget _viewProfile(String label, String text){
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        alignment: Alignment.centerLeft,
        child:
        Row(children: [
          Expanded(
            flex: 3,
            child: Container(
                margin: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child:
                Text(label,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color:   Color.fromARGB(255, 143, 143, 143),
                    ))
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
                margin: EdgeInsets.only(  right: 10),
                alignment: Alignment.centerRight,
                child:
                Text(text,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Colors.black,
                    ))
            ),
          ),

        ],)
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
  Widget _Combo(IconData icon, String label){

    List _listGender = [label, "Female"];
    return  Column(
        children: <Widget>[
          SizedBox(
            height: 15,
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
                        value: _valGender,
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
            _Combo(Icons.credit_card, "Type Usaha"),
            _Textbox(Icons.credit_card, "Nama Dealer"),
            _Textbox(Icons.phone, "Nomor Telephone Dealer"),
            SizedBox(height: 100 ,),
           /* _Buton("Selanjutnya" , (){
              print('profile usaha');
              Navigator.of(context).pushNamed('/dokumen');
            }),*/

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