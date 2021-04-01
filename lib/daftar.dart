
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/Nikita/app.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';

class Daftar extends StatefulWidget {
  @override
  _DaftarState createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  bool syaratketentuan = false;
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
    return  Scaffold(
      body:  SingleChildScrollView(child: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: 5.0),
              child:  Column(
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
                child: _showSignIn(context) ),

          ),
        ],
      ) ,),
    );
      /*MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:
        Scaffold(
          body:  SingleChildScrollView(child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child:  Column(
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
                    child: _showSignIn(context) ),

              ),
            ],
          ) ,),
        ),

        debugShowCheckedModeBanner: true,
      );*/

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
        Navigator.of(context).pushNamed('/ganti');//bypass

      });
    }

  }
  Widget _showSignIn(context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text("Daftar", textAlign: TextAlign.center,style: TextStyle(
            fontWeight: FontWeight.w500, fontFamily: "Nunito",
            fontSize: 24)),
        SizedBox(
          height: 20,
        ),
        Text("Registrasikan diri anda sekarang", textAlign: TextAlign.center,style: TextStyle(
            fontWeight: FontWeight.w500,fontFamily: "Nunito",
            fontSize: 14, color: Color.fromARGB(255, 143, 143, 143)
        )),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(50),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              style: TextStyle(color: Theme
                  .of(context)
                  .accentColor),
              controller: null,
              decoration: InputDecoration(
                labelText: "Nama Lengkap",
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
                  Icons.person_add,
                  color: Colors.black,
                ),
              ),
              obscureText: false,
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(50),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              style: TextStyle(color: Theme
                  .of(context)
                  .accentColor),
              controller: null,
              decoration: InputDecoration(
                labelText: "Nomor Telepone",
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
                  Icons.phone,
                  color: Colors.black,
                ),
              ),
              obscureText: false,
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(50),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: true,
              style: TextStyle(color: Theme
                  .of(context)
                  .accentColor),
              controller: null,
              decoration: InputDecoration(
                //Add th Hint text here.
                labelText: "Password",
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
                suffixIcon: const Icon(
                  Icons.visibility,
                  color: Colors.black,
                ),

              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(60),
        ),
        Container(
          child:  Column(
            children: [
              Row(
                children: [ Checkbox(
                  value: syaratketentuan,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      syaratketentuan = !syaratketentuan;
                    });
                  }),
                  Text('Dengan membuat akun, Anda menyetujui' ,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black45,
                        fontSize: 14),
                  ) ,
              ], )  ,
              Container(
                margin: EdgeInsets.only(left: 50),
                alignment: Alignment.topLeft,
                child: FlatButton(onPressed: (){
                    AwesomeDialog(      context: context,
                                        dialogType: DialogType.NO_HEADER,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'Syarat dan ketentuan Grosir Mobil',
                                        body:
                                            Column(children: [
                                              Text('Syarat dan ketentuan Grosir Mobil'  ,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500, fontFamily: "Nunito",
                                                      height: 1.2,fontSize: 22
                                                  )),
                                              SizedBox(height :10),
                                              Text('''
                    Dengan menggunakan Aplikasi ini, maka Anda berjanji dan menjamin kepada Kami untuk tidak akan melakukan tindakan-tindakan yang antara lain sebagai berikut:
                    1. Menggunakan Aplikasi dengan cara-cara yang dilarang oleh Kami maupun ketentuan peraturan perundang-undangan yang berlaku, maupun menggunakan Aplikasi dengan cara apapun yang dapat merusak, mematikan baik untuk sementara maupun seterusnya, membebani secara berlebihan atau melemahkan Aplikasi.
                    2. Mengunakan software tertentu yang dapat mengakses Aplikasi dan menyebabkan peningkatan jumlah panggilan terhadap server Kami dalam jangka waktu tertentu yang lebih dari jumlah panggilan normal yang dapat dilakukan oleh manusia.
                    3. Menyalin, menduplikasi, mengubah maupun menciptakan karya turunan dari Aplikasi, atau berupaya untuk menemukan sumber atau mengizinkan pihak ketiga
                                        '''
                                                ,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(

                                                    fontWeight: FontWeight.w500, fontFamily: "Nunito",
                                                    height: 1.5,
                                                    fontSize: 14, color: Color.fromARGB(255, 143, 143, 143)
                                                )
                                            )],

                                            ) ,

                                        btnOkOnPress: () {
                                           //Navigator.of(context).pop();
                                        },
                                        dismissOnTouchOutside: true
                                    ).show();
                },
                    padding: EdgeInsets.all(0),
                    child:
                Text('Syarat dan Ketentuan' ,textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255,148,193,44),
                      fontSize: 14),
                ) ) ,
              ),

            ],) ,
        ),

        SizedBox(
          height: ScreenUtil.getInstance().setHeight(80),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                horizontalLine(),
                Text("Daftar",
                    style: CustomTextStyle.body(context)),
                horizontalLine()
              ],
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap: () {
                print('hello');
                _onLoading();



              },
              child: new Container(
                width: 100.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  color: Color.fromARGB( 255,    148,193,44  ),
                  border: new Border.all(color: Color.fromARGB(255,148,193,44), width: 1.0),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Center(child: new Text('Daftar', style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0, color: Colors.white),),),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text("Sudah Punya Akun ? ", textAlign: TextAlign.center,style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,color: Color.fromARGB(255, 143, 143, 143))),
            FlatButton(
              onPressed:
                  (){
                print('masuk');
                Navigator.of(context).pop();
              }, child: Text("Masuk", textAlign: TextAlign.center,
                style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255,148,193,44),

                fontSize: 14)
            ),
            ),
          ],)

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